//
//  ActivityMapViewController.h
//  CANU
//
//  Created by Roger Calaf on 27/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ActivityMapViewController : UIViewController

@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) NSArray *activities;

@end
