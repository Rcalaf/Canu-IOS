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
#import "UICanuSearchLocation.h"

@interface SearchLocationMapViewController () <MKMapViewDelegate,UITextFieldDelegate,UICanuSearchLocationDelegate>

@property (nonatomic) BOOL searchLocationIsOpen;
@property (strong, nonatomic) UIView *wrapper;
@property (strong, nonatomic) UIImageView *imgClose;
@property (strong, nonatomic) UIView *backgroundForm;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *chosenLocation;
@property (strong, nonatomic) UIButton *closeSearch;
@property (strong, nonatomic) NSTimer *timerSearch;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) UICanuTextFieldLocation *locationInput;
@property (strong, nonatomic) UICanuSearchLocation *searchLocation;

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
        self.location = location;
        self.searchLocationIsOpen = NO;
    }
    
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:_wrapper];
    
    self.backgroundForm = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.backgroundForm.backgroundColor = backgroundColorView;
    self.backgroundForm.alpha = 0;
    [self.view addSubview:_backgroundForm];
    
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
    self.locationInput.placeholder = NSLocalizedString(@"Find a adress", nil);
    self.locationInput.delegate = self;
    self.locationInput.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_locationInput];
    
    self.imgClose = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 47, 47)];
    self.imgClose.image = [UIImage imageNamed:@"F1_input_Location_reset"];
    self.imgClose.alpha = 0;
    
    self.closeSearch = [[UIButton alloc]initWithFrame:CGRectMake(10 + 250 + 1 + 49, 10, 0, 47)];
    [self.closeSearch addTarget:self action:@selector(openSearchLocationView) forControlEvents:UIControlEventTouchDown];
    self.closeSearch.backgroundColor = [UIColor whiteColor];
    self.closeSearch.clipsToBounds = YES;
    [self.closeSearch addSubview:_imgClose];
    [self.view addSubview:_closeSearch];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self.wrapper addSubview:_mapView];
    
    if (_location) {
        
        CLLocationCoordinate2D coord;
        coord.latitude = _location.latitude;
        coord.longitude = _location.longitude;
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coord;
        
        [self.mapView addAnnotation:annotation];
        [self.mapView selectAnnotation:annotation animated:YES];
        [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
        [self.mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
        
    }
    
    UILongPressGestureRecognizer *selectLocationRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(movePin:)];
    selectLocationRecognizer.minimumPressDuration = 1;
    [self.wrapper addGestureRecognizer:selectLocationRecognizer];
    
    self.searchLocation = [[UICanuSearchLocation alloc]initWithFrame:CGRectMake(0, _locationInput.frame.origin.y + _locationInput.frame.size.height + 5, 320, 0) ForMap:YES];
    self.searchLocation.delegate = self;
    [self.view addSubview:_searchLocation];
    
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _locationInput) {
        if (!_searchLocationIsOpen) {
            [self openSearchLocationView];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _locationInput) {
        
        self.locationInput.activeSearch = YES;
        
        if ([self.locationInput.text isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
            
            self.locationInput.text = @"";
            
        }
        
        [self.timerSearch invalidate];
        self.timerSearch = nil;
        
        self.timerSearch = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector:@selector(startSearchLocation) userInfo: nil repeats:NO];
        
    }
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _locationInput) {
        if (_searchLocationIsOpen) {
            [self openSearchLocationView];
            if (self.searchLocation.selectedLocation != nil) {
                self.locationInput.activeSearch = NO;
                self.locationInput.text = self.searchLocation.selectedLocation.name;
            }
            
        }
    }
    
}

#pragma mark -  UICanuSearchLocationDelegate

- (void)locationIsSelected:(Location *)location{
    
    if (_searchLocationIsOpen) {
        [self openSearchLocationView];
        [self.locationInput resignFirstResponder];
        self.locationInput.activeSearch = NO;
        self.locationInput.text = location.name;
    } else {
        self.locationInput.activeSearch = NO;
        self.locationInput.text = location.name;
    }
    
    self.chosenLocation = location.locationMap;
    [self.mapView removeAnnotations:[self.mapView  annotations]];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.chosenLocation.placemark.coordinate;
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    [self.mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
}

#pragma mark - Gesture Recognizer

- (void)movePin:(UILongPressGestureRecognizer *)recognizer{
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
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

- (void)searchAnnotionWithSearch:(NSString *)search{
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = search;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error && error.code != 4) {
            NSLog(@"Error 4 %@",error);
        }
        
        [Location searchLocationMap:response Block:^(NSMutableArray *arrayLocation, NSError *error) {
            if (error) {
                NSLog(@"Error %@",error);
            } else {
                
                if ([arrayLocation count] >= 1) {
                    
                    Location *location = [arrayLocation objectAtIndex:0];
                    
                    self.searchLocation.selectedLocation = location;
                    
                    self.locationInput.activeSearch = NO;
                    self.locationInput.text = location.name;
                    
                    self.chosenLocation = location.locationMap;
                    [self.mapView removeAnnotations:[self.mapView  annotations]];
                    
                    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                    annotation.coordinate = self.chosenLocation.placemark.coordinate;
                    [self.mapView addAnnotation:annotation];
                    [self.mapView selectAnnotation:annotation animated:YES];
                    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
                    [self.mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
                    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
                    
                } else {
                    self.locationInput.text = search;
                    self.locationInput.activeSearch = YES;
                }
                
                [self.searchLocation addResult:arrayLocation];
    
            }
        }];
        
    }];
    
}

- (void)searchAnnotionWithLocation:(Location *)location{
    
    CLLocationCoordinate2D coord;
    coord.latitude = _location.latitude;
    coord.longitude = _location.longitude;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coord;
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    [self.mapView setRegion:MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
    
    self.searchLocation.selectedLocation = location;
    
    NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
    [arrayLocation addObject:location];
    
    [self.searchLocation addResult:arrayLocation];
    
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
         
         Location *location = [[Location alloc]initCurrentLocation:item];
         location.latitude = coor.latitude;
         location.longitude = coor.longitude;
         
         self.searchLocation.selectedLocation = location;
         
         NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
         [arrayLocation addObject:location];
         
         [self.searchLocation addResult:arrayLocation];
         
         self.locationInput.activeSearch = NO;
         self.locationInput.text = location.name;
         
     }];
    
}

- (void)openSearchLocationView{
    
    self.searchLocationIsOpen = !_searchLocationIsOpen;
    
    int heightSearchLocation,margin;
    
    if (_searchLocationIsOpen) {
        heightSearchLocation = 238 + 10;
        margin = 10;
        
        self.backgroundForm.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        
    } else {
        heightSearchLocation = - 238 - 10;
        margin = - 10;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        if (_searchLocationIsOpen) {
            self.backgroundForm.alpha = 1;
            self.locationInput.frame = CGRectMake(10, 10, 250, 47);
            self.closeSearch.frame = CGRectMake(10 + 250 + 1 , 10, 49, 47);
        } else {
            self.locationInput.frame = CGRectMake(10, 10, 300, 47);
            self.closeSearch.frame = CGRectMake(10 + 250 + 1 + 49, 10, 0, 47);
            self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y, _searchLocation.frame.size.width, _searchLocation.frame.size.height + heightSearchLocation - margin);
        }
    } completion:^(BOOL finished) {
        
        if (!_searchLocationIsOpen) {
            [self.locationInput resignFirstResponder];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            if (_searchLocationIsOpen) {
                self.imgClose.alpha = 1;
                self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y, _searchLocation.frame.size.width, _searchLocation.frame.size.height + heightSearchLocation - margin);
            } else {
                self.backgroundForm.alpha = 0;
                self.imgClose.alpha = 0;
            }
        } completion:^(BOOL finished) {
            if (!_searchLocationIsOpen) {
                self.backgroundForm.frame = CGRectMake(0, 0, 0, 0);
            }
        }];
        
    }];
    
}

- (void)setLocation{
    
    if (self.searchLocation.selectedLocation) {
        
        [self.delegate locationIsSelectedByMap:self.searchLocation.selectedLocation];
        
    }
    
}

- (void)startSearchLocation{
    self.searchLocation.searchLocation = _locationInput.text;
}

- (void)goToForm{
    [self.delegate closeTheMap];
}

@end
