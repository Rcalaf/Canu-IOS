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

@interface ActivitiesFeedViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic) UIView *wrapper;
@property (nonatomic) User *user;
@property (nonatomic) ActivityScrollViewController *localFeed;
@property (nonatomic) ActivityScrollViewController *profilFeed;
@property (nonatomic) UIProfileView *profileView;
@property (nonatomic) AppDelegate *appDelegate;

@end

@implementation ActivitiesFeedViewController 

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = backgroundColorView;
    NSLog(@"Init ActivitiesFeedViewController");
    self.navigationController.navigationBarHidden = YES;
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = _appDelegate.user;
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, self.view.frame.size.height)];
    [self.view addSubview:_wrapper];
    
    self.profileView = [[UIProfileView alloc] initWithUser:self.user andFrame:CGRectMake(0, self.view.frame.size.height, 320, 119)];
    [self.view addSubview:_profileView.mask];
    [self.view addSubview:_profileView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings:)];
    [_profileView.settingsButton addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic:)];
    [_profileView.profileImage addGestureRecognizer:tapRecognizer];
    
    self.localFeed = [[ActivityScrollViewController alloc] initForUserProfile:NO andUser:_user andFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self addChildViewController:_localFeed];
    [self.wrapper addSubview:_localFeed.view];
    
    self.profilFeed = [[ActivityScrollViewController alloc] initForUserProfile:YES andUser:_user andFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    [self addChildViewController:_profilFeed];
    [self.wrapper addSubview:_profilFeed.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadActivity) name:@"reloadActivity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLocal) name:@"reloadLocal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile) name:@"reloadProfile" object:nil];
    
}

- (void)changePosition:(float)position{
    self.wrapper.frame = CGRectMake( - position * 320, 0, 640, self.wrapper.frame.size.height);
    self.localFeed.view.alpha = 1 - position;
    self.profilFeed.view.alpha = position;
    
    if (position == 0) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Local Feed"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        self.appDelegate.oldScreenName = @"Local Feed";
    }else if (position == 0.5){
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Tribes Feed"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        self.appDelegate.oldScreenName = @"Tribes Feed";
    }else if (position == 1){
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
    
    self.wrapper.userInteractionEnabled = value;
}

- (void)reloadActivity{
    
    [self.localFeed reload];
    [self.profilFeed reload];
    
}

- (void)reloadLocal{
    
    [self.localFeed reload];
    
}

- (void)reloadProfile{
    
    [self.profilFeed reload];
    
}

- (void)showHideProfile{
    
    [_profileView hideComponents:_profileView.profileHidden];
    
    if (_profileView.profileHidden) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:self.appDelegate.oldScreenName];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    }else{
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Profile User View"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    }
    
}

#pragma Mark - Profil View function

- (void)showSettings:(id)sender
{
    UserSettingsViewController *us = [[UserSettingsViewController alloc] init];
    [self presentViewController:us animated:YES completion:nil];
}

-(void)takePic:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose an existing one",@"Take a picture", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Local Feed"];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    self.appDelegate.oldScreenName = @"Local Feed";
    
}

- (void)viewDidDisappear:(BOOL)animated{
    self.profilFeed.view.frame = CGRectMake(320, 0, self.profilFeed.view.frame.size.width, self.profilFeed.view.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated{
    self.profilFeed.view.frame = CGRectMake(320, 0, self.profilFeed.view.frame.size.width, self.profilFeed.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated{
    self.profilFeed.view.frame = CGRectMake(320, 0, self.profilFeed.view.frame.size.width, self.profilFeed.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dealloc{
    
    NSLog(@"dealloc ActivitiesFeedViewController");
    
}

@end
