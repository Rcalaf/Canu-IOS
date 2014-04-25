//
//  SearchLocationMapViewController.m
//  CANU
//
//  Created by Vivien Cormier on 18/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "SearchLocationMapViewController.h"
#import "UICanuButtonSignBottomBar.h"
#import "UICanuBottomBar.h"
#import "UICanuButton.h"
#import <MapKit/MapKit.h>
#import "Location.h"
#import "UICanuTextFieldLocation.h"

@interface SearchLocationMapViewController () <MKMapViewDelegate>

@property (nonatomic) BOOL searchLocationIsOpen;
@property (strong, nonatomic) UIView *wrapper;
@property (strong, nonatomic) UIImageView *wrapperLocation;
@property (strong, nonatomic) UIImageView *wrapperLocationInfo;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *chosenLocation;
@property (strong, nonatomic) UILabel *adress;

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
    
    UICanuBottomBar *bottomBar = [[UICanuBottomBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    [self.view addSubview:bottomBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goToForm) forControlEvents:UIControlEventTouchDown];
    [bottomBar addSubview:backButton];
    
    UICanuButton *buttonAction = [[UICanuButton alloc]initWithFrame:CGRectMake(45 + 10, 4, (self.view.frame.size.width - (45 + 10)*2), 37.0) forStyle:UICanuButtonStyleNormal];
    [buttonAction setTitle:NSLocalizedString(@"Save location", nil) forState:UIControlStateNormal];
    [buttonAction addTarget:self action:@selector(setLocation) forControlEvents:UIControlEventTouchDown];
    [bottomBar addSubview:buttonAction];
    
    self.wrapperLocation = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 55)];
    self.wrapperLocation.image = [UIImage imageNamed:@"F_location_cell"];
    [self.view addSubview:_wrapperLocation];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 9, 233, 20)];
    name.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    name.textColor = UIColorFromRGB(0x2b4b58);
    name.text = NSLocalizedString(@"Pin location", nil);
    [self.wrapperLocation addSubview:name];
    
    self.adress = [[UILabel alloc]initWithFrame:CGRectMake(10, 31, 233, 11)];
    self.adress.font = [UIFont fontWithName:@"Lato-Italic" size:10];
    self.adress.textColor = UIColorFromRGB(0x2b4b58);
    [self.wrapperLocation addSubview:_adress];
    
    self.wrapperLocationInfo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 + 55 + 5, 300, 35)];
    self.wrapperLocationInfo.image = [UIImage imageNamed:@"F_search_location_pin_background"];
    [self.view addSubview:_wrapperLocationInfo];
    
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 290, 13)];
    info.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    info.textAlignment = NSTextAlignmentCenter;
    info.textColor = UIColorFromRGB(0x2b4b58);
    info.text = NSLocalizedString(@"Long press at a new place to move the pin", nil);
    [self.wrapperLocationInfo addSubview:info];
    
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
        
        self.wrapperLocationInfo.alpha = 0;
        
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
    
    self.adress.text = location.name;
    
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
         
         self.adress.text = location.name;
         
     }];
    
}

- (void)setLocation{
    
    [self.delegate locationIsSelectedByMap:self.selectedLocation];
    
}

- (void)goToForm{
    [self.delegate closeTheMap];
}

@end
