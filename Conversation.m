//
//  Conversation.m
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

@dynamic senderUser;
@dynamic receiverUser;

- (instancetype)initWithSender:(User *)sender receiver:(User *)receiver
{
    self = [super init];
    if (self) {
        self.senderUser = sender;
        self.receiverUser = receiver;
    }
    return self;
}

+ (NSString *)parseClassName {
    return @"Conversation";
}

@end
