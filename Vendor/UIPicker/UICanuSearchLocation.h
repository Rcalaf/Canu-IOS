//
//  UICanuSearchLocation.h
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface UICanuSearchLocation : UIView

@property (strong, nonatomic) MKMapItem *currentLocation;
@property (strong, nonatomic) MKMapItem *locationPicker;
@property (strong, nonatomic) NSString *searchLocation;

@end
