//
//  ActivityScrollViewController.m
//  CANU
//
//  Created by Vivien Cormier on 10/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "ActivityScrollViewController.h"

#import "ActivitiesFeedViewController.h"
#import "UserProfileViewController.h"

#import "UIScrollViewReverse.h"
#import "UICanuActivityCellScroll.h"
#import "NewActivityViewController.h"
#import "DetailActivityViewController.h"

#import "AppDelegate.h"

#import "Activity.h"

#define backgroundcolor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@interface ActivityScrollViewController () <CLLocationManagerDelegate,UIScrollViewDelegate>

@property (nonatomic) UITextView *feedbackMessage;
@property (nonatomic, readonly) NSArray *quotes;
@property (nonatomic, readonly) CLLocationCoordinate2D currentLocation;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSMutableArray *arrayCell;

@end

@implementation ActivityScrollViewController

@synthesize activities = _activities;
@synthesize quotes = _quotes;
@synthesize currentLocation = _currentLocation;
@synthesize locationManager = _locationManager;

- (NSArray *)quotes{
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

- (CLLocationManager *)locationManager{
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _currentLocation = [[manager location] coordinate];
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = _currentLocation;
    [appDelegate.user editLatitude:_currentLocation.latitude Longitude:_currentLocation.longitude];
    
    [self.locationManager stopUpdatingLocation];
    [self reload];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"loc manager Monitoring...");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"loc manager Fail...");
}


- (id)init{
    self = [super init];
    if (self) {
        
        self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        self.feedbackMessage                             = [[UITextView alloc] initWithFrame:CGRectMake(60.0f, 70.0f, 200.0f, 340.0f)];
        self.feedbackMessage.font                        = [UIFont fontWithName:@"Lato-Bold" size:25.0];
        self.feedbackMessage.textColor                   = [UIColor colorWithRed:28.0f/255.0f green:165.0f/255.0f blue:124.0f/255.0f alpha:1.0f];
        self.feedbackMessage.allowsEditingTextAttributes = NO;
        self.feedbackMessage.textAlignment               = NSTextAlignmentCenter;
        self.feedbackMessage.backgroundColor             = self.view.backgroundColor;
        self.feedbackMessage.hidden                      = YES;
        [self.view addSubview:self.feedbackMessage];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scrollview.delegate = self;
        [self.view addSubview:_scrollview];
        
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.locationManager startUpdatingLocation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newX,newY;
    
    newX = scrollView.contentOffset.x;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    // Reload Animation
    // to 0 at -100
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newX,newY;
    
    newX = scrollView.contentOffset.x;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= -100.0f ){
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
    }
    
}

- (void)reload{
    
    if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) {
        
        [Activity publicFeedWithCoorindate:_currentLocation WithBlock:^(NSArray *activities, NSError *error) {
            
            if (error) {
                
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                
            } else {
                
                _activities = activities;
                
                [self showActivities];
                
                [self showFeedback];
                
            }
            
//            Si le loader tourne on le stop
//            if (self.refreshControl.refreshing) {
//                [self.refreshControl endRefreshing];
//            }
            
        }];
        
    }else{
        
        [[(UserProfileViewController *)self.parentViewController user] userActivitiesWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                if ([[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    [appDelegate.user logOut];
                } else {
                    
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                }
            } else {
                
                _activities = activities;
                
                [self showActivities];
                
                [self showFeedback];
                
            }
            
            //            Si le loader tourne on le stop
            //            if (self.refreshControl.refreshing) {
            //                [self.refreshControl endRefreshing];
            //            }
            
        }];
    }
}

- (void)showFeedback{
    
    NSInteger r = arc4random()%[self.quotes count];
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        self.feedbackMessage.hidden = NO;
        self.activities = @[];
        
        [self showActivities];
        
        self.feedbackMessage.text = @"Please go to settings > Privacy > Location Services and enable GPS.";
    } else if ([_activities count] == 0){
        self.feedbackMessage.hidden = NO;
        self.feedbackMessage.text = [_quotes objectAtIndex:r];
    } else {
        self.feedbackMessage.hidden = YES;
    }
    
    
}

- (void)showActivities{
    
    if ([_arrayCell count] != 0 ) {
        
        for (int i = 0; i < [_arrayCell count]; i++) {
            
            UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayCell removeAllObjects];
    
    }
    
    float heightContentScrollView = [_activities count] * (120 + 10) + 10;
    
    if (heightContentScrollView <= _scrollview.frame.size.height) {
        heightContentScrollView = _scrollview.frame.size.height + 1;
    }
    
    self.scrollview.contentSize = CGSizeMake(320, heightContentScrollView);
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
    for (int i = 0; i < [_activities count]; i++) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCell:)];
        
        Activity *activity= [_activities objectAtIndex:i];
        
        UICanuActivityCellScroll *cell = [[UICanuActivityCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( i * (120 + 10) + 10 ) - 120, 300, 120) andActivity:activity];
        cell.activity = activity;
        cell.delegate = self;
        cell.tag = i;
        [cell addGestureRecognizer:tap];
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
    }
    
}

- (void)cellEventActionButton:(UICanuActivityCellScroll *)cell{
    
    if (cell.activity.status == UICanuActivityCellGo) {
        NSLog(@"Disable To Go / Enable Go");
        [cell.loadingIndicator startAnimating];
        cell.animationButtonToGo.transform = CGAffineTransformMakeScale(1,1);
        cell.animationButtonToGo.hidden = NO;
        cell.actionButton.hidden = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            cell.animationButtonToGo.transform = CGAffineTransformMakeScale(0,0);
        } completion:^(BOOL finished) {
            
            cell.animationButtonToGo.transform = CGAffineTransformMakeScale(1,1);
            cell.animationButtonToGo.hidden = YES;
            
            [cell.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                } else {
                    _activities = activities;
                    cell.animationButtonGo.hidden = NO;
                    cell.animationButtonGo.transform = CGAffineTransformMakeScale(0,0);
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        cell.animationButtonGo.transform = CGAffineTransformMakeScale(1,1);
                    } completion:^(BOOL finished) {
                        cell.animationButtonGo.transform = CGAffineTransformMakeScale(0,0);
                        if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) [self showActivities];
                        if ([self.parentViewController isKindOfClass:[UserProfileViewController class]]) [self reload];
                    }];
                }
            }];
        }];
        
    }else if (cell.activity.status == UICanuActivityCellEditable) {
        NewActivityViewController *eac = [[NewActivityViewController alloc] init];
        eac.activity = cell.activity;
        [self presentViewController:eac animated:YES completion:nil];
    }else if (cell.activity.status == UICanuActivityCellToGo) {
        NSLog(@"Disable Go / Enable To Go");
        [cell.loadingIndicator startAnimating];
        cell.animationButtonGo.transform = CGAffineTransformMakeScale(1,1);
        cell.animationButtonGo.hidden = NO;
        cell.actionButton.hidden = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            cell.animationButtonGo.transform = CGAffineTransformMakeScale(0,0);
        } completion:^(BOOL finished) {
            
            cell.animationButtonGo.transform = CGAffineTransformMakeScale(1,1);
            cell.animationButtonGo.hidden = YES;
            
            [cell.activity attendWithBlock:^(NSArray *activities, NSError *error) {
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                } else {
                    _activities = activities;
                    cell.animationButtonToGo.hidden = NO;
                    cell.animationButtonToGo.transform = CGAffineTransformMakeScale(0,0);
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        cell.animationButtonToGo.transform = CGAffineTransformMakeScale(1,1);
                    } completion:^(BOOL finished) {
                        if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) [self showActivities];
                        if ([self.parentViewController isKindOfClass:[UserProfileViewController class]]) [self reload];
                    }];
                }
            }];
        }];

    }
}

- (void)touchCell:(UITapGestureRecognizer *)sender{
    
    UICanuActivityCellScroll *cell = (UICanuActivityCellScroll *)sender.view;
    
    DetailActivityViewController *davc = [[DetailActivityViewController alloc] init];
    davc.activity = [_activities objectAtIndex:cell.tag];
    [self.navigationController pushViewController:davc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
