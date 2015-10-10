//
//  Rating.h
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>

@class User;

@interface Rating : PFObject <PFSubclassing>

@property (strong, nonatomic) User *requestCreator; // made the request
@property (strong, nonatomic) User *ratingCreator; // did the request
@property (strong, nonatomic) NSString *comment;
@property (nonatomic) float score;

@end
