//
//  LocationManager.h
//  PickUP
//
//  Created by Steve on 2015-10-06.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

- (void)updateLocation:(CLLocation *)currentLocation;

@end

@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) id<LocationManagerDelegate> delegate;

+ (instancetype)sharedLocationManager;
- (void)startLocationManager:(UIViewController *)UIViewController;
- (void)setUpLocation;

@end
