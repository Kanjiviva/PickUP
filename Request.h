//
//  Request.h
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@interface Request : PFObject <PFSubclassing>

@property (strong, nonatomic) PFFile *itemImage;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *itemTitle;
@property (nonatomic) float itemCost;
@property (nonatomic) float deliverTip;
@property (strong, nonatomic) User *creatorUser;
@property (strong, nonatomic) User *assignedUser;
@property (strong, nonatomic) PFGeoPoint *delCoordinate;
@property (strong, nonatomic) NSString *delLocation;

@end
