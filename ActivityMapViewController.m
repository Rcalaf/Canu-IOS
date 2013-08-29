//
//  ActivityMapViewController.m
//  CANU
//
//  Created by Roger Calaf on 27/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "ActivityMapViewController.h"
#import "Activity.h"

@interface ActivityMapViewController () <MKMapViewDelegate>

@end

@implementation ActivityMapViewController

@synthesize map = _map;
@synthesize activities = _activities;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    _map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 300.0f)];
    [self.view addSubview:_map];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"WillLoad");
    self.map.delegate = self;
    [self.map setShowsUserLocation:YES];
    [self.map setUserInteractionEnabled:YES];
    //[self.map setUserTrackingMode:MKUserTrackingModeFollow];
    
    for (Activity *activity in _activities) {
        
        [self.map addAnnotation:activity.location.placemark];
    }
    

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    NSLog(@"didLoad");
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.map setRegion:MKCoordinateRegionMake(appDelegate.currentLocation, MKCoordinateSpanMake(0.300, 0.300)) animated:YES];
    [self.map setUserTrackingMode:MKUserTrackingModeNone];
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 {
     if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
         [UIView animateWithDuration:duration animations:^{
             self.map.hidden = YES;
         }];
         
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
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotationView"];
        //annotationView.draggable = YES;
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
    NSLog(@"selected pin");
    //view.canShowCallout = YES;
    
    // [MKMapItem openMapsWithItems:[NSArray arrayWithObject:[[MKPlacemark alloc] initWithPlacemark:self.activity.location.placemark]] launchOptions:nil];
    
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
       NSLog(@"Callout !!º");
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKAnnotationView* annotationView = [mapView viewForAnnotation:userLocation];
    annotationView.canShowCallout = NO;
    // annotationView.enabled = NO;
}






@end
