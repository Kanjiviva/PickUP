//
//  CurrentUserRequestViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-07.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CurrentUserRequestViewController.h"
#import "Request.h"

@interface CurrentUserRequestViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchStatus;

@property (strong, nonatomic) NSMutableArray *currentUserPosts;
@property (strong, nonatomic) NSMutableArray *currentUserAccepted;

@end

@implementation CurrentUserRequestViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUserPosts = [NSMutableArray new];
    self.currentUserAccepted = [NSMutableArray new];
    self.statusLabel.text = @"Active Requests";
    
    [self storeCurrentUserPosts];
    [self storeCurrentUserAccepted];
}

#pragma mark - Actions -

- (IBAction)switchStatusControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        [self.tableView reloadData];
        self.statusLabel.text = @"Active Requests";
        
    } else if (sender.selectedSegmentIndex == 1) {
        [self.tableView reloadData];
        self.statusLabel.text = @"Accepted Requests";
        
    }
    
}

#pragma mark - Helper Methods -

- (void)storeCurrentUserPosts {
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%creatorUser = %@", self.currentUser.objectId];
//    PFQuery *query = [Request queryWithPredicate:predicate];
    PFQuery *query = [Request query];
    [query whereKey:@"creatorUser" equalTo:self.currentUser];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            [self.currentUserPosts addObjectsFromArray:objects];
            [self.tableView reloadData];
    }];
}

- (void)storeCurrentUserAccepted {
    PFQuery *query = [Request query];
    [query whereKey:@"assignedUser" equalTo:self.currentUser];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.currentUserAccepted addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}

#pragma mark - Tableview Data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.switchStatus.selectedSegmentIndex == 0) {
        return [self.currentUserPosts count];
    } else {
        return [self.currentUserAccepted count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    
    if (self.switchStatus.selectedSegmentIndex == 0) {
        Request *request = self.currentUserPosts[indexPath.row];
        cell.textLabel.text = request.itemTitle;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Pick Up Location: %@", request.pickupLocation.location];
    } else if (self.switchStatus.selectedSegmentIndex == 1) {
        Request *request = self.currentUserAccepted[indexPath.row];
        cell.textLabel.text = request.itemTitle;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Pick Up Location: %@", request.pickupLocation.location];
    }
    
    return cell;
}

@end
