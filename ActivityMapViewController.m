//
//  ActivityMapViewController.m
//  CANU
//
//  Created by Roger Calaf on 27/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "ActivityMapViewController.h"
#import "DetailActivityViewController.h"
#import "Activity.h"

@interface ActivityMapViewController () <MKMapViewDelegate>

@end

@implementation ActivityMapViewController

@synthesize map = _map;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reload:(id)sender
{
    [Activity publicFeedWithCoorindate:CLLocationCoordinate2DMake(-200, -200) WithBlock:^(NSArray *activities, NSError *error) {
            
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
             [_map addAnnotations:activities];
            activities = nil;
            //_activities = activities;
        }
    }];
    
}


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = backgroundColorView;
    _map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, -20.0f, 480.0f + KIphone5Margin, 340.0f)];
    [self.view addSubview:_map];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.map.delegate = self;
    [self.map setUserInteractionEnabled:YES];
    [self.map setUserTrackingMode:MKUserTrackingModeNone];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[self.map setUserTrackingMode:MKUserTrackingModeFollow];
    [self.map setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(23.0, 0.0), MKCoordinateSpanMake(100,0)) animated:NO];
 
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(BOOL)shouldAutorotate
{
    return YES;
}*/


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
       // [self dismissViewControllerAnimated:YES completion:nil];
        self.view.hidden = YES;
        [self.map setShowsUserLocation:NO];
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 {
     if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
         [self.map removeAnnotations:[self.map annotations]];
     }
 }


#pragma mark - MapKit View Delegate
/* - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
 {
 #warning block the select location button here!
 if (newState == MKAnnotationViewDragStateEnding)
 {
 //annotationView.canShowCallout = NO;
 CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
 NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
 
 [[[CLGeocoder alloc] init] reverseGeocodeLocation: [[CLLocation alloc] initWithLatitude:annotationView.annotation.coordinate.latitude longitude:annotationView.annotation.coordinate.longitude] completionHandler:
 ^(NSArray *placemarks, NSError *error) {
 
 if (error != nil) {
 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
 message:[error localizedDescription]
 delegate:nil
 cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
 return;
 }
 _chosenLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]]];
 NSLog(@"%@",[[[[placemarks objectAtIndex:0] addressDictionary] valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]);
 
 #warning unblock the select location button here!
 }];
 
 
 }
 }*/


- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass: [MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [mv dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotationView"];
    UIImage *canuPin = [UIImage imageNamed:@"map_pin.png"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotationView"];
        annotationView.image = canuPin;
         annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;
        
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    // NSLog(@"deselected pin");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   // NSLog(@"selected pin");
    //view.canShowCallout = YES;
    
    // [MKMapItem openMapsWithItems:[NSArray arrayWithObject:[[MKPlacemark alloc] initWithPlacemark:self.activity.location.placemark]] launchOptions:nil];
    
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DetailActivityViewController *davc = [[DetailActivityViewController alloc] init];
    davc.activity = view.annotation;
    [self presentViewController:davc animated:YES completion:nil];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKAnnotationView* annotationView = [mapView viewForAnnotation:userLocation];
    annotationView.canShowCallout = NO;
    // annotationView.enabled = NO;
}






@end
