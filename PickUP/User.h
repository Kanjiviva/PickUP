//
//  User.h
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Rating.h"

@interface User : PFUser

@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *fullName;
//@property (strong, nonatomic) Rating *comment;
@property (strong, nonatomic) PFFile *profilePicture;
//@property (strong, nonatomic) PFRelation *ratings;
//@property (strong, nonatomic) PFRelation *requests;

@end
