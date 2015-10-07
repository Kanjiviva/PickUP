//
//  Rating.h
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>

@class User;

@interface Rating : PFObject <PFSubclassing>

@property (strong, nonatomic) User *creator;
@property (strong, nonatomic) User *deliver;
@property (strong, nonatomic) NSString *comment;
@property (nonatomic) float score;

@end
