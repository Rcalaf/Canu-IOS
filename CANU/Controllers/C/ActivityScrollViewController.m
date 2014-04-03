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
#import "TTTAttributedLabel.h"
#import "CounterTextViewController.h"
#import "GAIFields.h"
#import "UserManager.h"

#import "AppDelegate.h"

#import "Activity.h"

@interface ActivityScrollViewController () <CLLocationManagerDelegate,UIScrollViewDelegate,DetailActivityViewControllerAnimateDelegate>

@property (nonatomic) BOOL isReload;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) BOOL loadFirstTime;
@property (nonatomic) BOOL profileViewHidden;
@property (nonatomic) BOOL counterModeEnable; // Counter
@property (nonatomic) BOOL isCountIn; // Counter
@property (nonatomic) int marginFirstActivity;
@property (nonatomic) CANUError canuError;
@property (nonatomic) FeedTypes feedType;
@property (nonatomic, readonly) CLLocationCoordinate2D currentLocation;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *arrayCell;
@property (strong, nonatomic) UIImageView *imageEmptyFeed;
@property (strong, nonatomic) UITextView *feedbackMessage;
@property (strong, nonatomic) UIButton *callBackActionEmptyFeed;
@property (strong, nonatomic) UILabel *counter; // Counter
@property (strong, nonatomic) UILabel *peopleInclued; // Counter
@property (strong, nonatomic) UILabel *earlyBird; // Counter
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) TTTAttributedLabel *textCounter; // Counter
@property (strong, nonatomic) UIScrollViewReverse *scrollview;
@property (strong, nonatomic) LoaderAnimation *loaderAnimation;
@property (strong, nonatomic) UICanuNavigationController *navigation;

@end

@implementation ActivityScrollViewController

@synthesize locationManager = _locationManager;

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
        
        self.counterModeEnable = NO;
        
        self.isCountIn = NO;
        
        self.isUnlock = NO;
        
        if (_feedType == FeedProfileType) {
            _marginFirstActivity = 10 + 165;
        } else {
            _marginFirstActivity = 20;
        }
        
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
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake(145, self.view.frame.size.height - 30 - 19, 30, 30) withStart:-30 andEnd:-100];
        [self.loaderAnimation startAnimation];
        [self.view addSubview:_loaderAnimation];
        
        if (_feedType == FeedLocalType) {
            
            if (true) { // Counter Mode is Enable
                
                self.counterModeEnable = YES;
                
                self.counter = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 480)/2 + 80.0f, 320, 50)];
                self.counter.textColor = [UIColor whiteColor];
                self.counter.font = [UIFont fontWithName:@"Lato-Bold" size:45];
                self.counter.textAlignment = NSTextAlignmentCenter;
                self.counter.backgroundColor = [UIColor clearColor];
                self.counter.alpha = 0;
                [self.view addSubview:_counter];
                
                self.peopleInclued = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 480)/2 + 130, 320, 20)];
                self.peopleInclued.textColor = [UIColor whiteColor];
                self.peopleInclued.font = [UIFont fontWithName:@"Lato-Regular" size:12];
                self.peopleInclued.textAlignment = NSTextAlignmentCenter;
                self.peopleInclued.backgroundColor = [UIColor clearColor];
                self.peopleInclued.text = NSLocalizedString(@"people included", nil);
                self.peopleInclued.alpha = 0;
                [self.view addSubview:_peopleInclued];
                
                self.earlyBird = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 480)/2 + 325, 320, 20)];
                self.earlyBird.textColor = [UIColor whiteColor];
                self.earlyBird.font = [UIFont fontWithName:@"Lato-Regular" size:12];
                self.earlyBird.textAlignment = NSTextAlignmentCenter;
                self.earlyBird.backgroundColor = [UIColor clearColor];
                self.earlyBird.text = NSLocalizedString(@"Want early access?", nil);
                self.earlyBird.alpha = 0;
                [self.view addSubview:_earlyBird];
                
                [NSThread detachNewThreadSelector:@selector(checkCounter)toTarget:self withObject:nil];
                
            } else {
                
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
        
        if (self.counterModeEnable) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openWebViewCounter)];
            
            self.textCounter = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(50.0f, (self.view.frame.size.height - 480)/2 + 230.0f, 220.0f, 60)];
            self.textCounter.text = NSLocalizedString(@"Locked until we are enougth.\nRead why", nil);
            self.textCounter.textColor = [UIColor whiteColor];
            self.textCounter.font = [UIFont fontWithName:@"Lato-Regular" size:14];
            self.textCounter.textAlignment = NSTextAlignmentCenter;
            self.textCounter.numberOfLines = 2;
            self.textCounter.backgroundColor = [UIColor clearColor];
            [self.textCounter addGestureRecognizer:tap];
            [self.view addSubview:_textCounter];
            
            [self.textCounter setText:self.textCounter.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                NSRange termsRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Read why", nil) options:NSCaseInsensitiveSearch];
                
                [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:termsRange];
                
                return mutableAttributedString;
                
            }];
        }
        
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
            
            if (self.counterModeEnable && !self.isUnlock) {
                self.textCounter.frame = CGRectMake(50.0f, - newYAbs * 0.6f + (self.view.frame.size.height - 480)/2 + 230.0f, 220.0f, 60);
                self.counter.frame = CGRectMake(0, - newYAbs + (self.view.frame.size.height - 480)/2 + 80.0f, 320, 50);
                self.peopleInclued.frame = CGRectMake(0, - newYAbs + (self.view.frame.size.height - 480)/2 + 130, 320, 20);
            } else if (self.isEmpty) {
                self.imageEmptyFeed.frame = CGRectMake(0, - newYAbs + (self.view.frame.size.height - 480)/2, 320, 480);
                self.feedbackMessage.frame = CGRectMake(40.0f, - newYAbs * 0.6f + (self.view.frame.size.height - 480)/2 + 270.0f, 240.0f, 100.0f);
            }
            
        } else {
            
            [self.navigation changePosition:0];
            
            if (self.counterModeEnable && !self.isUnlock) {
                self.textCounter.frame = CGRectMake(50.0f, (self.view.frame.size.height - 480)/2 + 230.0f, 220.0f, 60);
                self.counter.frame = CGRectMake(0, (self.view.frame.size.height - 480)/2 + 80.0f, 320, 50);
                self.peopleInclued.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2 + 130, 320, 20);
            } else if (self.isEmpty) {
                self.imageEmptyFeed.frame = CGRectMake(0, (self.view.frame.size.height - 480)/2, 320, 480);
                self.feedbackMessage.frame = CGRectMake(40.0f,(self.view.frame.size.height - 480)/2 + 270.0f, 240.0f, 100.0f);
            }
            
        }
        
    }
    
    if (_feedType == FeedProfileType) {
        
        [self.delegate moveProfileView:newY];
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= -100.0f ){
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

- (void)reload{
    
    self.isReload = YES;
    
    [self.loaderAnimation startAnimation];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollview.frame = CGRectMake(0, - 58, _scrollview.frame.size.width, _scrollview.frame.size.height);
    } completion:^(BOOL finished) {
        
        if (self.counterModeEnable && !self.isUnlock) {
            [self checkCounter];
        } else {
            [self load];
        }
        
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
    
    if (self.counterModeEnable && !self.isUnlock) {
        
        self.isEmpty = YES;
        
        self.callBackActionEmptyFeed.hidden = NO;
        
        [UIView  animateWithDuration:0.4 animations:^{
            self.callBackActionEmptyFeed.alpha = 1;
            self.counter.alpha = 1;
            self.peopleInclued.alpha = 1;
        } completion:nil];
        
    } else if (self.canuError == CANUErrorLocationRestricted || self.canuError == CANUErrorLocationNotDetermined) {
        
        self.isEmpty = YES;
        
        self.feedbackMessage.text = NSLocalizedString(@"We need to know where you are", nil);
        
        self.imageEmptyFeed.image = [UIImage imageNamed:@"Activity_Empty_feed_illustration_local"];
        
        self.callBackActionEmptyFeed.hidden = NO;
        [self.callBackActionEmptyFeed setTitle:NSLocalizedString(@"Enable my GPS", nil) forState:UIControlStateNormal];
        
        [UIView  animateWithDuration:0.4 animations:^{
            self.feedbackMessage.alpha = 1;
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

- (void)cellEventActionButton:(UICanuActivityCellScroll *)cell{
    
    if (cell.activity.status == UICanuActivityCellGo) {
        
        [cell.loadingIndicator startAnimating];
        cell.actionButton.hidden = YES;
        
        [cell.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Action" label:@"Unsubscribe" value:nil] build]];
                
                _activities = activities;
                NSLog(@"Array %@",activities);
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
        
        CreateEditActivityViewController *editView = [[CreateEditActivityViewController alloc]initForEdit:cell.activity];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        
        [appDelegate.feedViewController addChildViewController:editView];
        [appDelegate.feedViewController.view addSubview:editView.view];
        
    }else if (cell.activity.status == UICanuActivityCellToGo) {
        
        [[ErrorManager sharedErrorManager] showG3bAlertIfNecessary];
        
        [cell.loadingIndicator startAnimating];
        cell.actionButton.hidden = YES;
        
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
            [self.delegate hiddenProfileView:YES];
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

- (void)closeDetailActivity:(DetailActivityViewControllerAnimate *)viewController{
    
    if (_feedType == FeedProfileType) {
        if (!_profileViewHidden) {
            [self.delegate hiddenProfileView:NO];
        }
    }
    
    for (int i = 0; i < [_arrayCell count]; i++) {
     
        UICanuActivityCellScroll *cell = [_arrayCell objectAtIndex:i];
        
        [UIView animateWithDuration:0.4 animations:^{
            cell.frame = CGRectMake(10, _scrollview.contentSize.height - ( i * (130 + 10) + _marginFirstActivity ) - 130, 300, 130);
            if (cell.activity != viewController.activity) {
                cell.alpha = 1;
            }
        }];
        
    }
    
    if (viewController.closeAfterDelete) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
    }
    
    [self performSelector:@selector(killViewController:) withObject:viewController afterDelay:0.4];
    
}

- (void)callBackAction{
    
    if (self.counterModeEnable && !self.isUnlock && !self.isCountIn) {
        [self.loaderAnimation startAnimation];
        self.callBackActionEmptyFeed.hidden = YES;
        [[[UserManager sharedUserManager] currentUser] countMeWithBlock:^(NSError *error) {
            self.callBackActionEmptyFeed.hidden = NO;
            [self.loaderAnimation stopAnimation];
            [NSThread detachNewThreadSelector:@selector(checkCounter)toTarget:self withObject:nil];
        }];
    } else if (self.counterModeEnable && !self.isUnlock && self.isCountIn) {
        [self openWebViewCounter];
    } else if (self.canuError == CANUErrorLocationNotDetermined) {
        [self.locationManager startUpdatingLocation];
    } else if (self.canuError == CANUErrorLocationRestricted) {
        [[ErrorManager sharedErrorManager] visualAlertFor:CANUErrorLocationRestricted];
    } else {
        CreateEditActivityViewController *editView = [[CreateEditActivityViewController alloc]initForCreate];
        [self presentViewController:editView animated:YES completion:nil];
    }
    
}

- (void)checkCounter{
    
    [[[UserManager sharedUserManager] currentUser] checkCounterWithBlock:^(NSNumber *countTotal, NSNumber *isCountIn, NSNumber *isUnlock, NSError *error) {
        
        [self.loaderAnimation stopAnimation];
        
        if (error) {
            
            self.scrollview.contentSize = CGSizeMake(320, _scrollview.frame.size.height + 1);
            [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
            
            self.counter.text = @"0";
            [self.callBackActionEmptyFeed setTitle:NSLocalizedString(@"COUNT ME IN", nil) forState:UIControlStateNormal];
            self.callBackActionEmptyFeed.userInteractionEnabled = YES;
            
            if (_isReload) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    [self.navigation changePosition:0];
                    if (self.isEmpty) {
                        self.counter.frame = CGRectMake(0, (self.view.frame.size.height - 480)/2 + 80.0f, 320, 50);
                        self.textCounter.frame = CGRectMake(50, (self.view.frame.size.height - 480)/2 + 230.0f, 220.0f, 60);
                        self.peopleInclued.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2 + 130, 320, 20);
                    }
                } completion:^(BOOL finished) {
                    [self.loaderAnimation stopAnimation];
                    
                    self.isReload = NO;
                    
                }];
            }
            
            [self showFeedback];
            
        } else {
            
            self.isUnlock = [isUnlock boolValue];
            self.isCountIn = [isCountIn boolValue];
            
            if (_isUnlock) {
                
                self.counter.alpha = 0;
                self.counter.hidden = YES;
                
                self.peopleInclued.alpha = 0;
                self.peopleInclued.hidden = YES;
                
                self.textCounter.alpha = 0;
                self.textCounter.hidden = YES;
                
                self.earlyBird.alpha = 0;
                self.earlyBird.hidden = YES;
                
                [self.callBackActionEmptyFeed setTitle:NSLocalizedString(@"I want to change this", nil) forState:UIControlStateNormal];
                self.callBackActionEmptyFeed.hidden = YES;
                
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
                
                self.counter.text = [NSString stringWithFormat:@"%i",[countTotal intValue]];
                
                if (_isCountIn) {
                    self.textCounter.text = NSLocalizedString(@"We’ll let you know once\nnew areas go live.", nil);
                    [self.callBackActionEmptyFeed setTitle:NSLocalizedString(@"BECOME AN EARLY BIRD", nil) forState:UIControlStateNormal];
                    self.textCounter.gestureRecognizers = nil;
                    
                    self.earlyBird.hidden = NO;
                    self.earlyBird.alpha = 1;
                    
                } else {
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openWebViewCounter)];
                    [self.textCounter addGestureRecognizer:tap];
                    
                    self.textCounter.text = NSLocalizedString(@"Locked until we are enought.\nRead why", nil);
                    
                    [self.textCounter setText:self.textCounter.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                        
                        NSRange termsRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Read why", nil) options:NSCaseInsensitiveSearch];
                        
                        [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:termsRange];
                        
                        return mutableAttributedString;
                        
                    }];
                    
                    [self.callBackActionEmptyFeed setTitle:NSLocalizedString(@"COUNT ME IN", nil) forState:UIControlStateNormal];
                    
                    self.earlyBird.alpha = 0;
                    self.earlyBird.hidden = YES;
                    
                }
                
                self.scrollview.contentSize = CGSizeMake(320, _scrollview.frame.size.height + 1);
                [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
                
                if (_isReload) {
                    
                    [UIView animateWithDuration:0.4 animations:^{
                        [self.navigation changePosition:0];
                        if (self.isEmpty) {
                            self.counter.frame = CGRectMake(0, (self.view.frame.size.height - 480)/2 + 80.0f, 320, 50);
                            self.textCounter.frame = CGRectMake(50, (self.view.frame.size.height - 480)/2 + 230.0f, 220.0f, 60);
                            self.peopleInclued.frame = CGRectMake(0,(self.view.frame.size.height - 480)/2 + 130, 320, 20);
                        }
                    } completion:^(BOOL finished) {
                        [self.loaderAnimation stopAnimation];
                        
                        self.isReload = NO;
                        
                    }];
                }
                
                [self showFeedback];
                
            }
            
        }
        
    }];
    
}

- (void)openWebViewCounter{
    
    BOOL isEarlyBird = NO;
    
    if (self.counterModeEnable && self.isCountIn) {
        isEarlyBird = YES;
    }
    
    CounterTextViewController *counterTextViewController = [[CounterTextViewController alloc]initForEarlyBird:isEarlyBird];
    
    [self presentViewController:counterTextViewController animated:YES completion:nil];
    
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
    
//    if (_feedType == FeedLocalType) {
//        NSLog(@"dealloc ActivityScrollViewController Local");
//    }else if (_feedType == FeedTribeType){
//        NSLog(@"dealloc ActivityScrollViewController Tribes");
//    }else if (_feedType == FeedProfileType){
//        NSLog(@"dealloc ActivityScrollViewController Profile");
//    }
    
}

@end
