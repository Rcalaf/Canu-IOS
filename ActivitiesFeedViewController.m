//
//  ActivitiesFeedViewController.m
//  CANU
//
//  Created by Roger Calaf on 17/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//
#import "ActivitiesFeedViewController.h"
#import "ActivityTableViewController.h"
#import "ActivityMapViewController.h"
#import "Activity.h"
#import "AppDelegate.h"

@interface ActivitiesFeedViewController ()

@property (strong, nonatomic) ActivityMapViewController *map;
@property (strong, nonatomic) ActivityTableViewController *list;
//- (void)reload:(id)sender;
@end

@implementation ActivitiesFeedViewController

@synthesize map = _map;
@synthesize list = _list;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    
    _list = [[ActivityTableViewController alloc] init];
    [self addChildViewController:_list];
    [self.view addSubview:_list.view];
    
    _map = [[ActivityMapViewController alloc] init];
    [self addChildViewController:_map];
    [self.view addSubview:_map.view];
    _map.view.hidden = YES;
    
    // AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    // [appDelegate.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
 // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
       // [_map.map addAnnotations:_list.activities];
        [_map reload:self];
        [_map.map setShowsUserLocation:NO];
        [_map.map setUserInteractionEnabled:YES];
        [_map.map setUserTrackingMode:MKUserTrackingModeFollow];
       /* for (Activity *activity in _list.activities) {
                [_map.map addAnnotation:activity.location.placemark];
        }*/
        _map.view.hidden = NO;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return  UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}


@end
