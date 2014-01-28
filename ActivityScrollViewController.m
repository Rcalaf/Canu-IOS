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
#import "ActivitiesFeedViewController.h"
#import "LoaderAnimation.h"
#import "UICanuNavigationController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "ErrorManager.h"
#import "UIProfileView.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#import "AppDelegate.h"

#import "Activity.h"

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@interface ActivityScrollViewController () <CLLocationManagerDelegate,UIScrollViewDelegate,DetailActivityViewControllerAnimateDelegate>

@property (nonatomic) BOOL isReload;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) NSMutableArray *arrayCell;
@property (nonatomic) UIImageView *imageEmptyFeed;
@property (nonatomic) UITextView *feedbackMessage;
@property (strong, nonatomic) UIButton *callBackActionEmptyFeed;
@property (nonatomic, readonly) CLLocationCoordinate2D currentLocation;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic) User *user;
@property (nonatomic) FeedTypes feedType;
@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) LoaderAnimation *loaderAnimation;
@property (nonatomic) UICanuNavigationController *navigation;

@end

@implementation ActivityScrollViewController

@synthesize locationManager = _locationManager;

- (id)initFor:(FeedTypes)feedType andUser:(User *)user andFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        
        self.feedType = feedType;
        
        self.view.frame = frame;
        
        if (_feedType == FeedLocalType) {
            NSLog(@"init ActivityScrollViewController Local");
        } else if (_feedType == FeedTribeType) {
            NSLog(@"init ActivityScrollViewController Tribes");
        } else if (_feedType == FeedProfileType) {
            NSLog(@"init ActivityScrollViewController Profile");
        }
        
        self.user = user;
        
        self.isReload = NO;
        
        self.isFirstTime = YES;
        
        self.isEmpty = YES;
        
        [self.locationManager startUpdatingLocation];
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        self.imageEmptyFeed = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 480)/2, 320, 480)];
        self.imageEmptyFeed.alpha = 0;
        [self.view addSubview:_imageEmptyFeed];
        
        self.feedbackMessage                             = [[UITextView alloc] initWithFrame:CGRectMake(40.0f, (self.view.frame.size.height - 480)/2 + 270.0f, 240.0f, 100.0f)];
        self.feedbackMessage.font                        = [UIFont fontWithName:@"Lato-Bold" size:19.0];
        self.feedbackMessage.textColor                   = [UIColor whiteColor];
        self.feedbackMessage.allowsEditingTextAttributes = NO;
        self.feedbackMessage.textAlignment               = NSTextAlignmentCenter;
        self.feedbackMessage.backgroundColor             = [UIColor clearColor];
        self.feedbackMessage.alpha                       = 0;
        [self.view addSubview:self.feedbackMessage];
        
        // To delete after implementation Tribes
        if (_feedType == FeedTribeType) {
            [self showFeedback];
        }
        ///////////
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake(145, self.view.frame.size.height - 30 - 19, 30, 30) withStart:-30 andEnd:-100];
        [self.loaderAnimation startAnimation];
        [self.view addSubview:_loaderAnimation];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scrollview.delegate = self;
        [self.view addSubview:_scrollview];
        
        self.callBackActionEmptyFeed = [[UIButton alloc]initWithFrame:CGRectMake(65, (self.view.frame.size.height - 480)/2 + 350, 190, 37)];
        self.callBackActionEmptyFeed.backgroundColor = UIColorFromRGB(0x20383f);
        [self.callBackActionEmptyFeed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.callBackActionEmptyFeed setTitle:NSLocalizedString(@"I want to change this", nil) forState:UIControlStateNormal];
        self.callBackActionEmptyFeed.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
        [self.callBackActionEmptyFeed addTarget:self action:@selector(callBackAction) forControlEvents:UIControlEventTouchDown];
        self.callBackActionEmptyFeed.alpha = 0;
        self.callBackActionEmptyFeed.hidden = YES;
        [self.view addSubview:_callBackActionEmptyFeed];
    
    }
    return self;
}

- (UICanuNavigationController *)navigation{
    
    if (!_navigation) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _navigation = appDelegate.canuViewController;
    }
    
    return  _navigation;
    
}

- (CLLocationManager *)locationManager{
    if (_locationManager) {
        return _locationManager;
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 200;
    
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
    NSLog(@"loc manager Monitoring...");
    [self.loaderAnimation stopAnimation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"loc manager Fail...");
    [self showFeedback];
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
            
            float value = 0,start = 0,end = 50;
            
            newY = fabsf(newY);
            
            if (newY > start && newY <= end) {
                value = (newY - start) / (end - start);
            }else if (newY > end){
                value = 1;
            }else if (newY <= start){
                value = 0;
            }
            
            [self.navigation changePosition:value];
            
            if (self.isEmpty) {
                self.imageEmptyFeed.frame = CGRectMake(0, - newY + (self.view.frame.size.height - 480)/2, 320, 480);
                self.feedbackMessage.frame = CGRectMake(40.0f, - newY * 0.6f + (self.view.frame.size.height - 480)/2 + 270.0f, 240.0f, 100.0f);
            }
            
        } else {
            
            [self.navigation changePosition:0];
            
            if (self.isEmpty) {
                self.imageEmptyFeed.frame = CGRectMake(0, (self.view.frame.size.height - 480)/2, 320, 480);
                self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 270.0f, 240.0f, 100.0f);
            }
            
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
    
    BOOL isEmptyBefore = self.isEmpty;
    
    if (_feedType == FeedLocalType) {
        
        [Activity publicFeedWithCoorindate:_currentLocation WithBlock:^(NSArray *activities, NSError *error) {
            
            if (error) {
                
                // Visual information of this error adding by Error Manager
                [[ErrorManager sharedErrorManager] visualAlertFor:error.code];
                
            } else {
                
                _activities = activities;
                
                [self showActivities];
                
                [self showFeedback];
                
            }
            
            if (isEmptyBefore != self.isEmpty) {
                [self.delegate activityScrollViewControllerChangementFeed];
            }
            
            if (_isReload) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.scrollview.frame = CGRectMake( 0, 0, _scrollview.frame.size.width, _scrollview.frame.size.height);
                    [self.navigation changePosition:0];
                    if (self.isEmpty) {
                        self.imageEmptyFeed.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2, 320, 480);
                        self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 270.0f, 240.0f, 100.0f);
                    }
                } completion:^(BOOL finished) {
                    [self.loaderAnimation stopAnimation];
                    
                    self.isReload = NO;
                    
                }];
            }
            
            [self.loaderAnimation stopAnimation];
            
        }];
        
    }else if(_feedType == FeedTribeType){
            
            [self.loaderAnimation stopAnimation];
        
    }else if(_feedType == FeedProfileType){
        
        [self.user userActivitiesWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                
                // Visual information of this error adding by Error Manager
                [[ErrorManager sharedErrorManager] visualAlertFor:error.code];

            } else {
                
                _activities = activities;
                
                [self showActivities];
                
                [self showFeedback];
                
            }
            
            if (isEmptyBefore != self.isEmpty) {
                [self.delegate activityScrollViewControllerChangementFeed];
            }
            
            if (_isReload) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.scrollview.frame = CGRectMake( 0, 0, _scrollview.frame.size.width, _scrollview.frame.size.height);
                    [self.navigation changePosition:0];
                    if (self.isEmpty) {
                        self.imageEmptyFeed.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2, 320, 480);
                        self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 270.0f, 240.0f, 100.0f);
                    }
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
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        self.isEmpty = YES;
        self.feedbackMessage.text = @"Please go to settings > Privacy > Location Services and enable GPS.";
        self.imageEmptyFeed.alpha = 0;
        self.callBackActionEmptyFeed.alpha = 0;
        self.callBackActionEmptyFeed.hidden = YES;
        [UIView  animateWithDuration:0.4 animations:^{
            self.feedbackMessage.alpha = 1;
        } completion:nil];
        [self showActivities];
    } else if ([_activities count] == 0){
        self.isEmpty = YES;
        if (_feedType == FeedLocalType) {
            self.imageEmptyFeed.image = [UIImage imageNamed:@"Activity_Empty_feed_illustration_local"];
            self.feedbackMessage.text = NSLocalizedString(@"There isn't much happening around you", nil);
        } else if (_feedType == FeedTribeType){
            self.imageEmptyFeed.image = [UIImage imageNamed:@"Activity_Empty_feed_illustration_tribes"];
            self.feedbackMessage.text = NSLocalizedString(@"Your friends seem asleep", nil);
        } else if (_feedType == FeedProfileType){
            self.imageEmptyFeed.image = [UIImage imageNamed:@"Activity_Empty_feed_illustration_profile"];
            self.feedbackMessage.text = NSLocalizedString(@"Looks like you have plenty of spare time", nil);
        }
        self.callBackActionEmptyFeed.hidden = NO;
        [UIView  animateWithDuration:0.4 animations:^{
            self.feedbackMessage.alpha = 1;
            self.imageEmptyFeed.alpha = 1;
            self.callBackActionEmptyFeed.alpha = 1;
        } completion:nil];
        [self showActivities];
    } else {
        self.isEmpty = NO;
        [UIView  animateWithDuration:0.4 animations:^{
            self.feedbackMessage.alpha = 0;
            self.imageEmptyFeed.alpha = 0;
            self.callBackActionEmptyFeed.alpha = 0;
        } completion:^(BOOL finished) {
            self.callBackActionEmptyFeed.hidden = YES;
        }];
    }
    
    if (self.isEmpty && _feedType == FeedLocalType) {
        [self.delegate activityScrollViewControllerStartWithEmptyFeed];
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
            [UIView animateWithDuration:0.4 delay:0.1 + i * 0.15 options:UIViewAnimationOptionAllowUserInteraction animations:^{
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
                    
                    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Action" label:@"Unsubscribe" value:nil] build]];
                    
                    _activities = activities;
                    cell.animationButtonGo.hidden = NO;
                    cell.animationButtonGo.transform = CGAffineTransformMakeScale(0,0);
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        cell.animationButtonGo.transform = CGAffineTransformMakeScale(1,1);
                    } completion:^(BOOL finished) {
                        cell.animationButtonGo.transform = CGAffineTransformMakeScale(0,0);
                        if (_feedType == FeedLocalType) {
                            [self showActivities];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                        }else if (_feedType == FeedTribeType) {
//                            [self load];
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                        }else if (_feedType == FeedProfileType) {
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
                    
                    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Action" label:@"Subscribe" value:nil] build]];
                    
                    _activities = activities;
                    cell.animationButtonToGo.hidden = NO;
                    cell.animationButtonToGo.transform = CGAffineTransformMakeScale(0,0);
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        cell.animationButtonToGo.transform = CGAffineTransformMakeScale(1,1);
                    } completion:^(BOOL finished) {
                        cell.animationButtonToGo.transform = CGAffineTransformMakeScale(0,0);
                        if (_feedType == FeedLocalType) {
                            [self showActivities];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                        }else if (_feedType == FeedTribeType) {
                            //                            [self load];
                            //                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                        }else if (_feedType == FeedProfileType) {
                            [self load];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                        }
                    }];
                }
            }];
        }];

    }
}

- (void)cellEventProfileView:(User *)user{
    
    UIProfileView *profileView = [[UIProfileView alloc] initWithUser:user WithBottomBar:YES AndNavigationchangement:YES];
    [self.view addSubview:profileView];
    
    [profileView hideComponents:profileView.profileHidden];
    
    if (profileView.profileHidden) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:appDelegate.oldScreenName];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Profile User View"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    }
    
}

- (void)touchCell:(UITapGestureRecognizer *)sender{
    NSLog(@"touchCell");
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
            davc.modalPresentationStyle = UIModalPresentationCurrentContext;
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

- (void)callBackAction{
    
    NewActivityViewController *nac = [[NewActivityViewController alloc] init];
    [self presentViewController:nac animated:YES completion:nil];
    
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
    
    if (_feedType == FeedLocalType) {
        NSLog(@"dealloc ActivityScrollViewController Local");
    }else if (_feedType == FeedTribeType){
        NSLog(@"dealloc ActivityScrollViewController Tribes");
    }else if (_feedType == FeedProfileType){
        NSLog(@"dealloc ActivityScrollViewController Profile");
    }
    
}

@end
