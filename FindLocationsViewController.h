//
//  FindLocationsViewController.h
//  CANU
//
//  Created by Roger Calaf on 19/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

extern NSString *const FindLocationDissmised;

@interface FindLocationsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *ibSearchBar;
@property (strong, nonatomic) IBOutlet MKMapView *ibMapView;
@property (strong, nonatomic) MKMapItem *chosenLocation;

@end
