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
@property (strong, nonatomic) MKMapItem *currentLocation;
@property (strong, nonatomic) MKMapItem *locationPicker;
@property (strong, nonatomic) NSString *searchLocation;
@property (strong, nonatomic) Location *selectedLocation;

- (id)initWithFrame:(CGRect)frame ForMap:(BOOL)isMap;

- (void)reset;

- (void)addResult:(NSMutableArray *)response;

@end

@protocol UICanuSearchLocationDelegate <NSObject>

@required

- (void)locationIsSelected:(Location *)location;

@optional

- (void)searchWithTheMap;

@end
