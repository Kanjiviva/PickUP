//
//  Rating.m
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "Rating.h"


@implementation Rating

@dynamic requestCreator;
@dynamic ratingCreator;
@dynamic comment;
@dynamic score;

+ (NSString *)parseClassName {
    return @"Rating";
}

@end
