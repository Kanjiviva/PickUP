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
#import "Rating.h"
#import "CommentTableViewCell.h"

@interface CreatorTableViewController ()

@property (strong, nonatomic) Rating *rating;

@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation CreatorTableViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    self.comments = [NSMutableArray new];
    self.rating = [Rating object];
    self.rating.ratingCreator = [User currentUser];
    self.rating.requestCreator = self.request.creatorUser;
    
    [self getAllComments];
    
}

#pragma mark - Helper Methods -

- (void)getAllComments {
    
    PFQuery *query = [Rating query];
    [query whereKey:@"requestCreator" equalTo:self.rating.requestCreator];
    [query whereKey:@"comment" notEqualTo:[NSNull null]];
    [query includeKey:@"ratingCreator"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        for (Rating *rating in objects) {
            
            [self.comments addObject:rating];
            
        }
        NSLog(@"%@", self.comments);
        [self.tableView reloadData];
        
    }];
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
    } else {
        NSLog(@"%@", self.comments);
        return [self.comments count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        CreatorProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.username.text = self.request.creatorUser.fullName;
        PFFile *imageFile = self.request.creatorUser.profilePicture;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2;
            cell.profilePicture.clipsToBounds = YES;
            cell.profilePicture.image = [UIImage imageWithData:data];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.row == 1 && indexPath.section == 0) {
        CreatorRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        
        cell.rating = self.rating;
        [cell enableStarButtons:YES];
        [cell updateStars:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 0 && indexPath.section == 1) {
        CreatorCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        
        cell.rating = self.rating;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
        
        Rating *rating = self.comments[indexPath.row];
        cell.rating = rating;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"Profile";
    else if (section == 1) return @"Add a comment";
    return @"Comments";
}

#pragma mark - Actions -

- (IBAction)doneButton:(id)sender {
    [self.rating saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
