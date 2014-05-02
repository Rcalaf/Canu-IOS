//
//  ActivitiesFeedViewController.m
//  CANU
//
//  Created by Roger Calaf on 17/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//
#import "UIImageView+AFNetworking.h"
#import "ActivitiesFeedViewController.h"
#import "UICanuNavigationController.h"
#import "UIProfileView.h"
#import "User.h"
#import "UserManager.h"
#import "Activity.h"
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"
#import "UserSettingsViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "TutorialViewController.h"
#import "UIView+DTDebug.h"

@interface ActivitiesFeedViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ActivityScrollViewControllerDelegate>

@property (nonatomic) float lastPosition;
@property (nonatomic) BOOL firstAnimationEmptyFeed;
@property (strong, nonatomic) UIView *viewForEmptyBackground;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIProfileView *profileView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) TutorialViewController *tutorialViewController;

@end

@implementation ActivitiesFeedViewController 

#pragma mark - Lifecycle

- (void)loadView{
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, result.width, result.height)];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![AFCanuAPIClient sharedClient].distributionMode) {
        // MainQueue UIView
        [UIView toggleViewMainThreadChecking];
    }
    
    self.firstAnimationEmptyFeed = NO;
    
    self.lastPosition = 0.5f;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Tribes Feed"];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    self.appDelegate.oldScreenName = @"Tribes Feed";
    
    self.view.backgroundColor = backgroundColorView;
    
    self.navigationController.navigationBarHidden = YES;
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = [[UserManager sharedUserManager] currentUser];
    
    self.viewForEmptyBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.viewForEmptyBackground.backgroundColor = UIColorFromRGB(0x2b4b58);
    self.viewForEmptyBackground.alpha = 0;
    [self.view addSubview:_viewForEmptyBackground];
    
    UIImageView *backgroundImageEmptyFeed= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    backgroundImageEmptyFeed.image = [UIImage imageNamed:@"Activity_Empty_feed_Bakground"];
    [self.viewForEmptyBackground addSubview:backgroundImageEmptyFeed];
    
    if (IS_OS_7_OR_LATER) {
        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-20);
        verticalMotionEffect.maximumRelativeValue = @(20);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-20);
        horizontalMotionEffect.maximumRelativeValue = @(20);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to your view
        [backgroundImageEmptyFeed addMotionEffect:group];
    }
    
    self.localFeed = [[ActivityScrollViewController alloc] initFor:FeedLocalType andUser:_user andFrame:CGRectMake(-320, 0, 320, self.view.frame.size.height)];
    self.localFeed.delegate = self;
    [self addChildViewController:_localFeed];
    [self.view addSubview:_localFeed.view];
    
    self.tribeFeed = [[ActivityScrollViewController alloc] initFor:FeedTribeType andUser:_user andFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.tribeFeed.delegate = self;
    [self addChildViewController:_tribeFeed];
    [self.view addSubview:_tribeFeed.view];
    
    self.profilFeed = [[ActivityScrollViewController alloc] initFor:FeedProfileType andUser:_user andFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    self.profilFeed.delegate = self;
    [self addChildViewController:_profilFeed];
    [self.view addSubview:_profilFeed.view];
    
    self.profileView = [[UIProfileView alloc] initWithFrame:CGRectMake(320, self.view.frame.size.height - 165, 320, 165) User:self.user];
    [self.view addSubview:_profileView];
    
    self.animationCreateActivity = [[AnimationCreateActivity alloc]init];
    [self.view addSubview:_animationCreateActivity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadActivity) name:@"reloadActivity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLocal) name:@"reloadLocal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTribes) name:@"reloadTribes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile) name:@"reloadProfile" object:nil];
    
}

- (void)dealloc{
    
    NSLog(@"dealloc ActivitiesFeedViewController");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters

- (void)setActiveTutorial:(BOOL)activeTutorial{
    
    _activeTutorial = activeTutorial;
    
    if (_activeTutorial) {
        
        [self.localFeed arrowAnimateHidden:YES];
        [self.tribeFeed arrowAnimateHidden:YES];
        [self.profilFeed arrowAnimateHidden:YES];
        
        // Reset position to Tribes
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.feedViewController changePosition:0.5];
        [delegate.canuViewController changePage:0.5];
        
        self.tutorialViewController = [[TutorialViewController alloc]init];
        [self addChildViewController:self.tutorialViewController];
        [self.view addSubview:self.tutorialViewController.view];
        
    }
    
}

#pragma mark - Private

- (float)alphaBackgroundEmptyValueForPosition:(float)position{
    
    float valueAlpha = 0;
    
    if (position >= 0 && position <= 0.5) {
    
        if (self.localFeed.isEmpty) {
            valueAlpha += 1 - position * 2;
        }
        
        if (self.tribeFeed.isEmpty) {
            valueAlpha += position * 2;
        }
        
        self.viewForEmptyBackground.alpha = valueAlpha;
        
    } else if (position > 0.5 && position <= 1){
    
        if (self.tribeFeed.isEmpty) {
            valueAlpha += 2 - position * 2;
        }
        
        if (self.profilFeed.isEmpty) {
            valueAlpha += (position - 0.5) * 2;
        }
        
        self.viewForEmptyBackground.alpha = valueAlpha;
        
    }
    
    return valueAlpha;
    
}

- (void)animationNavBox:(float)position{
    
    self.localFeed.view.frame = CGRectMake( - position * 640, 0, 320, self.view.frame.size.height);
    self.tribeFeed.view.frame = CGRectMake( - ( position - 0.5f ) * 640, 0, 320, self.view.frame.size.height);
    self.profilFeed.view.frame = CGRectMake( - ( position - 1.0f ) * 640, 0, _profilFeed.view.frame.size.width, _profilFeed.view.frame.size.height);
    self.profileView.frame = CGRectMake( - ( position - 1.0f ) * 640, _profileView.frame.origin.y, _profileView.frame.size.width, _profileView.frame.size.height);
    
    float alphaTribes = position * 2;
    if (alphaTribes > 1) {
        alphaTribes = alphaTribes - 2 * (alphaTribes - 1);
    }
    
    self.localFeed.view.alpha = 1 - position * 2;
    self.tribeFeed.view.alpha = alphaTribes;
    self.profilFeed.view.alpha = position * 2 -1;
    self.profileView.alpha = position * 2 -1;
    
    self.viewForEmptyBackground.alpha = [self alphaBackgroundEmptyValueForPosition:position];
    
}

#pragma mark - Public

- (void)changePosition:(float)position{
    
    self.lastPosition = position;
    
    [self animationNavBox:position];
    
    if (position == 0) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Local Feed"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        self.appDelegate.oldScreenName = @"Local Feed";
    } else if (position == 0.5) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Tribes Feed"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        self.appDelegate.oldScreenName = @"Tribes Feed";
    } else if (position == 1) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Profile Feed"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        self.appDelegate.oldScreenName = @"Profile Feed";
    }
    
}

- (void)changePositionForTutorial:(float)position{
    
    if (_activeTutorial) {
        [self.tutorialViewController positionNavBox:position];
    }
    
}

- (void)removeAfterlogOut{
    
    [self.profileView removeFromSuperview];
    self.profileView = nil;
    
    [self.profilFeed removeAfterlogOut];
    [self.profilFeed willMoveToParentViewController:nil];
    [self.profilFeed.view removeFromSuperview];
    [self.profilFeed removeFromParentViewController];
    self.profilFeed = nil;
    
    [self.localFeed removeAfterlogOut];
    [self.localFeed willMoveToParentViewController:nil];
    [self.localFeed.view removeFromSuperview];
    [self.localFeed removeFromParentViewController];
    self.localFeed = nil;
    
    [self.tribeFeed removeAfterlogOut];
    [self.tribeFeed willMoveToParentViewController:nil];
    [self.tribeFeed.view removeFromSuperview];
    [self.tribeFeed removeFromParentViewController];
    self.tribeFeed = nil;
    
}

- (BOOL)pushChatIsCurrentDetailsViewOpen:(NSInteger)activityId{
    
    BOOL isOpen = false;
    
    if ([self.localFeed pushChatIsCurrentDetailsViewOpen:activityId]) {
        isOpen = true;
    }
    
    if ([self.tribeFeed pushChatIsCurrentDetailsViewOpen:activityId]) {
        isOpen = true;
    }
    
    if ([self.profilFeed pushChatIsCurrentDetailsViewOpen:activityId]) {
        isOpen = true;
    }
    
    return isOpen;
    
}

- (void)killCurrentDetailsViewController{
    
    [self.localFeed killCurrentDetailsViewController];
    [self.tribeFeed killCurrentDetailsViewController];
    [self.profilFeed killCurrentDetailsViewController];
    
}

- (void)stopTutorial{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.tutorialViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tutorialViewController forceDealloc];
        [self.tutorialViewController willMoveToParentViewController:nil];
        [self.tutorialViewController.view removeFromSuperview];
        [self.tutorialViewController removeFromParentViewController];
        self.tutorialViewController = nil;
        [self.localFeed arrowAnimateHidden:NO];
        [self.tribeFeed arrowAnimateHidden:NO];
        [self.profilFeed arrowAnimateHidden:NO];
    }];
    
}

- (void)tutorialStopMiddelLocalStep{
    [self.tutorialViewController tutorialStopMiddelLocalStep];
}

- (void)updateActivity:(Activity *)activity{
    [self.localFeed updateActivity:activity];
    [self.tribeFeed updateActivity:activity];
    [self.profilFeed updateActivity:activity];
}

#pragma mark - NSNotificationCenter

- (void)reloadActivity{
    [self.localFeed load];
    [self.tribeFeed load];
    [self.profilFeed load];
}

- (void)reloadLocal{
    [self.localFeed load];
}

- (void)reloadTribes{
    [self.tribeFeed load];
}

- (void)reloadProfile{
    [self.profilFeed load];
}

#pragma mark - ActivityScrollViewControllerDelegate

- (void)activityScrollViewControllerStartWithEmptyFeed{
    
    if (!self.firstAnimationEmptyFeed) {
        
        self.firstAnimationEmptyFeed = YES;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.viewForEmptyBackground.alpha = 1;
        }];
        
    }
    
}

- (void)activityScrollViewControllerChangementFeed{
    
    [UIView animateWithDuration:0.4 animations:^{
        [self animationNavBox:self.lastPosition];
        [self.profileView forEmptyFeed:self.profilFeed.isEmpty];
    }];
}

- (void)hiddenProfileView:(BOOL)hidden Animated:(BOOL)animated{
    
    float duration = 0.4f;
    
    if (!animated) {
        duration = 0;
    }
    
    if (hidden) {
        [UIView animateWithDuration:duration animations:^{
            self.profileView.frame = CGRectMake(_profileView.frame.origin.x, self.view.frame.size.height, _profileView.frame.size.width, _profileView.frame.size.height);
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.profileView.frame = CGRectMake(_profileView.frame.origin.x, self.view.frame.size.height - _profileView.frame.size.height, _profileView.frame.size.width, _profileView.frame.size.height);
        }];
    }
    
}

- (void)moveProfileView:(float)offset{
    
    [self.profileView animationProfileViewWithScroll:offset];
    self.profileView.frame = CGRectMake(_profileView.frame.origin.x, self.view.frame.size.height - (_profileView.frame.size.height - offset), _profileView.frame.size.width, _profileView.frame.size.height);
    
}

@end
