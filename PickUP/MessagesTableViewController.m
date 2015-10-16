//
//  MessagesTableViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "MessengerTableViewCell.h"
#import "User.h"
#import "Message.h"
#import "MessengerViewController.h"
#import "Conversation.h"
#import "PickUP-Swift.h"

@interface MessagesTableViewController ()

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSMutableArray *allMessages;
@end

@implementation MessagesTableViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.currentUser = [User currentUser];
    self.allMessages = [NSMutableArray new];
    [self fetchAllComments];
    self.tableView.backgroundColor = [[UIColor alloc] initWithNetHex:0xFFF0D7];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [self fetchAllComments];
}

#pragma mark - Helper Method -

- (void)fetchAllComments {
    
    PFQuery *queryFrom = [Conversation query];
    [queryFrom whereKey:@"senderUser" equalTo:self.currentUser];
    
    
    PFQuery *queryTo = [Conversation query];
    [queryTo whereKey:@"receiverUser" equalTo:self.currentUser];
    
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryFrom, queryTo]];
    [query includeKey:@"receiverUser"];
    [query includeKey:@"senderUser"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (Message *message in objects) {
            
            [array addObject:message];
            
        }
        
        self.allMessages = array;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showChat"]) {
        MessengerViewController *messageVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Conversation *conversation = self.allMessages[indexPath.row];
        messageVC.requestCreator = ([conversation.receiverUser.objectId isEqualToString:[User currentUser].objectId ] ? conversation.senderUser : conversation.receiverUser);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allMessages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessengerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Conversation *conversation = self.allMessages[indexPath.row];
    
    cell.conversation = conversation;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Conversation *conversation = self.allMessages[indexPath.row];
        [conversation deleteInBackground];
        [conversation saveInBackground];
        
        [self.allMessages removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
