//
//  Messenger.h
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "JSQMessage.h"
#import "User.h"

@interface Message : PFObject <PFSubclassing, JSQMessageData>

@property (strong, nonatomic) User *senderUser;
@property (strong, nonatomic) User *receiverUser;
@property (strong, nonatomic) NSNumber *hashForMessage;
@property (strong, nonatomic) NSString *messageText;

- (instancetype)initWithText:(NSString *)text sender:(User *)sender receiver:(User *)receiver;

@end
