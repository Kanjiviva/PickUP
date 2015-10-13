//
//  Messenger.m
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic senderUser;
@dynamic receiverUser;
@dynamic hashForMessage;
@dynamic messageText;

- (instancetype)initWithText:(NSString *)text sender:(User *)sender receiver:(User *)receiver
{
    self = [super init];
    if (self) {
        self.senderUser = sender;
        self.messageText = text;
        NSDate *now = [NSDate new];
        
        self.hashForMessage = [[NSNumber alloc] initWithUnsignedInteger:now.hash];
        self.receiverUser = receiver;
    }
    return self;
}

+ (NSString *)parseClassName {
    return @"Message";
}

- (NSString *)senderId {
    return self.senderUser.objectId;
}

- (NSString *)senderDisplayName {
    return self.senderUser.fullName;
}

- (NSDate *)date {
    return self.createdAt;
}

- (BOOL)isMediaMessage {
    return NO;
}

- (NSUInteger)messageHash {
    return [self.hashForMessage unsignedIntegerValue];
}

- (NSString *)text {
    return self.messageText;
}

//- (id<JSQMessageMediaData>)media;

@end
