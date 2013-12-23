//
//  ActivityScrollViewController.m
//  CANU
//
//  Created by Vivien Cormier on 10/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "ActivityScrollViewController.h"

#import "UIScrollViewReverse.h"
#import "UICanuActivityCellScroll.h"
#import "NewActivityViewController.h"
#import "DetailActivityViewController.h"
#import "DetailActivityViewControllerAnimate.h"
#import "UICanuNavigationController.h"
#import "LoaderAnimation.h"

#import "AppDelegate.h"

#import "Activity.h"

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@interface ActivityScrollViewController () <CLLocationManagerDelegate,UIScrollViewDelegate,DetailActivityViewControllerAnimateDelegate>

@property (nonatomic) UITextView *feedbackMessage;
@property (nonatomic, readonly) NSArray *quotes;
@property (nonatomic, readonly) CLLocationCoordinate2D currentLocation;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSMutableArray *arrayCell;
@property (nonatomic) BOOL isUserProfile;
@property (nonatomic) LoaderAnimation *loaderAnimation;
@property (nonatomic) User *user;
@property (nonatomic) BOOL isReload;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) UICanuNavigationController *navigation;

@end

@implementation ActivityScrollViewController

@synthesize activities = _activities;
@synthesize quotes = _quotes;
@synthesize currentLocation = _currentLocation;
@synthesize locationManager = _locationManager;

- (id)initForUserProfile:(BOOL)isUserProfile andUser:(User *)user andFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        if (!isUserProfile) {
            NSLog(@"init ActivityScrollViewController Local");
        }else{
            NSLog(@"init ActivityScrollViewController User");
        }
        self.view.frame = frame;
        
        self.isUserProfile = isUserProfile;
        
        self.user = user;
        
        self.isReload = NO;
        
        self.isFirstTime = YES;
        
        [self.locationManager startUpdatingLocation];
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        self.feedbackMessage                             = [[UITextView alloc] initWithFrame:CGRectMake(60.0f, 70.0f, 200.0f, 340.0f)];
        self.feedbackMessage.font                        = [UIFont fontWithName:@"Lato-Bold" size:25.0];
        self.feedbackMessage.textColor                   = [UIColor colorWithRed:28.0f/255.0f green:165.0f/255.0f blue:124.0f/255.0f alpha:1.0f];
        self.feedbackMessage.allowsEditingTextAttributes = NO;
        self.feedbackMessage.textAlignment               = NSTextAlignmentCenter;
        self.feedbackMessage.backgroundColor             = self.view.backgroundColor;
        self.feedbackMessage.hidden                      = YES;
        [self.view addSubview:self.feedbackMessage];
        
        [self showFeedback];
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake(145, self.view.frame.size.height - 30 - 19, 30, 30) withStart:-30 andEnd:-100];
        [self.loaderAnimation startAnimation];
        [self.view addSubview:_loaderAnimation];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scrollview.delegate = self;
        [self.view addSubview:_scrollview];
    
    }
    return self;
}

- (NSArray *)quotes{
    if (!_quotes) {
        if (!_isUserProfile) {
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

- (UICanuNavigationController *)navigation{
    if (_isUserProfile) {
        self.view.frame = CGRectMake(320, 0, 320, self.view.frame.size.height);
    }
    if (!_navigation) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _navigation = appDelegate.canuViewController;
        
    }
    
    return  _navigation;
    
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
    
    [NSThread detachNewThreadSelector:@selector(load)toTarget:self withObject:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
//    if (_isUserProfile) {
//        self.view.frame = CGRectMake(320, 0, 320, self.view.frame.size.height);
//    }
    NSLog(@"loc manager Monitoring...");
    [self.loaderAnimation stopAnimation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    if (_isUserProfile) {
//        self.view.frame = CGRectMake(320, 0, 320, self.view.frame.size.height);
//    }
    NSLog(@"loc manager Fail...");
    [self.loaderAnimation stopAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newY;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    [self.loaderAnimation contentOffset:newY];
    
    if (!_isReload) {
        if (newY < 0) {
            
            newY = fabsf(newY);
            
            float value = 0,start = 0,end = 50;
            
            if (newY > start && newY <= end) {
                value = (newY - start) / (end - start);
            }else if (newY > end){
                value = 1;
            }else if (newY <= start){
                value = 0;
            }
            
            [self.navigation changePosition:value];
            
        }else{
            [self.navigation changePosition:0];
        }
    }
    
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
    
    self.isReload = YES;
    
    [self.loaderAnimation startAnimation];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollview.frame = CGRectMake(0, - 58, _scrollview.frame.size.width, _scrollview.frame.size.height);
    } completion:^(BOOL finished) {
        [self load];
    }];
    
}

- (void)load{
    
    if (!_isUserProfile) {
        
        [Activity publicFeedWithCoorindate:_currentLocation WithBlock:^(NSArray *activities, NSError *error) {
            
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                
            } else {
                
                _activities = activities;
                
                [self showActivities];
                
                [self showFeedback];
                
            }
            
            if (_isReload) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.scrollview.frame = CGRectMake( 0, 0, _scrollview.frame.size.width, _scrollview.frame.size.height);
                    [self.navigation changePosition:0];
                } completion:^(BOOL finished) {
                    [self.loaderAnimation stopAnimation];
                    
                    self.isReload = NO;
                    
                }];
            }
            
            [self.loaderAnimation stopAnimation];
            
        }];
        
    }else{
        
        [self.user userActivitiesWithBlock:^(NSArray *activities, NSError *error) {
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
            
            if (_isReload) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.scrollview.frame = CGRectMake( 0, 0, _scrollview.frame.size.width, _scrollview.frame.size.height);
                    [self.navigation changePosition:0];
                } completion:^(BOOL finished) {
                    
                    [self.loaderAnimation stopAnimation];
                    
                    self.isReload = NO;
                    
                }];
            }
            
            [self.loaderAnimation stopAnimation];
            
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
        
        if (_isFirstTime) {
            cell.alpha = 0;
            [UIView animateWithDuration:0.4 delay:i * 0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                cell.alpha = 1;
            } completion:^(BOOL finished) {
                if (i == [_activities count] - 1) {
                    self.isFirstTime = NO;
                }
            }];
        }
        
    }
    
    
    
}

- (void)cellEventActionButton:(UICanuActivityCellScroll *)cell{
    
    if (cell.activity.status == UICanuActivityCellGo) {
        
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
                        if (!_isUserProfile) {
                            [self showActivities];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                        }else{
                            [self load];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                        }
                    }];
                }
            }];
        }];
        
    }else if (cell.activity.status == UICanuActivityCellEditable) {
        NewActivityViewController *eac = [[NewActivityViewController alloc] init];
        eac.activity = cell.activity;
        [self presentViewController:eac animated:YES completion:nil];
    }else if (cell.activity.status == UICanuActivityCellToGo) {
        
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
                        if (!_isUserProfile) {
                            [self showActivities];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                        }else{
                            [self load];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                        }
                    }];
                }
            }];
        }];

    }
}

- (void)touchCell:(UITapGestureRecognizer *)sender{
    
    UICanuActivityCellScroll *cellTouch = (UICanuActivityCellScroll *)sender.view;
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        if (i < cellTouch.tag) {
            
            float distance = cell.frame.origin.y + cellTouch.frame.origin.y + cellTouch.frame.size.height + 10;
            
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
            }];
            
        }else if (i == cellTouch.tag){
            
            Activity *activity = [_activities objectAtIndex:cellTouch.tag];
            
            float position = cellTouch.frame.origin.y - _scrollview.contentOffset.y;
            
            DetailActivityViewControllerAnimate *davc = [[DetailActivityViewControllerAnimate alloc]initFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) andActivity:activity andPosition:position];
            davc.delegate = self;
            [self addChildViewController:davc];
            [self.view addSubview:davc.view];
            
            cellTouch.alpha = 0;
            
        }else{
            
            float distance = cell.frame.origin.y - cellTouch.frame.origin.y;
            
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
            }];
            
        }
        
    }
    
}

- (void)closeDetailActivity:(DetailActivityViewControllerAnimate *)viewController{
    
    for (int i = 0; i < [_arrayCell count]; i++) {
     
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        [UIView animateWithDuration:0.4 animations:^{
            cell.frame = CGRectMake(10, _scrollview.contentSize.height - ( i * (120 + 10) + 10 ) - 120, 300, 120);
        }];
        
    }
    
    [self performSelector:@selector(killViewController:) withObject:viewController afterDelay:0.4];
    
}

-(void)killViewController:(id)sender{
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        cell.alpha = 1;
        
    }
    
    UIViewController *viewController = (UIViewController *) sender;
    
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    viewController = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeAfterlogOut{
    NSLog(@"ActivityScrollViewController removeAfterlogOut");
    
    [self.feedbackMessage removeFromSuperview];
    [self.scrollview removeFromSuperview];
    [self.loaderAnimation removeFromSuperview];
    
    if ([_arrayCell count] != 0 ) {
        
        for (int i = 0; i < [_arrayCell count]; i++) {
            
            UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayCell removeAllObjects];
        
    }
    
    self.loaderAnimation = nil;
    self.arrayCell = nil;
    self.feedbackMessage = nil;
    
}

- (void)dealloc{
    
    if (!_isUserProfile) {
        NSLog(@"dealloc ActivityScrollViewController Local");
    }else{
        NSLog(@"dealloc ActivityScrollViewController User");
    }
    
}

@end
