//
//  AddRequestViewController.h
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Request.h"

@protocol AddRequestViewContollerDelegate <NSObject>

- (void)didAddNewItem:(Request *)request;

@end
@interface AddRequestViewController : UIViewController

@property (strong, nonatomic) id<AddRequestViewContollerDelegate> delegate;
@end
