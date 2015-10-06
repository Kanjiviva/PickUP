//
//  ProfileTableViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileTableViewCell.h"
#import "PhoneTableViewCell.h"
#import "RatingTableViewCell.h"
#import "CommentTableViewCell.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
        return 3;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        PFUser *currentUser = [PFUser currentUser];
        PFFile *imageFile = [currentUser objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            cell.profilePicture.image = [UIImage imageWithData:data];
        }];
        
        cell.userNameLabel.text = [currentUser objectForKey:@"fullName"];
        
        return cell;
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        PhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 2 && indexPath.section == 0) {
        RatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

@end
