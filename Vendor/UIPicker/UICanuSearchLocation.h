//
//  UICanuSearchLocation.h
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@class Location;

@interface UICanuSearchLocation : UIView

@property (retain) id delegate;
@property (nonatomic) int maxHeight;
@property (strong, nonatomic) MKMapItem *currentLocation;
@property (strong, nonatomic) MKMapItem *locationPicker;
@property (strong, nonatomic) NSString *searchLocation;
@property (strong, nonatomic) Location *selectedLocation;

- (void)reset;

- (void)forceLocationTo:(Location *)location;

@end

@protocol UICanuSearchLocationDelegate <NSObject>

@required

- (void)locationIsSelected:(Location *)location;

@end
