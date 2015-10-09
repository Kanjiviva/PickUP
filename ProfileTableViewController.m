//
//  ProfileTableViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileTableViewCell.h"
#import "RatingTableViewCell.h"
#import "CommentTableViewCell.h"
#import "User.h"
#import "CurrentUserRequestViewController.h"

@interface ProfileTableViewController ()

@property (strong, nonatomic) User *currentUser;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User currentUser];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
//        User *currentUser = [User currentUser];
        PFFile *imageFile = self.currentUser.profilePicture;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            cell.profilePicture.image = [UIImage imageWithData:data];
        }];
        
        cell.userNameLabel.text = self.currentUser.fullName;
        
        return cell;
    
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        RatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRequests"]) {
        UINavigationController *nav = segue.destinationViewController;
        CurrentUserRequestViewController *curVC = (CurrentUserRequestViewController *)[nav topViewController];
        curVC.currentUser = self.currentUser;
    }
}

@end
