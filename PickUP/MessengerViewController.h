//
//  MessengerViewController.h
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h>
#import "User.h"

@interface MessengerViewController : JSQMessagesViewController

@property (strong, nonatomic) User *requestCreator;

@end
