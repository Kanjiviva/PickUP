//
//  DetailViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-08.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "DetailViewController.h"
#import "PickUp.h"
#import "CreatorTableViewController.h"
#import "PickUP-Swift.h"
#import "MessengerViewController.h"
#import "Conversation.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemDescription;
@property (weak, nonatomic) IBOutlet UILabel *itemCost;
@property (weak, nonatomic) IBOutlet UILabel *itemPickUpLocation;
@property (weak, nonatomic) IBOutlet UILabel *itemDeliverLocation;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.request.creatorUser.objectId isEqualToString:[User currentUser].objectId]) {
        self.messageButton.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.request.isAccepted && [self.request.creatorUser.objectId isEqualToString:[User currentUser].objectId]) {
        [self.messageButton setTitle:@"Talk to Deliver" forState:UIControlStateNormal];
        self.messageButton.hidden = NO;
    }
    
    [self setup];
}

- (void)setRequest:(Request *)request {
    _request = request;
    
    [self setup];
}

- (void)setup {
    
    if (self.request) {
        self.itemTitle.text = self.request.itemTitle;
        self.itemDescription.text = self.request.itemDescription;
        self.itemCost.text = [NSString stringWithFormat:@"%.2f", self.request.itemCost];
        self.itemPickUpLocation.text = self.request.pickupLocation.location;
        self.itemDeliverLocation.text = self.request.deliverLocation;
        
        PFFile *imageFile = self.request.itemImage;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            self.itemImage.image = [UIImage imageWithData:data];
        }];
        
    }
}

- (void)checkExistingConversation {
    
    PFQuery *checkReceiver = [Conversation query];
    [checkReceiver whereKey:@"receiverUser" equalTo:self.request.creatorUser];
    [checkReceiver whereKey:@"senderUser" equalTo:[User currentUser]];
    
    PFQuery *checkSender = [Conversation query];
    [checkSender whereKey:@"receiverUser" equalTo:[User currentUser]];
    [checkSender whereKey:@"senderUser" equalTo:self.request.creatorUser];
    
    PFQuery *combined = [PFQuery orQueryWithSubqueries:@[checkReceiver, checkSender]];
    [combined findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if ([objects count] == 0) {
            Conversation *conversation = [[Conversation alloc] initWithSender:[User currentUser] receiver:self.request.creatorUser];
            [conversation saveInBackground];
        }
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCreator"]) {
        CreatorTableViewController *creatorVC = segue.destinationViewController;
        creatorVC.request = self.request;
        
    } else if ([segue.identifier isEqualToString:@"showMessage"]) {
        MessengerViewController *messageVC = segue.destinationViewController;
        [self checkExistingConversation];
        if ([self.request.creatorUser.objectId isEqualToString:[User currentUser].objectId]) {
            messageVC.requestCreator = self.request.assignedUser;
        } else {
            messageVC.requestCreator = self.request.creatorUser;
        }
        
        
        
    } else if ([segue.identifier isEqualToString:@"showDirection"]) {
        DetailMapViewController *detailMapVC = segue.destinationViewController;
        detailMapVC.request = self.request;
        
    }
}

@end
