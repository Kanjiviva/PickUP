//
//  CreatorTableViewController.h
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"
#import "User.h"

@interface CreatorTableViewController : UITableViewController

@property (strong, nonatomic) Request *request;
@property (strong, nonatomic) User *user;

@end
