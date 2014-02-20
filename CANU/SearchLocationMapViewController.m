//
//  SearchLocationMapViewController.m
//  CANU
//
//  Created by Vivien Cormier on 18/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "SearchLocationMapViewController.h"
#import "UICanuButtonSignBottomBar.h"
#import <MapKit/MapKit.h>
#import "Location.h"
#import "UICanuTextFieldLocation.h"

@interface SearchLocationMapViewController () <MKMapViewDelegate>

@property (nonatomic) BOOL searchLocationIsOpen;
@property (strong, nonatomic) UIView *wrapper;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *chosenLocation;
@property (strong, nonatomic) UICanuTextFieldLocation *locationInput;

@end

@implementation SearchLocationMapViewController

- (void)loadView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    view.backgroundColor = backgroundColorView;
    self.view = view;
    
}

- (id)initWithLocation:(Location *)location{
    
    self = [super init];
    if (self) {
        self.selectedLocation = location;
        self.searchLocationIsOpen = NO;
    }
    
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:_wrapper];
    
    UIView *bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 57, self.view.frame.size.width, 57)];
    bottomBar .backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.view addSubview:bottomBar ];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goToForm) forControlEvents:UIControlEventTouchDown];
    [bottomBar  addSubview:backButton];
    
    UICanuButtonSignBottomBar *buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0) andBlue:YES];
    [buttonAction setTitle:NSLocalizedString(@"SET LOCATION", nil) forState:UIControlStateNormal];
    [buttonAction addTarget:self action:@selector(setLocation) forControlEvents:UIControlEventTouchDown];
    [bottomBar  addSubview:buttonAction];
    
    self.locationInput = [[UICanuTextFieldLocation alloc]initWithFrame:CGRectMake(10, 10, 300, 47)];
    self.locationInput.returnKeyType = UIReturnKeySearch;
    self.locationInput.userInteractionEnabled = NO;
    [self.view addSubview:_locationInput];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self.wrapper addSubview:_mapView];
    
    if (_selectedLocation) {
        
        CLLocationCoordinate2D coord;
        coord.latitude = _selectedLocation.latitude;
        coord.longitude = _selectedLocation.longitude;
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coord;
        
        [self.mapView addAnnotation:annotation];
        [self.mapView selectAnnotation:annotation animated:NO];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:NO];
        [self.mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:NO];
        
    }
    
    UILongPressGestureRecognizer *selectLocationRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(movePin:)];
    selectLocationRecognizer.minimumPressDuration = 1;
    [self.wrapper addGestureRecognizer:selectLocationRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if([annotation isKindOfClass: [MKUserLocation class]])
        return nil;
    MKAnnotationView *annotationView = [mv dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotationView"];
    UIImage *canuPin = [UIImage imageNamed:@"map_pin.png"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotationView"];
        annotationView.image = canuPin;
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

#pragma mark - Gesture Recognizer

- (void)movePin:(UILongPressGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.mapView removeAnnotations:[self.mapView annotations]];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[recognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        
        [self.mapView addAnnotation:annotation];
        [self.mapView selectAnnotation:annotation animated:YES];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
        [self.mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
        
        [self searchMKMapItemNear:coordinate];
        
    }
    
}

#pragma mark - Public

- (void)searchAnnotionWithLocation:(Location *)location{
    
    CLLocationCoordinate2D coord;
    coord.latitude = location.latitude;
    coord.longitude = location.longitude;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coord;
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:NO];
    [self.mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:NO];
    
    self.selectedLocation = location;
    
    NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
    [arrayLocation addObject:location];
    
    self.locationInput.activeSearch = NO;
    self.locationInput.text = location.name;
    
}

#pragma mark - Private

- (void)searchMKMapItemNear:(CLLocationCoordinate2D)coor{
    
    [[[CLGeocoder alloc] init] reverseGeocodeLocation: [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude] completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         if (error != nil) {
             NSLog(@"bug : %@",error);
         }
         
         MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]]];
         
         Location *location = [[Location alloc]initLocationWithMKMapItem:item];
         location.latitude = coor.latitude;
         location.longitude = coor.longitude;
         
         self.selectedLocation = location;
         
         NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
         [arrayLocation addObject:location];
         
         self.locationInput.activeSearch = NO;
         self.locationInput.text = location.name;
         
     }];
    
}

- (void)setLocation{
    
    [self.delegate locationIsSelectedByMap:self.selectedLocation];
    
}

- (void)goToForm{
    [self.delegate closeTheMap];
}

@end
