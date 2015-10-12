//
//  MessengerViewController.m
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "MessengerViewController.h"
#import "User.h"
#import "Message.h"

@interface MessengerViewController ()

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSMutableArray *messagesData;
@property (strong, nonatomic) JSQMessagesBubbleImageFactory *bubbleFactory;
@end

@implementation MessengerViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    self.currentUser = [User currentUser];
    self.senderDisplayName = [User currentUser].fullName;
    self.senderId = [User currentUser].objectId;
    
    self.messagesData = [NSMutableArray array];
//    [self fetchMessages];

    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark - Helper Methods -

- (void)fetchMessages {
    PFQuery *query = [Message query];
    [query whereKey:@"senderUser" equalTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (Message *message in objects) {
            
            [self.messagesData addObject:message];
        }
    }];
    
}

#pragma mark - JSQMessage Data source -

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (Message *)self.messagesData[indexPath.item];
    
}

/**
 *  Notifies the data source that the item at indexPath has been deleted.
 *  Implementations of this method should remove the item from the data source.
 *
 *  @param collectionView The collection view requesting this information.
 *  @param indexPath      The index path that specifies the location of the item.
 */
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.messagesData removeObjectAtIndex:indexPath.item];
}

/**
 *  Asks the data source for the message bubble image data that corresponds to the specified message data item at indexPath in the collectionView.
 *
 *  @param collectionView The collection view requesting this information.
 *  @param indexPath      The index path that specifies the location of the item.
 *
 *  @return An initialized object that conforms to the `JSQMessageBubbleImageDataSource` protocol. You may return `nil` from this method if you do not
 *  want the specified item to display a message bubble image.
 *
 *  @discussion It is recommended that you utilize `JSQMessagesBubbleImageFactory` to return valid `JSQMessagesBubbleImage` objects.
 *  However, you may provide your own data source object as long as it conforms to the `JSQMessageBubbleImageDataSource` protocol.
 *
 *  @warning Note that providing your own bubble image data source objects may require additional
 *  configuration of the collectionView layout object, specifically regarding its `messageBubbleTextViewFrameInsets` and `messageBubbleTextViewTextContainerInsets`.
 *
 *  @see JSQMessagesBubbleImageFactory.
 *  @see JSQMessagesCollectionViewFlowLayout.
 */
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.messagesData[indexPath.item] senderUser] == self.currentUser) {
        return [self.bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed: 80.0/255.0 green: 210.0/255.0 blue: 194.0/255.0 alpha: 1.0]];
    } else {
        
        return [self.bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed: 158.0/255.0 green: 37.0/255.0 blue: 143.0/255.0 alpha: 1.0]];
    }
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
    
    
    Message *message = [[Message alloc] initWithText:text sender:self.currentUser receiver:self.currentUser];
    
    [self.messagesData addObject:message];
    
    [message saveInBackground];
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - UICollectionView Datasource -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.messagesData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
    
}

@end
