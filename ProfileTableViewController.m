//
//  ProfileTableViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CreatorRatingTableViewCell.h"

#import "CurrentUserRequestViewController.h"

@interface ProfileTableViewController ()

@property (nonatomic) float averageRating;

@end

@implementation ProfileTableViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.currentUser) {
        self.currentUser = [User currentUser];
    }
    
    
    
    if (self.currentUser != [User currentUser]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
}

- (void)viewWillAppear:(BOOL)animated {
    [self getAverageRatings:self.currentUser];
}

#pragma mark - Helper Methods -

- (void)getAverageRatings:(User *)currentUser {
    
    PFQuery *query = [Rating query];
    [query whereKey:@"requestCreator" equalTo:currentUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        float totalScore = 0;
        
        for (Rating *rating in objects) {
            
            totalScore += rating.score;
            
        }
        
        float averageScore = totalScore / [objects count];
        
        // update ui
        
        self.averageRating = averageScore;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }];
    
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
        
        PFFile *imageFile = self.currentUser.profilePicture;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            cell.profilePicture.image = [UIImage imageWithData:data];
        }];
        
        cell.userNameLabel.text = self.currentUser.fullName;
        
        return cell;
    
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        CreatorRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        [cell updateStars:self.averageRating];
        [cell enableStarButtons:NO];
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
