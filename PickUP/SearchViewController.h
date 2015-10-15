//
//  SearchViewController.h
//  GooglePlacesAutocomplete
//
//  Created by Adam Cooper on 11/3/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedLocation.h"

@protocol SearchViewControllerDropOffDelegate <NSObject>

- (void)dropOffLocation:(NSString *)dropOffLocation coordinate:(CLLocationCoordinate2D)coordinate cityName:(NSString *)cityName;

@end

@protocol SearchViewControllerDelegate <NSObject>

- (void)searchedLocation:(NSString *)pickUpLocation coordinate:(CLLocationCoordinate2D)coordinate cityName:(NSString *)cityName;

@end

@interface SearchViewController : UIViewController

@property SelectedLocation *selectedLocation;

@property (strong, nonatomic) id<SearchViewControllerDelegate> delegate;
@property (strong, nonatomic) id<SearchViewControllerDropOffDelegate> dropOffDelegate;

@end
