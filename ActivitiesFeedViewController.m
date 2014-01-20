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
#import "Activity.h"
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"
#import "UserSettingsViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface ActivitiesFeedViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ActivityScrollViewControllerDelegate>

@property (nonatomic) float lastPosition;
@property (nonatomic) BOOL firstAnimationEmptyFeed;
@property (strong, nonatomic) UIView *viewForEmptyBackground;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) ActivityScrollViewController *localFeed;
@property (strong, nonatomic) ActivityScrollViewController *tribeFeed;
@property (strong, nonatomic) ActivityScrollViewController *profilFeed;
@property (strong, nonatomic) UIProfileView *profileView;
@property (strong, nonatomic) AppDelegate *appDelegate;

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
    
    self.firstAnimationEmptyFeed = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Local Feed"];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    self.appDelegate.oldScreenName = @"Local Feed";
    
    self.view.backgroundColor = backgroundColorView;
    NSLog(@"Init ActivitiesFeedViewController");
    self.navigationController.navigationBarHidden = YES;
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = _appDelegate.user;
    
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
    
    self.localFeed = [[ActivityScrollViewController alloc] initFor:FeedLocalType andUser:_user andFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.localFeed.delegate = self;
    [self addChildViewController:_localFeed];
    [self.view addSubview:_localFeed.view];
    
    self.tribeFeed = [[ActivityScrollViewController alloc] initFor:FeedTribeType andUser:_user andFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    self.tribeFeed.delegate = self;
    [self addChildViewController:_tribeFeed];
    [self.view addSubview:_tribeFeed.view];
    
    self.profilFeed = [[ActivityScrollViewController alloc] initFor:FeedProfileType andUser:_user andFrame:CGRectMake(640, 0, 320, self.view.frame.size.height)];
    self.profilFeed.delegate = self;
    [self addChildViewController:_profilFeed];
    [self.view addSubview:_profilFeed.view];
    
    self.profileView = [[UIProfileView alloc] initWithUser:self.user andFrame:CGRectMake(0, self.view.frame.size.height, 320, 119)];
    [self.view addSubview:_profileView.mask];
    [self.view addSubview:_profileView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings:)];
    [_profileView.settingsButton addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic:)];
    [_profileView.profileImage addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadActivity) name:@"reloadActivity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLocal) name:@"reloadLocal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile) name:@"reloadProfile" object:nil];
    
}

- (void)dealloc{
    
    NSLog(@"dealloc ActivitiesFeedViewController");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.profilFeed.view.frame = CGRectMake( - ( position - 1.0f ) * 640, 0, 320, self.view.frame.size.height);
    
    float alphaTribes = position * 2;
    if (alphaTribes > 1) {
        alphaTribes = alphaTribes - 2 * (alphaTribes - 1);
    }
    
    self.localFeed.view.alpha = 1 - position * 2;
    self.tribeFeed.view.alpha = alphaTribes;
    self.profilFeed.view.alpha = position * 2 -1;
    
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

- (void)userInteractionFeedEnable:(BOOL)value{
    
    if (value == false && _profileView.profileHidden == false) {
        [self showHideProfile];
    }
    
    self.localFeed.view.userInteractionEnabled = value;
    self.tribeFeed.view.userInteractionEnabled = value;
    self.profilFeed.view.userInteractionEnabled = value;
    
}

- (void)showHideProfile{
    
    [_profileView hideComponents:_profileView.profileHidden];
    
    if (_profileView.profileHidden) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:self.appDelegate.oldScreenName];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Profile User View"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    }
    
}

- (void)removeAfterlogOut{
    NSLog(@"ActivitiesFeedViewController removeAfterlogOut");
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
    
}

#pragma mark - NSNotificationCenter

- (void)reloadActivity{
    NSLog(@"All reload");
    [self.localFeed reload];
    [self.profilFeed reload];
}

- (void)reloadLocal{
    NSLog(@"reloadLocal");
    [self.localFeed reload];
}

- (void)reloadProfile{
    NSLog(@"reloadProfile");
    [self.profilFeed reload];
}

#pragma mark - UIProfileView

- (void)showSettings:(id)sender{
    UserSettingsViewController *us = [[UserSettingsViewController alloc] init];
    [self presentViewController:us animated:YES completion:nil];
}

-(void)takePic:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose an existing one",@"Take a picture", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self.user editUserProfilePicture:newImage Block:^(User *user, NSError *error) {
        if (!error) {
            self.profileView.profileImage.image = newImage;
            [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
            appDelegate.user = nil;
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }];
    
}

@end
