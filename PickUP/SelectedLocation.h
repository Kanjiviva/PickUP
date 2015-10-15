//
//  SelectedLocation.h
//  GooglePlacesAutocomplete
//
//  Created by Steve on 2015-10-15.
//  Copyright © 2015 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SelectedLocation : NSObject
@property NSString *name;
@property NSString *address;
@property CLLocationCoordinate2D locationCoordinates;
@property NSString *cityName;
@end
