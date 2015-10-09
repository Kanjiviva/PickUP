//
//  CreatorTableViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "CreatorTableViewController.h"
#import "CreatorCommentTableViewCell.h"
#import "CreatorProfileTableViewCell.h"
#import "CreatorRatingTableViewCell.h"
#import "User.h"

@interface CreatorTableViewController ()


@end

@implementation CreatorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.request = [Request object];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions -

- (IBAction)doneViewing:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        CreatorProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.username.text = self.request.creatorUser.fullName;
        PFFile *imageFile = self.request.creatorUser.profilePicture;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            cell.profilePicture.image = [UIImage imageWithData:data];
        }];
        
        return cell;
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        CreatorRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        CreatorCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"Profile";
    else if (section == 1) return @"Add a comment";
    return @"Comments";
}

- (IBAction)doneButton:(id)sender {
    
}
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
