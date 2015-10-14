//
//  MessengerViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "MessengerViewController.h"

#import "Message.h"

@interface MessengerViewController ()

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSMutableArray<Message *> *messagesData;
@property (strong, nonatomic) JSQMessagesBubbleImageFactory *bubbleFactory;
@end

@implementation MessengerViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    self.currentUser = [User currentUser];
    self.senderDisplayName = [User currentUser].fullName;
    self.senderId = [User currentUser].objectId;
    
    self.bubbleFactory = [JSQMessagesBubbleImageFactory new];
    
    self.messagesData = [NSMutableArray array];
    
    
    
    [self fetchMessages];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(fetchMessages)
                                   userInfo:nil
                                    repeats:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark - Helper Methods -

- (void)fetchMessages {
    PFQuery *currentUserSent = [Message query];
    [currentUserSent whereKey:@"senderUser" equalTo:self.currentUser];
    [currentUserSent whereKey:@"receiverUser" equalTo:self.requestCreator];
    
    PFQuery *receiverSent = [Message query];
    [receiverSent whereKey:@"senderUser" equalTo:self.requestCreator];
    [receiverSent whereKey:@"receiverUser" equalTo:self.currentUser];
    
    PFQuery *combined = [PFQuery orQueryWithSubqueries:@[currentUserSent, receiverSent]];
    [combined setCachePolicy:kPFCachePolicyCacheThenNetwork];
    [combined orderByAscending:@"createdAt"];
    [combined findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (Message *message in objects) {
            
            [array addObject:message];
            
        }
        
        if (self.messagesData.count != [array count]) {
            self.messagesData = array;
            [self.collectionView reloadData];
        }
        
    }];
    
}

- (void)pushNotificationWhenMessageSent {
    PFQuery *query = [PFInstallation query];
    [query whereKey:@"userNotification" equalTo:self.requestCreator];
    PFPush *iOSPush = [[PFPush alloc] init];
    [iOSPush setMessage:@"You got a new Message!"];
    [iOSPush setQuery:query];
    [iOSPush sendPushInBackground];
    
}

#pragma mark - JSQMessage Data source -

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.messagesData[indexPath.item];
    
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.messagesData removeObjectAtIndex:indexPath.item];
}


- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.messagesData objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return [self.bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithHue:240.0f / 360.0f
                                                                                  saturation:0.02f
                                                                                  brightness:0.92f
                                                                                       alpha:1.0f]];
    }
    
    return [self.bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithHue:130.0f / 360.0f
                                                                              saturation:0.68f
                                                                              brightness:0.84f
                                                                                   alpha:1.0f]];
}

/**
 *  Asks the data source for the avatar image data that corresponds to the specified message data item at indexPath in the collectionView.
 *
 *  @param collectionView The collection view requesting this information.
 *  @param indexPath      The index path that specifies the location of the item.
 *
 *  @return A initialized object that conforms to the `JSQMessageAvatarImageDataSource` protocol. You may return `nil` from this method if you do not want
 *  the specified item to display an avatar.
 *
 *  @discussion It is recommended that you utilize `JSQMessagesAvatarImageFactory` to return valid `JSQMessagesAvatarImage` objects.
 *  However, you may provide your own data source object as long as it conforms to the `JSQMessageAvatarImageDataSource` protocol.
 *
 *  @see JSQMessagesAvatarImageFactory.
 *  @see JSQMessagesCollectionViewFlowLayout.
 */
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
    Message *message = [[Message alloc] initWithText:text sender:self.currentUser receiver:self.requestCreator];
    
    [self.messagesData addObject:message];
    
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    [self finishSendingMessageAnimated:YES];
    [self pushNotificationWhenMessageSent];
    
}

#pragma mark - UICollectionView Datasource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.messagesData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
//    cell.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
    
}

@end
