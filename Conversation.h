//
//  Conversation.h
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>
#import "User.h"

@interface Conversation : PFObject <PFSubclassing>

@property (strong, nonatomic) User *senderUser;
@property (strong, nonatomic) User *receiverUser;

- (instancetype)initWithSender:(User *)sender receiver:(User *)receiver;

@end
