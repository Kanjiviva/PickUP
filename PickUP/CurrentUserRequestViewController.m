//
//  CurrentUserRequestViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-07.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CurrentUserRequestViewController.h"
#import "Request.h"
#import "SWTableViewCell.h"
#import "DetailViewController.h"

@interface CurrentUserRequestViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchStatus;

@property (strong, nonatomic) NSMutableArray *creatorRequests;
@property (strong, nonatomic) NSMutableArray *assignedAccepted;

@end

@implementation CurrentUserRequestViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.statusLabel.text = @"Accepted Requests";

    self.creatorRequests = [NSMutableArray new];
    self.assignedAccepted = [NSMutableArray new];
    
    if (!self.currentUser) {
        self.currentUser = [User currentUser];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = @"My Requests";
    }
    
    [self storeCurrentUserPosts];
    [self storeCurrentUserAccepted];
    
}

#pragma mark - Actions -

- (IBAction)switchStatusControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
        
        
        // hit network
        [self storeCurrentUserAccepted];
        
        
        self.statusLabel.text = @"Accepted Requests";
        
    } else if (sender.selectedSegmentIndex == 1) {
        [self.tableView reloadData];
        
        // hit network
        [self storeCurrentUserPosts];
        
        self.statusLabel.text = @"My Requests";
    }
    
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Prepare for segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.switchStatus.selectedSegmentIndex == 0) {
        if ([segue.identifier isEqualToString:@"showRequestsDetail"]) {
            
            DetailViewController *detailVC = segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSArray *getRequests = self.assignedAccepted[indexPath.section];
            Request *request = getRequests[indexPath.row];
            [detailVC setRequest:request];
            
        }
    } else if (self.switchStatus.selectedSegmentIndex == 1) {
        if ([segue.identifier isEqualToString:@"showRequestsDetail"]) {
            DetailViewController *detailVC = segue.destinationViewController;
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSArray *getRequests = self.creatorRequests[indexPath.section];
            Request *request = getRequests[indexPath.row];
            [detailVC setRequest:request];
        }
    }
    
}

#pragma mark - Helper Methods -

- (void)loadRole:(NSString *)whichUser sortedBy:(NSString *)sortfield intoArray:(NSMutableArray *)array {
    PFQuery *query = [Request query];
    [query whereKey:whichUser equalTo:self.currentUser];
    [query includeKey:@"pickupLocation"];
    [query includeKey:@"creatorUser"];
    [query includeKey:@"assignedUser"];
    [query orderByDescending:sortfield];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        NSMutableArray *unfinished = [NSMutableArray array];
        NSMutableArray *finished = [NSMutableArray array];
        
        for (Request *request in objects) {
            if (request.isDone) {
                [finished addObject:request];
            } else {
                [unfinished addObject:request];
            }
        }
        
        [array removeAllObjects];
        [array addObjectsFromArray:@[unfinished, finished]];
        [self.tableView reloadData];
    }];
}

- (void)storeCurrentUserPosts {
    
    [self loadRole:@"creatorUser" sortedBy:@"createdAt" intoArray:self.creatorRequests];
    
}

- (void)storeCurrentUserAccepted {
    
    [self loadRole:@"assignedUser" sortedBy:@"updatedAt" intoArray:self.assignedAccepted];
    
}


#pragma mark - Custom buttons -

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Unassign"];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                title:@"Done"];
    
    return rightUtilityButtons;
}


#pragma mark - Tableview Data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.switchStatus.selectedSegmentIndex == 0) {
        return [self.assignedAccepted count];
    } else {
        return [self.creatorRequests count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.switchStatus.selectedSegmentIndex == 0) {
        return [self.assignedAccepted[section] count];
    } else {
        return [self.creatorRequests[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (self.switchStatus.selectedSegmentIndex == 0) {
        
        NSArray *getRequests = self.assignedAccepted[indexPath.section];
        
        
        Request *request = getRequests[indexPath.row];
        
        cell.textLabel.text = request.itemTitle;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Pick Up Location: %@", request.pickupLocation.location];
        
        if (indexPath.section == 0) {
            cell.rightUtilityButtons = [self rightButtons];
            cell.delegate = self;
        } else {
            cell.rightUtilityButtons = nil;
            cell.delegate = nil;
        }
        
        
    } else if (self.switchStatus.selectedSegmentIndex == 1) {
        
        NSArray *getRequests = self.creatorRequests[indexPath.section];
        
        Request *request = getRequests[indexPath.row];
        
        if (request.isAccepted) {
            cell.backgroundColor = [UIColor colorWithHue:130.0f / 360.0f
                                              saturation:0.68f
                                              brightness:0.84f
                                                   alpha:1.0f];
        }
        
        cell.textLabel.text = request.itemTitle;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Pick Up Location: %@", request.pickupLocation.location];
        cell.rightUtilityButtons = nil;
        cell.delegate = nil;
    }
    
    return cell;
}

#pragma mark - Tableview delegate -

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return [NSString stringWithFormat:@"Unfinished"];
    } else if (section == 1){
        return [NSString stringWithFormat:@"Finished"];
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRequestsDetail" sender:self];
}

#pragma mark - Custom Tableview cell delegate -

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            
            NSArray *getRequests = self.assignedAccepted[cellIndexPath.section];
            
            Request *request = getRequests[cellIndexPath.row];
            [request removeObjectForKey:@"assignedUser"];
            [request removeObjectForKey:@"isAccepted"];
            [request saveInBackground];
            [self.assignedAccepted[0] removeObject:request];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 1:
        {
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            NSArray *getRequests = self.assignedAccepted[cellIndexPath.section];
            
            Request *request = getRequests[cellIndexPath.row];
            request.isDone = YES;
            [request saveInBackground];
            [self.assignedAccepted[0] removeObject:request];
            [self.assignedAccepted[1] addObject:request];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

@end
