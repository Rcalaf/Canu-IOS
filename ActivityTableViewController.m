//
//  ActivityTableViewController.m
//  CANU
//
//  Created by Roger Calaf on 26/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Activity.h"

#import "AFCanuAPIClient.h"
#import "UIImageView+AFNetworking.h"

#import "UICanuActivityCell.h"

#import "AppDelegate.h"
#import "ActivityTableViewController.h"
#import "NewActivityViewController.h"
#import "DetailActivityViewController.h"

#import "ActivitiesFeedViewController.h"
#import "UserProfileViewController.h"
#import "MainViewController.h"

#define backgroundcolor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];

@interface ActivityTableViewController () <CLLocationManagerDelegate>

@property (readonly, nonatomic) CLLocationCoordinate2D currentLocation;
@property (readonly, strong, nonatomic) CLLocationManager *locationManager;
@property (readonly, nonatomic) NSArray *quotes;
@property (strong, nonatomic) UITextView *feedbackMessage;
//  @property (nonatomic) BOOL cellUserInteractionEnabled;

- (void)reload:(id)sender;
- (void)showFeedback:(id)sender;

@end

@implementation ActivityTableViewController

@synthesize activities = _activities;
@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize quotes = _quotes;
@synthesize feedbackMessage = _feedbackMessage;
//@synthesize cellUserInteractionEnabled = _cellUserInteractionEnabled;

- (NSArray *)quotes
{
    if (!_quotes) {
        if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) {
            _quotes = [NSArray arrayWithObjects:@"Where are you living? Move to a better place where people do stuff.",
                       @"Are you that guy who lives in the forest? Unfortunately the animal version of CANU is not ready.",
                       @"Get the people in your area going, obviously they can't do anything themselves.",
                       @"Seriously, you are in a boring city. You are the only one who can change this!",
                       @"Are you on the moon? There is definitely not much going on around you.",
                       @"Looks like you are the only one alive. Time to change this!",
                       @"You are the first to reach America. Conquer this land with your friends.",
                       @"Don’t wait for for someone to kick your butt. Kick others - create!",
                       @"\"We have nothing to do\". - The bored people around you",
                       @"Why do you even live in this town if nothing is happening here?", nil];
        } else {
            
            _quotes = [NSArray arrayWithObjects:@"Why are you sitting on the bench all alone? Invite people to join you.",
                       @"It’s a lovely day to get together for some boxing.",
                       @"Your city is doing fun things. Just offer everyone something really boring this time.",
                       @"Time to predict the future. How about cutting grass in the park?",
                       @"Your city is doing boring stuff? Just offer them something they never thought of.",
                       @"If you came here to check out some photos from last night. This is not the place. How about a new night out?",
                       @"I don’t like us spending this much time together, please create an activity and do something. - Your phone.",
                       @"Whats on your bucket list? Go do some of these things today with others!",
                       @"Stop thinking about what your friends did yesterday, just get together again today.",
                       @"Come on... Just go fishing.",
                       @"Whats the craziest thing you've ever done? Do it again.",
                       @"Maybe grab a beer at the zoo? How about a snowball fight?", nil];
        }
        
    }
    
    return _quotes;
}

- (CLLocationManager *)locationManager
{
    if (_locationManager != nil) {
        _locationManager.delegate = self;
        return _locationManager;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=200;
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = [[manager location] coordinate];
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = _currentLocation;
    [appDelegate.user editLatitude:_currentLocation.latitude Longitude:_currentLocation.longitude];
    
    [self.locationManager stopUpdatingLocation];
    [self reload:nil];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"loc manager Monitoring...");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"loc manager Fail...");
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f + KIphone5Margin) style:UITableViewStyleGrouped];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:0.0];
    [self.tableView setTransform:CGAffineTransformMakeRotation(M_PI)];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 311.5);
    
    self.feedbackMessage = [[UITextView alloc] initWithFrame:CGRectMake(60.0f, 70.0f, 200.0f, 340.0f)];
    self.feedbackMessage.font =[UIFont fontWithName:@"Lato-Bold" size:25.0];
    self.feedbackMessage.textColor = [UIColor colorWithRed:28.0f/255.0f green:165.0f/255.0f blue:124.0f/255.0f alpha:1.0f];
    self.feedbackMessage.allowsEditingTextAttributes = NO;
    self.feedbackMessage.textAlignment = NSTextAlignmentCenter;
    self.feedbackMessage.backgroundColor = self.view.backgroundColor;
    self.feedbackMessage.hidden = YES;
   // [self.feedbackMessage setTransform:CGAffineTransformMakeRotation(M_PI)];
    
    [self.parentViewController.view addSubview:self.feedbackMessage];
    //self.cellUserInteractionEnabled = YES;
    
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    //[refresh setTransform:CGAffineTransformMakeRotation(M_PI)];
    [refresh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.locationManager startUpdatingLocation];

    /*if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self showFeedback:nil];
    }*/
    
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //self.activities = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFeedback:(id)sender
{
    
    NSInteger r = arc4random()%[self.quotes count];
   // NSLog(@"index: %d random text:%@",r,[_quotes objectAtIndex:r] );
   // NSLog(@"feed num act: %d",[_activities count]);
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        self.feedbackMessage.hidden = NO;
        self.activities = @[];
        [self.tableView reloadData];
        self.feedbackMessage.text = @"Please go to settings > Privacy > Location Services and enable GPS.";
    } else if ([_activities count] == 0){
        self.feedbackMessage.hidden = NO;
        self.feedbackMessage.text = [_quotes objectAtIndex:r];
    } else {
        self.feedbackMessage.hidden = YES;
    }
    
    
}


- (void)reload:(id)sender
{
    //NSLog(@"%@",[self.parentViewController class]);
    
    //self.tableView.userInteractionEnabled = NO;
   // self.cellUserInteractionEnabled = NO;
    if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) {
       // AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [Activity publicFeedWithCoorindate:_currentLocation WithBlock:^(NSArray *activities, NSError *error) {
            
            if (error) {
          
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _activities = activities;
                
                [self.tableView reloadData];
                [self showFeedback:nil];
               // self.cellUserInteractionEnabled = YES;
                //self.tableView.userInteractionEnabled = YES;
            }
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
            
        }];
    }else{
        [[(UserProfileViewController *)self.parentViewController user] userActivitiesWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                if ([[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate.user logOut];
                } else {
                 
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                }
            } else {
                //NSLog(@"%@",activities);
                _activities = activities;
                
                
                [self.tableView reloadData];
                [self showFeedback:nil];
                // self.tableView.userInteractionEnabled = YES;
               //self.cellUserInteractionEnabled = YES;
            }
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }];
    }
}

-(void)triggerCellAction:(id)recognizer
{
    UICanuActivityCell *cell = (UICanuActivityCell *)[[[recognizer view] superview] superview];
    NewActivityViewController *eac;
    
    if (cell.activity.status == UICanuActivityCellGo) {
        cell.loadingIndicator.hidden = NO;
        [cell.loadingIndicator startAnimating];
        cell.actionButton.hidden = YES;
        [cell.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _activities = activities;
                if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) [self.tableView reloadData];
            }
            if ([self.parentViewController isKindOfClass:[UserProfileViewController class]]) [self reload:nil];
            //
            //cell.loadingIndicator.hidden = YES;
            //cell.actionButton.hidden = NO;
            
        }];
    }
    if (cell.activity.status == UICanuActivityCellEditable) {
        eac = [[NewActivityViewController alloc] init];
        eac.activity = cell.activity;
        //NSLog(@"loc: %@",eac.activity.location);
        [self presentViewController:eac animated:YES completion:nil];
    }
    
    if (cell.activity.status == UICanuActivityCellToGo) {
        cell.loadingIndicator.hidden = NO;
        [cell.loadingIndicator startAnimating];
        cell.actionButton.hidden = YES;
        [cell.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _activities = activities;
                if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) [self.tableView reloadData];
            }
            if ([self.parentViewController isKindOfClass:[UserProfileViewController class]]) [self reload:nil];
            
            //[self reload:nil];
             //cell.loadingIndicator.hidden = YES;
            //cell.actionButton.hidden = NO;
            
        }];
    }
    
    //NSLog(@"%lu", (unsigned long)cell.activity.activityId);
    //[self reload:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_activities count];
}

- (UICanuActivityCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //static NSString *CellIdentifier = @"";
    
    Activity *activity= [_activities objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Canu Cell %u",activity.status];
    
    UICanuActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UICanuActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier activity:activity];
    } else{
        cell.activity = activity;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,cell.activity.user.profileImageUrl]];
        [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        // [cell.userPic setImageWithURL:cell.activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        
        cell.textLabel.text = activity.title;
        cell.location.text = activity.locationDescription;
        //cell.userName.text = [NSString stringWithFormat:@"%@ %@",activity.user.firstName, activity.user.lastName];
         cell.userName.text = activity.user.userName;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"d MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        cell.day.text = [dateFormatter stringFromDate:activity.start];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        cell.timeStart.text = [timeFormatter stringFromDate:activity.start];
        cell.timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:activity.end]];
        
        [cell.loadingIndicator stopAnimating];
        cell.loadingIndicator.hidden = YES;
        cell.actionButton.hidden = NO;
    }
    
    UITapGestureRecognizer *cellAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerCellAction:)];
    [cell.actionButton addGestureRecognizer:cellAction];
    
    
    //cell.actionButton.userInteractionEnabled = self.cellUserInteractionEnabled;
    
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    DetailActivityViewController *davc = [[DetailActivityViewController alloc] init];
    davc.activity = [_activities objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:davc animated:YES];
  //  [self presentViewController:davc animated:YES completion:nil];

    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.5f;
}

@end
