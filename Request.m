//
//  Request.m
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "Request.h"

@implementation Request

@dynamic itemImage;
@dynamic itemDescription;
@dynamic itemTitle;
@dynamic itemCost;
@dynamic deliverTip;
@dynamic creatorUser;
@dynamic assignedUser;
@dynamic deliverLocation;
@dynamic delCoordinate;
@dynamic pickupLocation;

+ (NSString *)parseClassName {
    return @"Request";
}

@end
