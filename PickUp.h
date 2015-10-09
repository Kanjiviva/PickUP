//
//  PickUp.h
//  PickUP
//
//  Created by Steve on 2015-10-05.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>

@interface PickUp : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) PFGeoPoint *coordinate;
@property (strong, nonatomic) NSString *cityName;

@end
