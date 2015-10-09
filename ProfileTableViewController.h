//
//  ProfileTableViewController.h
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileTableViewController : UITableViewController

@property (strong, nonatomic) User *currentUser;

@end
