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
#import "CreateEditActivityViewController.h"
#import "DetailActivityViewControllerAnimate.h"
#import "UICanuNavigationController.h"
#import "ActivitiesFeedViewController.h"
#import "LoaderAnimation.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "ErrorManager.h"
#import "UIProfileView.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "CounterTextViewController.h"
#import "GAIFields.h"
#import "UserManager.h"

#import "AppDelegate.h"

#import "Activity.h"

@interface ActivityScrollViewController () <CLLocationManagerDelegate,UIScrollViewDelegate,DetailActivityViewControllerAnimateDelegate,CreateEditActivityViewControllerDelegate>

@property (nonatomic) BOOL isReload;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) BOOL loadFirstTime;
@property (nonatomic) BOOL profileViewHidden;
@property (nonatomic) int marginFirstActivity;
@property (nonatomic) int correctionFeedViewProfile;
@property (nonatomic) CANUError canuError;
@property (nonatomic) FeedTypes feedType;
@property (nonatomic, readonly) CLLocationCoordinate2D currentLocation;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *arrayCell;
@property (strong, nonatomic) UIImageView *imageEmptyFeed;
@property (strong, nonatomic) UIImageView *arrowAnimate;
@property (strong, nonatomic) UILabel *titleFeed;
@property (strong, nonatomic) UITextView *feedbackMessage;
@property (strong, nonatomic) UIButton *callBackActionEmptyFeed;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIScrollViewReverse *scrollview;
@property (strong, nonatomic) LoaderAnimation *loaderAnimation;
@property (strong, nonatomic) UICanuNavigationController *navigation;
@property (strong, nonatomic) UICanuActivityCellScroll *cellSaveForEdit;
@property (strong, nonatomic) DetailActivityViewControllerAnimate *detailActivity;

@end

@implementation ActivityScrollViewController

@synthesize locationManager = _locationManager;

#pragma mark - Lifecycle

- (id)initFor:(FeedTypes)feedType andUser:(User *)user andFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        
        self.feedType = feedType;
        
        self.view.frame = frame;
        
        self.profileViewHidden = NO;
        
        self.user = user;
        
        self.isReload = NO;
        
        self.isFirstTime = YES;
        
        self.isEmpty = YES;
        
        self.loadFirstTime = NO;
        
        if (_feedType == FeedProfileType) {
            _marginFirstActivity = 10 + 165;
            _correctionFeedViewProfile = - 50;
        } else {
            _marginFirstActivity = 20;
            _correctionFeedViewProfile = 0;
        }
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        self.imageEmptyFeed = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 480)/2 + 30 + _correctionFeedViewProfile, 320, 480)];
        self.imageEmptyFeed.alpha = 0;
        [self.view addSubview:_imageEmptyFeed];
        
        self.titleFeed = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.view.frame.size.height - 480)/2 + 300 + _correctionFeedViewProfile, 300, 20)];
        self.titleFeed.text = @"Tribe";
        if (_feedType == FeedLocalType) {
            self.titleFeed.text = NSLocalizedString(@"Local", nil);
        }else if (_feedType == FeedTribeType) {
            self.titleFeed.text = NSLocalizedString(@"Tribes", nil);
        }else if (_feedType == FeedProfileType) {
            self.titleFeed.text = NSLocalizedString(@"Profile", nil);
        }
        self.titleFeed.textAlignment = NSTextAlignmentCenter;
        self.titleFeed.textColor = [UIColor whiteColor];
        self.titleFeed.font = [UIFont fontWithName:@"Lato-Bold" size:18.0];
        self.titleFeed.alpha = 0;
        [self.view addSubview:_titleFeed];
        
        self.feedbackMessage                             = [[UITextView alloc] initWithFrame:CGRectMake(40.0f, (self.view.frame.size.height - 480)/2 + 320 + _correctionFeedViewProfile, 240.0f, 100.0f)];
        self.feedbackMessage.font                        = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.feedbackMessage.textColor                   = [UIColor whiteColor];
        self.feedbackMessage.allowsEditingTextAttributes = NO;
        self.feedbackMessage.textAlignment               = NSTextAlignmentCenter;
        self.feedbackMessage.backgroundColor             = [UIColor clearColor];
        self.feedbackMessage.alpha                       = 0;
        [self.view addSubview:self.feedbackMessage];
        
        self.arrowAnimate = [[UIImageView alloc]init];
        self.arrowAnimate.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"T_arraw_animation-1"],
                                             [UIImage imageNamed:@"T_arraw_animation-2"],
                                             [UIImage imageNamed:@"T_arraw_animation-3"],
                                             [UIImage imageNamed:@"T_arraw_animation-4"],
                                             [UIImage imageNamed:@"T_arraw_animation-5"],
                                             [UIImage imageNamed:@"T_arraw_animation-6"],nil];
        self.arrowAnimate.animationDuration = 1.0f;
        self.arrowAnimate.animationRepeatCount = 0;
        self.arrowAnimate.alpha = 0;
        [self.view addSubview:_arrowAnimate];
        
        if (_feedType == FeedLocalType) {
            self.arrowAnimate.frame = CGRectMake(28, self.view.frame.size.height - 110, 14, 39);
        } else if (_feedType == FeedTribeType) {
            self.arrowAnimate.frame = CGRectMake(154, self.view.frame.size.height - 110, 14, 39);
        } else if (_feedType == FeedProfileType) {
            self.arrowAnimate.frame = CGRectMake(280, self.view.frame.size.height - 110, 14, 39);
        }
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake(145, self.view.frame.size.height - 30 - 19, 30, 30) withStart:-30 andEnd:-80];
        if (_feedType == FeedProfileType) {
            self.loaderAnimation.frame = CGRectMake(145, self.view.frame.size.height - 30 - 19 - 165, 30, 30);
        }
        [self.loaderAnimation startAnimation];
        [self.view addSubview:_loaderAnimation];
        
        if (_feedType == FeedLocalType) {
            
            switch ([CLLocationManager authorizationStatus]) {
                case kCLAuthorizationStatusAuthorized:
                    self.canuError = CANUErrorNoError;
                    break;
                case kCLAuthorizationStatusNotDetermined:
                    self.canuError = CANUErrorLocationNotDetermined;
                    break;
                case kCLAuthorizationStatusRestricted:
                    self.canuError = CANUErrorLocationRestricted;
                    break;
                case kCLAuthorizationStatusDenied:
                    self.canuError = CANUErrorLocationRestricted;
                    break;
                default:
                    break;
            }
            
            if (self.canuError == CANUErrorNoError) {
                [self.locationManager startUpdatingLocation];
            } else {
                [self.loaderAnimation stopAnimation];
                [self showFeedback];
            }
            
        } else {
            
            self.loadFirstTime = YES;
            [NSThread detachNewThreadSelector:@selector(load)toTarget:self withObject:nil];
            
        }
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.scrollview.delegate = self;
        if (_feedType == FeedProfileType) {
            self.scrollview.clipsToBounds = NO;
        }
        [self.view addSubview:_scrollview];
        
        if (_feedType != FeedProfileType) {
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
    
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
//    if (_feedType == FeedLocalType) {
//        NSLog(@"dealloc ActivityScrollViewController Local");
//    }else if (_feedType == FeedTribeType){
//        NSLog(@"dealloc ActivityScrollViewController Tribes");
//    }else if (_feedType == FeedProfileType){
//        NSLog(@"dealloc ActivityScrollViewController Profile");
//    }
    
}

#pragma mark - Custom Accessors

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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.canuError = CANUErrorNoError;
    
    _currentLocation = [[manager location] coordinate];
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentLocation = _currentLocation;
    [[[UserManager sharedUserManager] currentUser] editLatitude:_currentLocation.latitude Longitude:_currentLocation.longitude];
    
    [self.locationManager stopUpdatingLocation];
    
    if (!_loadFirstTime) {
        self.loadFirstTime = YES;
        [NSThread detachNewThreadSelector:@selector(load)toTarget:self withObject:nil];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    [self.loaderAnimation stopAnimation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (self.canuError == CANUErrorLocationNotDetermined) {
        [[ErrorManager sharedErrorManager] visualAlertFor:CANUErrorLocationRestricted];
    }
    
    self.canuError = CANUErrorLocationRestricted;
    [self showFeedback];
    [self.loaderAnimation stopAnimation];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newY;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    [self.loaderAnimation contentOffset:newY];
    
    if (!_isReload) {
        
        if (newY < 0) {
            
            float value = 0,start = 0,end = 50,newYAbs;
            
            newYAbs = fabsf(newY);
            
            if (newYAbs > start && newYAbs <= end) {
                value = (newYAbs - start) / (end - start);
            }else if (newYAbs > end){
                value = 1;
            }else if (newYAbs <= start){
                value = 0;
            }
            
            [self.navigation changePosition:value];
            
            if (self.isEmpty) {
                self.imageEmptyFeed.frame = CGRectMake(0, - newYAbs + (self.view.frame.size.height - 480)/2 + 30 + _correctionFeedViewProfile, 320, 480);
                self.titleFeed.frame = CGRectMake(10,  - newYAbs * 0.6f + (self.view.frame.size.height - 480)/2 + 300 + _correctionFeedViewProfile, 300, 20);
                self.feedbackMessage.frame = CGRectMake(40.0f, - newYAbs * 0.6f + (self.view.frame.size.height - 480)/2 + 320 + _correctionFeedViewProfile, 240.0f, 100.0f);
            }
            
        } else {
            
            [self.navigation changePosition:0];
            
            if (self.isEmpty) {
                self.imageEmptyFeed.frame = CGRectMake(0, (self.view.frame.size.height - 480)/2 + 30 + _correctionFeedViewProfile, 320, 480);
                self.titleFeed.frame = CGRectMake(10,(self.view.frame.size.height - 480)/2 + 300 + _correctionFeedViewProfile, 300, 20);
                self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 320 + _correctionFeedViewProfile, 240.0f, 100.0f);
            }
            
        }
        
    }
    
    if (_feedType == FeedProfileType) {
        
        if (newY >= 0) {
            [self.delegate moveProfileView:newY];
        }
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= -80.0f ){
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
    }
    
    if (_feedType == FeedProfileType && !decelerate) {
        if (newY >= 0 && newY < 165/3) {
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
            } completion:^(BOOL finished) {
                self.profileViewHidden = NO;
            }];
            
        } else if (newY >= 165/3 && newY <= 165) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.scrollview setContentOffsetReverse:CGPointMake(0, 165)];
            } completion:^(BOOL finished) {
                self.profileViewHidden = YES;
            }];
        }
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    if (_feedType == FeedProfileType) {
        if (newY >= 0 && newY < 165/3) {
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
            } completion:^(BOOL finished) {
                self.profileViewHidden = NO;
            }];
            
        } else if (newY >= 165/3 && newY <= 165) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.scrollview setContentOffsetReverse:CGPointMake(0, 165)];
            } completion:^(BOOL finished) {
                self.profileViewHidden = YES;
            }];
        }
        
    }
    
}

#pragma mark - CreateEditActivityViewControllerDelegate

- (void)createEditActivityIsFinish:(Activity *)activity{
    
    if (_feedType == FeedProfileType) {
        if (!_profileViewHidden) {
            [self.delegate hiddenProfileView:NO Animated:YES];
        }
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.feedViewController updateActivity:activity];
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        [UIView animateWithDuration:0.4 delay:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.frame = CGRectMake(10, _scrollview.contentSize.height - ( i * (130 + 10) + _marginFirstActivity ) - 130, 300, 130);
            cell.alpha = 1;
            [cell hiddenBottomBar:NO];
            [self.navigation changePosition:0];
        } completion:nil];
        
    }
    
    UICanuNavigationController *navigation = appDelegate.canuViewController;
    
    navigation.control.hidden = NO;
    
    [UIView animateWithDuration:0.4 delay:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        navigation.control.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)currentActivityWasDeleted:(Activity *)activity{
    
    if (_feedType == FeedProfileType) {
        if (!_profileViewHidden) {
            [self.delegate hiddenProfileView:YES Animated:YES];
        }
    }
    
    NSMutableArray *newArrayCell = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [_activities count]; i++) {
        
        Activity *act = [_activities objectAtIndex:i];
        
        if (act != activity) {
            [newArrayCell addObject:act];
        }
        
    }
    
    self.activities = [NSArray arrayWithArray:newArrayCell];
    
    [self.arrayCell removeObject:self.cellSaveForEdit];
    [self.cellSaveForEdit removeFromSuperview];
    
    float heightContentScrollView = [_arrayCell count] * (130 + 10) + _marginFirstActivity;
    
    if (heightContentScrollView <= _scrollview.frame.size.height) {
        heightContentScrollView = _scrollview.frame.size.height + 1;
    }
    
    if (_feedType == FeedProfileType) {
        if (heightContentScrollView <= _scrollview.frame.size.height + 165) {
            heightContentScrollView = _scrollview.frame.size.height + 165;
        }
    }
    
    self.scrollview.contentSize = CGSizeMake(320, heightContentScrollView);
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.frame = CGRectMake(10, _scrollview.contentSize.height - ( i * (130 + 10) + _marginFirstActivity ) - 130, 300, 130);
            cell.alpha = 1;
            [cell hiddenBottomBar:NO];
            [self.navigation changePosition:0];
        } completion:^(BOOL finished) {
            if (i == 0) {
                [NSThread detachNewThreadSelector:@selector(showActivities) toTarget:self withObject:nil];
                if (_feedType == FeedLocalType) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTribes" object:nil];
                }else if (_feedType == FeedTribeType) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                }else if (_feedType == FeedProfileType) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTribes" object:nil];
                }
            }
        }];
        
    }
    
}

#pragma mark - Public

/**
 *  Reload the feed view
 */
- (void)reload{
    
    self.isReload = YES;
    
    [self.loaderAnimation startAnimation];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollview.frame = CGRectMake(0, - 58, _scrollview.frame.size.width, _scrollview.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self load];
        
    }];
    
}

- (void)updateActivity:(Activity *)activity{
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        if (cell.activity.activityId == activity.activityId) {
            [cell updateWithActivity:activity];
        }
        
    }
}

/**
 *  Remove the view after logout / and children
 */
- (void)removeAfterlogOut{
    
    [self.titleFeed removeFromSuperview];
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
    self.titleFeed = nil;
    
}

- (void)killCurrentDetailsViewController{
    
    if (_detailActivity) {
        [self killViewController:_detailActivity];
    }
    
}

- (void)arrowAnimateHidden:(BOOL)hidden{
    
    self.arrowAnimate.hidden = hidden;
    
}

#pragma mark - Private

#pragma mark -- Load

- (void)load{
    
    [self loadWithCompletion:nil];

}

- (void)loadWithCompletion:(void (^)(NSError *error))block{
    
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
                        self.imageEmptyFeed.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2 + 30 + _correctionFeedViewProfile, 320, 480);
                        self.titleFeed.frame = CGRectMake(10,(self.view.frame.size.height - 480)/2 + 300 + _correctionFeedViewProfile, 300, 20);
                        self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 320 + _correctionFeedViewProfile, 240.0f, 100.0f);
                    }
                } completion:^(BOOL finished) {
                    [self.loaderAnimation stopAnimation];
                    
                    self.isReload = NO;
                    
                }];
            }
            
            [self.loaderAnimation stopAnimation];
            
            if (block) {
                block(error);
            }
            
        }];
        
    }else if(_feedType == FeedTribeType){
        
        [self.user userActivitiesTribesWithBlock:^(NSArray *activities, NSError *error) {
            
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
                        self.imageEmptyFeed.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2 + 30 + _correctionFeedViewProfile, 320, 480);
                        self.titleFeed.frame = CGRectMake(10, (self.view.frame.size.height - 480)/2 + 300 + _correctionFeedViewProfile, 300, 20);
                        self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 320 + _correctionFeedViewProfile, 240.0f, 100.0f);
                    }
                } completion:^(BOOL finished) {
                    
                    [self.loaderAnimation stopAnimation];
                    
                    self.isReload = NO;
                    
                }];
            }
            
            [self.loaderAnimation stopAnimation];
            
            if (block) {
                block(error);
            }
            
        }];
        
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
                        self.imageEmptyFeed.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2 + 30 + _correctionFeedViewProfile, 320, 480);
                        self.titleFeed.frame = CGRectMake(10, (self.view.frame.size.height - 480)/2 + 300 + _correctionFeedViewProfile, 300, 20);
                        self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 320 + _correctionFeedViewProfile, 240.0f, 100.0f);
                    }
                } completion:^(BOOL finished) {
                    
                    [self.loaderAnimation stopAnimation];
                    
                    self.isReload = NO;
                    
                }];
            }
            
            [self.loaderAnimation stopAnimation];
            
            if (block) {
                block(error);
            }
            
        }];
    }
    
}

- (void)showFeedback{
    
    if (self.canuError == CANUErrorLocationRestricted || self.canuError == CANUErrorLocationNotDetermined) {
        
        self.isEmpty = YES;
        
        self.feedbackMessage.text = NSLocalizedString(@"We need to know where you are", nil);
        
        self.imageEmptyFeed.image = [UIImage imageNamed:@"Activity_Empty_feed_illustration_local"];
        
        self.callBackActionEmptyFeed.hidden = NO;
        [self.callBackActionEmptyFeed setTitle:NSLocalizedString(@"Enable my GPS", nil) forState:UIControlStateNormal];
        
        [UIView  animateWithDuration:0.4 animations:^{
            self.feedbackMessage.alpha = 1;
            self.titleFeed.alpha = 1;
            self.imageEmptyFeed.alpha = 1;
            self.callBackActionEmptyFeed.alpha = 1;
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
        
        [self.arrowAnimate startAnimating];
        
        [UIView  animateWithDuration:0.4 animations:^{
            self.feedbackMessage.alpha = 1;
            self.titleFeed.alpha = 1;
            self.imageEmptyFeed.alpha = 1;
            self.arrowAnimate.alpha = 1;
        } completion:nil];
        [self showActivities];
    } else {
        self.isEmpty = NO;
        [UIView  animateWithDuration:0.4 animations:^{
            self.feedbackMessage.alpha = 0;
            self.imageEmptyFeed.alpha = 0;
            self.callBackActionEmptyFeed.alpha = 0;
            self.arrowAnimate.alpha = 0;
            self.titleFeed.alpha = 0;
        } completion:^(BOOL finished) {
            [self.arrowAnimate stopAnimating];
            self.callBackActionEmptyFeed.hidden = YES;
        }];
    }
    
    if (self.isEmpty && _feedType == FeedTribeType) {
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
    
    float heightContentScrollView = [_activities count] * (130 + 10) + _marginFirstActivity;
    
    if (heightContentScrollView <= _scrollview.frame.size.height) {
        heightContentScrollView = _scrollview.frame.size.height + 1;
    }
    
    if (_feedType == FeedProfileType) {
        if (heightContentScrollView <= _scrollview.frame.size.height + 165) {
            heightContentScrollView = _scrollview.frame.size.height + 165;
        }
    }
    
    self.scrollview.contentSize = CGSizeMake(320, heightContentScrollView);
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
    for (int i = 0; i < [_activities count]; i++) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchCell:)];
        
        Activity *activity= [_activities objectAtIndex:i];
        
        UICanuActivityCellScroll *cell = [[UICanuActivityCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( i * (130 + 10) + _marginFirstActivity ) - 130, 300, 130) andActivity:activity];
        cell.activity = activity;
        cell.delegate = self;
        cell.tag = i;
        [cell addGestureRecognizer:tap];
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        if (_isFirstTime) {
            
            [cell animateAfterDelay:0.1 + i * 0.15];
            
            if (i == [_activities count] - 1) {
                self.isFirstTime = NO;
            }
        }
        
    }
    
    
    
}

#pragma mark -- Event

- (void)cellEventActionButton:(UICanuActivityCellScroll *)cell{
    
    if (cell.activity.status == UICanuActivityCellGo) {
        
        [cell.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
        
        [cell.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Action" label:@"Unsubscribe" value:nil] build]];
                
                _activities = activities;
                
                if (_feedType == FeedLocalType) {
                    [self load];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTribes" object:nil];
                }else if (_feedType == FeedTribeType) {
                    [self load];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                }else if (_feedType == FeedProfileType) {
                    [self load];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTribes" object:nil];
                }
            }
        }];
        
    }else if (cell.activity.status == UICanuActivityCellEditable) {
        [self editCell:cell];
    }else if (cell.activity.status == UICanuActivityCellToGo) {
        
        [[ErrorManager sharedErrorManager] showG3bAlertIfNecessary];
        
        [cell.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
        
        [cell.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Action" label:@"Subscribe" value:nil] build]];
                
                _activities = activities;
                
                if (_feedType == FeedLocalType) {
                    [self load];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTribes" object:nil];
                }else if (_feedType == FeedTribeType) {
                    [self load];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadProfile" object:nil];
                }else if (_feedType == FeedProfileType) {
                    [self load];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLocal" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTribes" object:nil];
                }
            }
        }];

    }
}

- (void)touchCell:(UITapGestureRecognizer *)sender{
    
    if (_feedType == FeedProfileType) {
        if (!_profileViewHidden) {
            [self.delegate hiddenProfileView:YES Animated:YES];
        }
    }
    
    UICanuActivityCellScroll *cellTouch = (UICanuActivityCellScroll *)sender.view;
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        if (i < cellTouch.tag) {
            
            float distance = cell.frame.origin.y + cellTouch.frame.origin.y + cellTouch.frame.size.height + 10;
            
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
                cell.alpha = 0;
            }];
            
        }else if (i == cellTouch.tag){
            
            Activity *activity = [_activities objectAtIndex:cellTouch.tag];
            
            float position = cellTouch.frame.origin.y - _scrollview.contentOffset.y;
            
            DetailActivityViewControllerAnimate *davc = [[DetailActivityViewControllerAnimate alloc]initFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) andActivity:activity For:CANUOpenDetailsActivityAfterFeedView andPosition:position];
            davc.delegate = self;
            davc.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self addChildViewController:davc];
            [self.view addSubview:davc.view];
            
            self.detailActivity = davc;
            
            cellTouch.alpha = 0;
            
        }else{
            
            float distance = cell.frame.origin.y - cellTouch.frame.origin.y;
            
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
                cell.alpha = 0;
            }];
            
        }
        
    }
    
}

- (void)openActivityAfterPush:(NSInteger)activityId{
    
    UICanuActivityCellScroll *cellTouch;
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        if (cell.activity.activityId == activityId) {
            cellTouch = cell;
        }
        
    }
    
    if (!cellTouch) {
        
        [self loadWithCompletion:^(NSError *error) {
            
            BOOL activityIsFind = false;
            
            for (int i = 0; i < [_arrayCell count]; i++) {
                
                UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
                
                if (cell.activity.activityId == activityId) {
                    activityIsFind = true;
                }
                
            }
            
            if (!error && activityIsFind) {
                [self openActivityAfterPush:activityId];
            }
            
        }];
        
        return;
        
    }
    
    if (_feedType == FeedProfileType) {
        if (!_profileViewHidden) {
            [self.delegate hiddenProfileView:YES Animated:NO];
        }
    }
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        if (i < cellTouch.tag) {
            
            float distance = cell.frame.origin.y + cellTouch.frame.origin.y + cellTouch.frame.size.height + 10;
            
            cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
            cell.alpha = 0;
            
        }else if (i == cellTouch.tag){
            
            Activity *activity = [_activities objectAtIndex:cellTouch.tag];
            
            float position = cellTouch.frame.origin.y - _scrollview.contentOffset.y;
            
            DetailActivityViewControllerAnimate *davc = [[DetailActivityViewControllerAnimate alloc]initFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) andActivity:activity For:CANUOpenDetailsActivityAfterPush andPosition:position];
            davc.delegate = self;
            davc.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self addChildViewController:davc];
            [self.view addSubview:davc.view];
            
            self.detailActivity = davc;
            
            cellTouch.alpha = 0;
            
        }else{
            
            float distance = cell.frame.origin.y - cellTouch.frame.origin.y;
            
            cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
            cell.alpha = 0;
            
        }
        
    }
    
}

- (void)editCell:(UICanuActivityCellScroll *)cellTouch{
    
    if (_feedType == FeedProfileType) {
        if (!_profileViewHidden) {
            [self.delegate hiddenProfileView:YES Animated:YES];
        }
    }
    
    self.cellSaveForEdit = cellTouch;
    
    float cellPositionY = cellTouch.frame.origin.y;
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        if (i < cellTouch.tag) {
            
            float distance = cell.frame.origin.y + cellPositionY + cellTouch.frame.size.height + 10;
            
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
                cell.alpha = 0;
            }];
            
        }else if (i == cellTouch.tag){
            
            float position = self.scrollview.contentOffset.y + 10;
            
            [UIView animateWithDuration:0.4 animations:^{
                cellTouch.frame = CGRectMake(cell.frame.origin.x, position, cell.frame.size.width, cell.frame.size.height);
                [cellTouch hiddenBottomBar:YES];
                [self.navigation changePosition:1];
            } completion:^(BOOL finished) {
                CreateEditActivityViewController *editView = [[CreateEditActivityViewController alloc]initForEdit:cell.activity];
                editView.delegate = self;
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                
                [appDelegate.feedViewController addChildViewController:editView];
                [appDelegate.feedViewController.view addSubview:editView.view];
            }];
            
        }else{
            
            float distance = cell.frame.origin.y - cellPositionY;
            
            [UIView animateWithDuration:0.4 animations:^{
                cell.frame = CGRectMake(cell.frame.origin.x, distance, cell.frame.size.width, cell.frame.size.height);
                cell.alpha = 0;
            }];
            
        }
        
    }
    
}

#pragma mark -- Others

- (BOOL)pushChatIsCurrentDetailsViewOpen:(NSInteger)activityId{
    
    BOOL isOpen = false;
    
    if (_detailActivity) {
        if (self.detailActivity.activity.activityId == activityId) {
            isOpen = true;
        }
    }
    
    return isOpen;
    
}

- (void)closeDetailActivity:(DetailActivityViewControllerAnimate *)viewController{
    
    for (int i = 0; i < [_arrayCell count]; i++) {
     
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        [UIView animateWithDuration:0.4 animations:^{
            cell.frame = CGRectMake(10, _scrollview.contentSize.height - ( i * (130 + 10) + _marginFirstActivity ) - 130, 300, 130);
            if (cell.activity != viewController.activity) {
                cell.alpha = 1;
            }
        }completion:^(BOOL finished) {
            // After end animation / Only one time
            if (_feedType == FeedProfileType) {
                if (!_profileViewHidden) {
                    [self.delegate hiddenProfileView:NO Animated:YES];
                }
            }
        }];
        
    }
    
    if (viewController.closeAfterDelete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
    }
    
    [self performSelector:@selector(killViewController:) withObject:viewController afterDelay:0.4];
    
}

- (void)callBackAction{
    
    if (self.canuError == CANUErrorLocationNotDetermined) {
        [self.locationManager startUpdatingLocation];
    } else if (self.canuError == CANUErrorLocationRestricted) {
        [[ErrorManager sharedErrorManager] visualAlertFor:CANUErrorLocationRestricted];
    } else {
        CreateEditActivityViewController *editView = [[CreateEditActivityViewController alloc]initForCreate];
        [self presentViewController:editView animated:YES completion:nil];
    }
    
}

-(void)killViewController:(id)sender{
    
    self.detailActivity = nil;
    
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

@end
