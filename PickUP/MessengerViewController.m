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
@end

@implementation MessengerViewController

#pragma mark - Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
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
    return nil;
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

#pragma mark - UICollectionView

@end
