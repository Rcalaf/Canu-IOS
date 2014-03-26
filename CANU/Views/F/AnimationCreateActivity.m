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

typedef enum {
    AreaCreate = 110
} AreaPosition;

@interface AnimationCreateActivity ()

@property (nonatomic) int heightScreen;
@property (nonatomic) int middlePosition;
@property (strong, nonatomic) UIView *backgroundOpacity;
@property (strong, nonatomic) UIView *backgroundOpacityFinal;

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
        
        self.middlePosition = (_heightScreen - 300)/2;
        
        self.backgroundOpacity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, _heightScreen)];
        self.backgroundOpacity.backgroundColor = backgroundColorView;
        [self addSubview:_backgroundOpacity];
        
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
        UINavigationController *navigation = (UINavigationController *)appDelegate.canuViewController;
        
        CreateEditActivityViewController *createView = [[CreateEditActivityViewController alloc]initForCreate];
        
        self.backgroundOpacityFinal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, _heightScreen)];
        self.backgroundOpacityFinal.backgroundColor = backgroundColorView;
        self.backgroundOpacityFinal.alpha = 0;
        [self addSubview:_backgroundOpacityFinal];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundOpacityFinal = 0;
        } completion:^(BOOL finished) {
            if (canuCreateActivity != CANUCreateActivityNone) {
                [navigation presentViewController:createView animated:NO completion:^{
                    [self.backgroundOpacityFinal removeFromSuperview];
                    self.active = NO;
                    self.frame = CGRectMake(0, 0, 0, 0);
                }];
            }
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
@end
