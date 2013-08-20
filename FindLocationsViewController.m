//
//  FindLocationsViewController.m
//  CANU
//
//  Created by Roger Calaf on 19/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "FindLocationsViewController.h"

NSString *const FindLocationDissmised = @"CANU.CANU:FindLocationDissmised";

@interface FindLocationsViewController () <UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate>

@end

@implementation FindLocationsViewController{
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
    MKMapItem *chosenLocation;
}


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
    [[NSNotificationCenter defaultCenter] postNotificationName:FindLocationDissmised object:chosenLocation];

}

#pragma mark - Search Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Cancel any previous searches.
    [localSearch cancel];
    
    // Perform a new search.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.ibMapView.region;
    // NSLog(@"%@",self.ibMapView.region);
    
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
       // MKMapItem *first = [response.mapItems objectAtIndex:0];
       // NSLog(@"%@",first.placemark );
        
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
    chosenLocation = results.mapItems[indexPath.row];
    
    [self.ibMapView removeAnnotations:[self.ibMapView annotations]];
    
    [self.ibMapView addAnnotation:chosenLocation.placemark];
    [self.ibMapView selectAnnotation:chosenLocation.placemark animated:YES];

    [self.ibMapView setCenterCoordinate:chosenLocation.placemark.location.coordinate animated:YES];
    [self.ibMapView setUserTrackingMode:MKUserTrackingModeNone];
    
    
   // [self dismissViewControllerAnimated:YES completion:nil];
   // [[NSNotificationCenter defaultCenter] postNotificationName:FindLocationDissmised object:item];
    
    
    
   
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    NSLog(@"dragging");
}




@end
