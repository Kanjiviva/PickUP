//
//  MessengerTableViewCell.h
//  PickUP
//
//  Created by Steve on 2015-10-12.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@interface MessengerTableViewCell : UITableViewCell

@property (strong, nonatomic) Conversation *conversation;

@end
