//
//  AnimationCreateActivity.m
//  CANU
//
//  Created by Vivien Cormier on 05/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "AnimationCreateActivity.h"

#import "AppDelegate.h"

#import "CreateEditActivityViewController.h"

#import "ActivitiesFeedViewController.h"

#import "UserManager.h"
#import "UIImageView+AFNetworking.h"

#import "UICanuNavigationController.h"

typedef enum {
    AreaCreate = 150
} AreaPosition;

@interface AnimationCreateActivity ()

@property (nonatomic) int heightScreen;
@property (strong, nonatomic) UIView *backgroundOpacity;
@property (strong, nonatomic) UIView *backgroundOpacityFinal;
@property (strong, nonatomic) UIView *wrapperActivity;
@property (strong, nonatomic) UILabel *text;

@end

@implementation AnimationCreateActivity

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 0, 0);
        self.clipsToBounds = YES;
        self.active = NO;
        
        self.heightScreen = [[UIScreen mainScreen] bounds].size.height;
        
        self.backgroundOpacity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, _heightScreen)];
        self.backgroundOpacity.backgroundColor = backgroundColorView;
        [self addSubview:_backgroundOpacity];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 300, 40)];
        self.text.textColor = UIColorFromRGB(0x2b4b58);
        self.text.text = NSLocalizedString(@"Release for create a activity", nil);
        self.text.textAlignment = NSTextAlignmentCenter;
        self.text.backgroundColor = [UIColor clearColor];
        self.text.font = [UIFont fontWithName:@"Lato-Bold" size:18];
        self.text.alpha = 0;
        [self addSubview:_text];
        
        self.wrapperActivity = [[UIView alloc]initWithFrame:CGRectMake(10, _heightScreen + 10, 300, 100)];
        [self addSubview:_wrapperActivity];
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 105)];
        background.image = [UIImage imageNamed:@"F_activity_background"];
        [self.wrapperActivity addSubview:background];
        
        // Profile picture
        UIImageView *profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
        [profilePicture setImageWithURL:[[UserManager sharedUserManager] currentUser].profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        [self.wrapperActivity addSubview:profilePicture];
        
        // Stroke profile picture
        UIImageView *strokePicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        strokePicture.image = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
        [profilePicture addSubview:strokePicture];
        
        // Name
        UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(55, 18, 200, 17)];
        username.font = [UIFont fontWithName:@"Lato-Bold" size:14];
        username.text = [[UserManager sharedUserManager] currentUser].firstName;
        username.textColor = UIColorFromRGB(0x2b4b58);
        [self.wrapperActivity addSubview:username];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 57, 280, 25)];
        title.font = [UIFont fontWithName:@"Lato-Bold" size:23];
        title.textColor = UIColorFromRGB(0x2b4b58);
        title.text = NSLocalizedString(@"What do you want to do?", nil);
        title.alpha = 0.3;
        [self.wrapperActivity addSubview:title];
        
    }
    return self;
}

#pragma mark - Public

/**
 *  Active the view and the animation
 */
- (void)startView{
    self.active = YES;
    self.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
}

/**
 *  Animate the view with value
 *
 *  @param position
 */
- (void)animateWithPosition:(float)position{
    
    if (!_active) {
        return;
    }
    
    self.backgroundOpacity.alpha = [self opacityWithPosition:position];
    
    self.wrapperActivity.frame = CGRectMake(_wrapperActivity.frame.origin.x, [self activityPositionWithPosition:position], _wrapperActivity.frame.size.width, _wrapperActivity.frame.size.height);
    
    self.text.alpha = [self opacityTextWithPosition:position];
    
}

/**
 *  Stop the view and prepare the transition for New Activity Controller
 *
 *  @param canuCreateActivity
 */
- (void)stopViewFor:(CANUCreateActivity)canuCreateActivity{
    
    if (canuCreateActivity == CANUCreateActivityNone) {
        
        [UIView animateWithDuration:0.2 animations:^{
            [self animateWithPosition:64];
        } completion:^(BOOL finished) {
            
            [self.backgroundOpacityFinal removeFromSuperview];
            self.active = NO;
            self.frame = CGRectMake(0, 0, 0, 0);
            
        }];
        
    } else {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        UICanuNavigationController *navigation = appDelegate.canuViewController;
        
        CreateEditActivityViewController *createView = [[CreateEditActivityViewController alloc]initForCreate];
        
        [appDelegate.feedViewController addChildViewController:createView];
        [appDelegate.feedViewController.view addSubview:createView.view];
        
        self.active = NO;
        self.frame = CGRectMake(0, 0, 0, 0);
        
        [UIView animateWithDuration:0.4 animations:^{
            navigation.control.alpha = 0;
        } completion:^(BOOL finished) {
            navigation.control.hidden = YES;
        }];

    }
    
}

#pragma mark - Private

- (float)opacityWithPosition:(float)position{
    
    float opacity = 0;
    
    if (position > AreaCreate - 70 && position < AreaCreate) {
        opacity = (position - ( AreaCreate - 70 )) / 70;
    }
    
    if (position >= AreaCreate) {
        opacity = 1;
    }
    
    return opacity;
    
}

- (float)activityPositionWithPosition:(float)position{
    
    float value = 0;
    
    if (position > 64 && position < AreaCreate) {
        value = (position - 64) / (AreaCreate - 64);
    }
    
    if (position >= AreaCreate) {
        value = 1;
    }
    
    float finalPosition = (_heightScreen + 10) - (AreaCreate - 64) * value;
    
    return finalPosition;
    
}

- (float)opacityTextWithPosition:(float)position{
    
    float opacity = 0;
    
    if (position > AreaCreate && position < AreaCreate + 5) {
        opacity = (position - AreaCreate) / 5;
    }
    
    if (position >= AreaCreate + 5) {
        opacity = 1;
    }
    
    return opacity;
    
}

@end
