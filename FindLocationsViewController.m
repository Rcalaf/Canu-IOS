//
//  FindLocationsViewController.m
//  CANU
//
//  Created by Roger Calaf on 19/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "FindLocationsViewController.h"
#import "MKCanuAnnotationView.h"

NSString *const FindLocationDissmised = @"CANU.CANU:FindLocationDissmised";

@interface FindLocationsViewController () <UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate>

@end

@implementation FindLocationsViewController{
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
}

@synthesize chosenLocation = _chosenLocation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set the toolbar
        UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
        toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        //set the create button
        UIButton *createButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [createButon setTitle:@"SET LOCATION" forState:UIControlStateNormal];
        [createButon setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
        [createButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        createButon.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
        [createButon setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
        [createButon addTarget:self action:@selector(chooseLocation:) forControlEvents:UIControlEventTouchUpInside];
        
        //set Back button
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
        [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:createButon];
        [toolBar addSubview:backButton];
        [self.view addSubview:toolBar];

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchDisplayController setDelegate:self];
    [self.ibSearchBar setDelegate:self];
    [self.ibMapView setDelegate:self];
    
    // Zoom the map to current location.
    [self.ibMapView setShowsUserLocation:YES];
    [self.ibMapView setUserInteractionEnabled:YES];
    [self.ibMapView setUserTrackingMode:MKUserTrackingModeFollow];
    // Do any additional setup after loading the view from its nib.

    UILongPressGestureRecognizer *selectLocationRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(movePin:)];
    selectLocationRecognizer.minimumPressDuration = 1;
    [self.ibMapView addGestureRecognizer:selectLocationRecognizer];
    
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (_chosenLocation) {
        [self.ibMapView removeAnnotations:[self.ibMapView annotations]];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = _chosenLocation.placemark.coordinate;
        [self.ibMapView addAnnotation:_chosenLocation.placemark];
        //[self.ibMapView addAnnotation:annotation];
        [self.ibMapView selectAnnotation:annotation animated:YES];
        [self.ibMapView setCenterCoordinate:annotation.coordinate animated:YES];
        [self.ibMapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
        [self.ibMapView setUserTrackingMode:MKUserTrackingModeNone];
     
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ToolBar button actions

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseLocation:(id)sender
{
    //MKMapItem *item = [[self.ibMapView selectedAnnotations] objectAtIndex:0];
    
    //NSLog(@"%@",chosenLocation.placemark);
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FindLocationDissmised object:_chosenLocation];

}

#pragma mark - Search Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Cancel any previous searches.
    [localSearch cancel];
    
    // Perform a new search.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.ibMapView.region;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        results = response;
        
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results.mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    MKMapItem *item = results.mapItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchDisplayController setActive:NO animated:YES];
    
    //MKMapItem *item = results.mapItems[indexPath.row];
    _chosenLocation = results.mapItems[indexPath.row];
    
    [self.ibMapView removeAnnotations:[self.ibMapView annotations]];
    
   // MKCanuAnnotation *annotation = [[MKCanuAnnotation alloc] initWithCoordinate:_chosenLocation.placemark.coordinate];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = _chosenLocation.placemark.coordinate;
    
    //[self.ibMapView addAnnotation:_chosenLocation.placemark];
    [self.ibMapView addAnnotation:annotation];
    
   // [self.ibMapView addAnnotation:_chosenLocation.placemark];
    [self.ibMapView selectAnnotation:annotation animated:YES];

    [self.ibMapView setCenterCoordinate:annotation.coordinate animated:YES];
    [self.ibMapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
    [self.ibMapView setUserTrackingMode:MKUserTrackingModeNone];
    
    
   // [self dismissViewControllerAnimated:YES completion:nil];
   // [[NSNotificationCenter defaultCenter] postNotificationName:FindLocationDissmised object:item];
    
    
    
   
    
}

#pragma mark - Gesture Recognizer

- (void)movePin:(UILongPressGestureRecognizer *)recognizer
{
    [self.ibMapView removeAnnotations:[self.ibMapView annotations]];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self.ibMapView addAnnotation:_chosenLocation.placemark];
        [self.ibMapView selectAnnotation:_chosenLocation.placemark animated:YES];
        [self.ibMapView setUserTrackingMode:MKUserTrackingModeNone];
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureecognizerStateBegan.");
       CLLocationCoordinate2D coordinate = [self.ibMapView convertPoint:[recognizer locationInView:self.ibMapView] toCoordinateFromView:self.ibMapView];
        [[[CLGeocoder alloc] init] reverseGeocodeLocation: [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:
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
 //   NSLog(@"Callout !!º");
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKAnnotationView* annotationView = [mapView viewForAnnotation:userLocation];
    annotationView.canShowCallout = NO;
   // annotationView.enabled = NO;
}







@end
