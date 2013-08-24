//
//  NewActivityViewController.h
//  CANU
//
//  Created by Roger Calaf on 04/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class Activity;

@interface NewActivityViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UISearchDisplayDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) Activity *activity;

- (IBAction)createActivity:(id)sender;
- (IBAction)goBack:(id)sender;


@end



