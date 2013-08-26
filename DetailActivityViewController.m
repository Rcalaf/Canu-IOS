//
//  DetailActivityViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailActivityViewController.h"
#import "AFCanuAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "NewActivityViewController.h"
#import "AttendeesContainerViewController.h"
#import "AttendeesTableViewController.h"

#define kGridBaseCenter CGPointMake(160.0f,201.0f)


@interface DetailActivityViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIImageView *grid;
@end

@implementation DetailActivityViewController

//@synthesize toolBar = _toolBar;
//@synthesize backButton = _backButton;
@synthesize actionButton = _actionButton;
@synthesize mapView = _mapView;
@synthesize numberOfAssistents = _numberOfAssistents;
@synthesize activity = _activity;
@synthesize grid = _grid;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showAttendees:(id)sender
{
    AttendeesContainerViewController *attendeesList = [[AttendeesContainerViewController alloc] init];
    attendeesList.activity = self.activity;

   // AttendeesTableViewController *attendeesList = [[AttendeesTableViewController alloc] init];
    [self presentViewController:attendeesList animated:YES completion:nil];
}

-(void)triggerCellAction:(id)recognizer
{
    NewActivityViewController *eac;
   // AppDelegate *appDelegate =
   // [[UIApplication sharedApplication] delegate];
    
    if ([self.actionButton.imageView.image isEqual:[UIImage imageNamed:@"fullview_action_edit.png"]]){
        eac = [[NewActivityViewController alloc] init];
        eac.activity = self.activity;
        [self presentViewController:eac animated:YES completion:nil];
    }else if ([self.actionButton.imageView.image isEqual:[UIImage imageNamed:@"fullview_action_go.png"]]){
        [self.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                 _numberOfAssistents.text = [NSString stringWithFormat:@"%u",[self.activity.attendeeIds count]];
                [_actionButton setImage:[UIImage imageNamed:@"fullview_action_yes.png"] forState:UIControlStateNormal];
                
            }
        }];
    }
    else {
       
        [self.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _numberOfAssistents.text = [NSString stringWithFormat:@"%u",[self.activity.attendeeIds count]];
               [_actionButton setImage:[UIImage imageNamed:@"fullview_action_go.png"] forState:UIControlStateNormal];
            }
        }];
    }
   
    
}

- (void)loadView
{
    [super loadView];
    
    UIColor *textColor = [UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f];
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    
    _grid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fullview_bg.png"]];
    CGRect gridFrame = _grid.frame;
    gridFrame.origin.x = 10.0f;
    gridFrame.origin.y = 10.0f;
    _grid.frame = gridFrame;
    [_grid setUserInteractionEnabled:YES];

    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,self.activity.user.profileImageUrl]];
    UIImageView *userPic = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 25.0, 25.0)];
    [userPic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    //[userPic setImageWithURL:self.activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    [_grid addSubview:userPic];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(37.0f, 0.0f, 128.0f, 34.0f)];
    userName.text = [NSString stringWithFormat:@"%@ %@",self.activity.user.firstName,self.activity.user.lastName];
    userName.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
    userName.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    
    //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    userName.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
    [_grid addSubview:userName];
    
    
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
    timeFormatter.dateFormat = @"HH:mm";
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    UILabel *timeStart = [[UILabel alloc] initWithFrame:CGRectMake(220.0f, 0.0f, 44.0f, 35.0f)];
    timeStart.text = [timeFormatter stringFromDate:self.activity.start];
    timeStart.font = [UIFont fontWithName:@"Lato-Bold" size:11.0];
    timeStart.backgroundColor = userName.backgroundColor;
    //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    timeStart.textColor = textColor;
    [_grid addSubview:timeStart];
    
    UILabel *timeEnd = [[UILabel alloc] initWithFrame:CGRectMake(250.0f, 0.0f, 44.0f, 35.0f)];
    timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:self.activity.end]];
    timeEnd.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
    timeEnd.backgroundColor = userName.backgroundColor;
    //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    timeEnd.textColor = [UIColor colorWithRed:(182.0 / 255.0) green:(182.0 / 255.0) blue:(188.0 / 255.0) alpha: 1];
    [_grid addSubview:timeEnd];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"d MMM";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(180.0f, 0.0f, 30.0f, 35.0f)];
    day.text = [dateFormatter stringFromDate:self.activity.start];
    day.font = [UIFont fontWithName:@"Lato-Regular" size:9.0];
    day.backgroundColor = userName.backgroundColor;
    //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    day.textColor = textColor;
    [_grid addSubview:day];

    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10.0f, 45.5f, 280.0f, 140.0f)];
    //_mapView = [[MKMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_mapView setUserInteractionEnabled: YES];
    _mapView.delegate = self;
    // [_mapView setVisibleMapRect:MKMapRectMake(self.activity.location.placemark.location.coordinate.latitude, self.activity.location.placemark.location.coordinate.longitude, 200.0, 30.0) animated:YES];
    
    [_mapView addAnnotation:self.activity.location.placemark];
    //[_mapView selectAnnotation:self.activity.location.placemark animated:YES];
    
    //Hack to add an offset to the view
    //CLLocationCoordinate2D pinCoordinate = self.activity.location.placemark.location.coordinate;
    //pinCoordinate.latitude = pinCoordinate.latitude - .004;
    //[_mapView setCenterCoordinate:pinCoordinate animated:YES];

    // Use this for proper center.
    [_mapView setCenterCoordinate:self.activity.coordinate animated:YES];
    
    [_mapView setUserTrackingMode:MKUserTrackingModeNone];
    
   // NSLog(@"%@",_mapView.userLocation.location);
    
    [_grid addSubview:_mapView];
    
   // [self.view addSubview:_mapView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 190.0f, 275.0f, 35.0f)];
    title.text = self.activity.title;
    //title.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0f];
    title.textColor = textColor;
    title.font = [UIFont fontWithName:@"Lato-Bold" size:22.0];
    [_grid addSubview:title];
    
    
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, 233.0f, 250.0f, 12.0f)];
    location.text = [self.activity locationDescription];
    location.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
    location.textColor = textColor;
   // _location.backgroundColor =  [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0f];
    [_grid addSubview:location];

    UITextView *description = [[UITextView alloc] initWithFrame:CGRectMake(18.0f, 265.0, 252.0f, 102.0f)];
    description.text = self.activity.description;
    description.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
    //description.backgroundColor = userName.backgroundColor;
    //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    description.textColor = textColor;
    description.editable = NO;
    description.scrollEnabled = NO;
    [_grid addSubview:description];
    
    [self.view addSubview:_grid];
    
    
    //Tool bar and its items creation
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton setFrame:CGRectMake(194.0f, 10.0f, 116.0f, 37.0f)];
    
    if (appDelegate.user.userId == self.activity.user.userId) [_actionButton setImage:[UIImage imageNamed:@"fullview_action_edit.png"] forState:UIControlStateNormal];
    else if ([self.activity.attendeeIds indexOfObject:[NSNumber numberWithUnsignedInteger:appDelegate.user.userId]] == NSNotFound) [_actionButton setImage:[UIImage imageNamed:@"fullview_action_go.png"] forState:UIControlStateNormal];
    else [_actionButton setImage:[UIImage imageNamed:@"fullview_action_yes.png"] forState:UIControlStateNormal];
    
    [_actionButton addTarget:self action:@selector(triggerCellAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *attendeesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attendeesButton setFrame:CGRectMake(67.0f, 10.0f, 116.5f, 37.0f)];
    [attendeesButton setImage:[UIImage imageNamed:@"fullview_action_ppl.png"] forState:UIControlStateNormal];
    [attendeesButton addTarget:self action:@selector(showAttendees:) forControlEvents:UIControlEventTouchUpInside];
    
    _numberOfAssistents = [[UILabel alloc] initWithFrame:CGRectMake(68.0f, 0.0f, 44.0f, 37.0f)];
    _numberOfAssistents.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.activity.attendeeIds count]];
    _numberOfAssistents.textColor = textColor;
    _numberOfAssistents.font = [UIFont fontWithName:@"Lato-Bold" size:16.0];
    _numberOfAssistents.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];

    
    //[attendeesPlaceholder addSubview:_numberOfAssistents];
    [attendeesButton.imageView addSubview:_numberOfAssistents];
    
    //[toolBar addSubview:attendeesPlaceholder];
    [toolBar addSubview:attendeesButton];
    [toolBar addSubview:backButton];
    [toolBar addSubview:_actionButton];
    [self.view addSubview:toolBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MapKit View Delegate

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views

{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,400,400);
    
    [mv setRegion:region animated:YES];

}

@end
