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
#import "Request.h"

@interface CreatorTableViewController ()


@end

@implementation CreatorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions -

- (IBAction)doneViewing:(UIBarButtonItem *)sender {
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
        CreatorProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        Request *request = [Request object];
        cell.username.text = request.creatorUser.username;
        
        
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


@end
