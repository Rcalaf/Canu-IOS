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
    AreaTribes = 110,
    AreaLocal = 280,
} AreaPosition;

static int const CANUSizeTransition = 70;

@interface AnimationCreateActivity ()

@property (nonatomic) BOOL noChoice;
@property (nonatomic) int heightScreen;
@property (nonatomic) int middlePosition;
@property (strong, nonatomic) UIView *backgroundOpacity;
@property (strong, nonatomic) UIView *backgroundOpacityFinal;
@property (strong, nonatomic) UIView *wrapperLocal;
@property (strong, nonatomic) UIView *wrapperTribes;
@property (strong, nonatomic) UIImageView *cloud;
@property (strong, nonatomic) UIImageView *cloud2;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *titleLocal;
@property (strong, nonatomic) UILabel *titleTribe;

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
        self.noChoice = YES;
        
        self.heightScreen = [[UIScreen mainScreen] bounds].size.height;
        
        self.middlePosition = (_heightScreen - 300)/2;
        
        self.backgroundOpacity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, _heightScreen)];
        self.backgroundOpacity.backgroundColor = backgroundColorView;
        [self addSubview:_backgroundOpacity];
        
        self.cloud = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 852)];
        self.cloud.image = [UIImage imageNamed:@"AnimationCreateActivity_cloud_2"];
        self.cloud.alpha = 0.5;
        [self.backgroundOpacity addSubview:_cloud];
        
        self.cloud2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 852)];
        self.cloud2.image = [UIImage imageNamed:@"AnimationCreateActivity_cloud"];
        self.cloud2.alpha = 0.5;
        [self.backgroundOpacity addSubview:_cloud2];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, - 50, 320, 50)];
        self.title.textColor = UIColorFromRGB(0x84d0d4);
        self.title.numberOfLines = 4;
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        self.title.text = @"You want to create";
        self.title.font = [UIFont fontWithName:@"Lato-Bold" size:20];
        [self.backgroundOpacity addSubview:_title];
        
        self.wrapperTribes = [[UIView alloc]initWithFrame:CGRectMake(10, _heightScreen, 300, 300)];
        [self addSubview:_wrapperTribes];
        
        UIImageView *imageTribes = [[UIImageView alloc]initWithFrame:CGRectMake(50, 25, 200, 200)];
        imageTribes.image = [UIImage imageNamed:@"AnimationCreateActivity_tribes"];
        [self.wrapperTribes addSubview:imageTribes];
        
        self.wrapperLocal = [[UIView alloc]initWithFrame:CGRectMake(10, _heightScreen, 300, 300)];
        [self addSubview:_wrapperLocal];
        
        UIImageView *imageLocal = [[UIImageView alloc]initWithFrame:CGRectMake(50, 25, 200, 200)];
        imageLocal.image = [UIImage imageNamed:@"AnimationCreateActivity_local"];
        [self.wrapperLocal addSubview:imageLocal];
        
        self.titleTribe = [[UILabel alloc]initWithFrame:CGRectMake(0, _heightScreen - 100, 320, 50)];
        self.titleTribe.textColor = UIColorFromRGB(0x84d0d4);
        self.titleTribe.textAlignment = NSTextAlignmentCenter;
        self.titleTribe.backgroundColor = [UIColor clearColor];
        self.titleTribe.text = @"Tribe Activity";
        self.titleTribe.font = [UIFont fontWithName:@"Lato-Bold" size:20];
        [self.backgroundOpacity addSubview:_titleTribe];
        
        self.titleLocal = [[UILabel alloc]initWithFrame:CGRectMake(0, _heightScreen - 100, 320, 50)];
        self.titleLocal.textColor = UIColorFromRGB(0x84d0d4);
        self.titleLocal.textAlignment = NSTextAlignmentCenter;
        self.titleLocal.backgroundColor = [UIColor clearColor];
        self.titleLocal.text = @"Local Activity";
        self.titleLocal.font = [UIFont fontWithName:@"Lato-Bold" size:20];
        [self.backgroundOpacity addSubview:_titleLocal];
        
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
    
    self.cloud.frame = CGRectMake(0, position - 480, 320, 852);
    self.cloud.alpha = [self opacityForWrapperLocalWithPosition:position];
    
    self.cloud2.frame = CGRectMake(0, position /2 - 280, 320, 852);
    self.cloud2.alpha = [self opacityForWrapperLocalWithPosition:position];
    
    self.title.frame = CGRectMake(0, [self positionTitleWithPosition:position], 320, 50);
    
    self.wrapperTribes.frame = CGRectMake(10, [self positionYForWrapperTribesWithPosition:position], 300, 300);
    self.wrapperTribes.alpha = [self opacityForWrapperTribesWithPosition:position];
    
    self.wrapperLocal.frame = CGRectMake(10, [self positionYForWrapperLocalWithPosition:position], 300, 300);
    self.wrapperLocal.alpha = [self opacityForWrapperLocalWithPosition:position];
    
    self.titleTribe.frame = CGRectMake(0, [self positionYForTitleTribesWithPosition:position], 320, 50);
    
    self.titleLocal.frame = CGRectMake(0, [self positionYForTitleLocalWithPosition:position], 320, 50);
    
}

/**
 *  Stop the view and prepare the transition for New Activity Controller
 *
 *  @param canuCreateActivity
 */
- (void)stopViewFor:(CANUCreateActivity)canuCreateActivity{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    UINavigationController *navigation = (UINavigationController *)appDelegate.canuViewController;
    
    CreateEditActivityViewController *createView = [[CreateEditActivityViewController alloc]initForCreate:canuCreateActivity];
    
    if (_noChoice) {
        
        int position = 0;
        
        switch (canuCreateActivity) {
            case CANUCreateActivityNone:
                position = 100;
                break;
            case CANUCreateActivityLocal:
                position = 350;
                break;
            case CANUCreateActivityTribes:
                position = 195;
                break;
            default:
                break;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [self animateWithPosition:position];
        } completion:^(BOOL finished) {
            
            self.backgroundOpacityFinal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, _heightScreen)];
            self.backgroundOpacityFinal.backgroundColor = backgroundColorView;
            self.backgroundOpacityFinal.alpha = 0;
            [self addSubview:_backgroundOpacityFinal];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.backgroundOpacityFinal.alpha = 1;
            } completion:^(BOOL finished) {
                if (canuCreateActivity != CANUCreateActivityNone) {
                    [navigation presentViewController:createView animated:NO completion:^{
                        [self.backgroundOpacityFinal removeFromSuperview];
                        self.active = NO;
                        self.frame = CGRectMake(0, 0, 0, 0);
                    }];
                } else {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.backgroundOpacityFinal.alpha = 1;
                    } completion:^(BOOL finished) {
                        [self.backgroundOpacityFinal removeFromSuperview];
                        self.active = NO;
                        self.frame = CGRectMake(0, 0, 0, 0);
                    }];
                }
                
            }];
        }];
        
    } else {
        
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
    
    if (position > AreaTribes - CANUSizeTransition && position < AreaTribes) {
        opacity = (position - ( AreaTribes - CANUSizeTransition )) / CANUSizeTransition;
    }
    
    if (position >= AreaTribes) {
        opacity = 1;
    }
    
    return opacity;
    
}

- (int)positionTitleWithPosition:(float)position{
    
    float value = 0;
    
    if (position > AreaTribes - CANUSizeTransition && position < AreaTribes) {
        value = (position - ( AreaTribes - CANUSizeTransition )) / CANUSizeTransition;
    }
    
    if (position >= AreaTribes) {
        value = 1;
    }
    
    int finalPosition = value * ((_heightScreen - 480)/2 + 40) - 50 * (1 - value);
    
    return finalPosition;
    
}

- (int)positionYForWrapperTribesWithPosition:(float)position{
    
    self.noChoice = YES;
    
    int positionY = _heightScreen;
    
    if (position > AreaTribes - (CANUSizeTransition - 20) && position < AreaTribes) {
        
        float value = (position - ( AreaTribes - (CANUSizeTransition - 20) )) / (CANUSizeTransition - 20);
        
        positionY = _heightScreen * (1 - value) + value * _middlePosition;
        
    } else if (position >= AreaTribes && position < AreaLocal - ( CANUSizeTransition / 2)) {
        positionY = _middlePosition;
        self.noChoice = NO;
    } else if (position >= AreaLocal - ( CANUSizeTransition / 2) && position < AreaLocal + ( CANUSizeTransition / 2)) {
        
        float value = (position - ( AreaLocal - ( CANUSizeTransition / 2) )) / CANUSizeTransition;
        
        positionY = _heightScreen * value + (1 - value) * _middlePosition;
        
    } else if (position >= AreaLocal + ( CANUSizeTransition / 2)) {
        positionY = _heightScreen;
        self.noChoice = NO;
    }
    
    return positionY;
    
}

- (float)opacityForWrapperTribesWithPosition:(float)position{
    
    float opacity = 0;
    
    if (position > AreaTribes - (CANUSizeTransition - 20) && position < AreaTribes) {
        
        opacity = (position - ( AreaTribes - (CANUSizeTransition - 20) )) / (CANUSizeTransition - 20);
        
    } else if (position >= AreaTribes && position < AreaLocal - ( CANUSizeTransition / 2)) {
        opacity = 1;
    } else if (position >= AreaLocal - ( CANUSizeTransition / 2) && position < AreaLocal + ( CANUSizeTransition / 2)) {
        
        opacity = 1 - ((position - ( AreaLocal - ( CANUSizeTransition / 2) )) / CANUSizeTransition);
        
    } else if (position >= AreaLocal + ( CANUSizeTransition / 2)) {
        opacity = 0;
    }
    
    return opacity;
    
}

- (int)positionYForWrapperLocalWithPosition:(float)position{
    
    self.noChoice = YES;
    
    int positionY = - _heightScreen;
    
    if (position >= AreaLocal - ( CANUSizeTransition / 2) && position < AreaLocal + ( CANUSizeTransition / 2)) {
        
        float value = (position - ( AreaLocal - ( CANUSizeTransition / 2) )) / CANUSizeTransition;
        
        positionY = - _heightScreen * (1 - value) + value * _middlePosition;
        
    } else if (position >= AreaLocal + ( CANUSizeTransition / 2)) {
        positionY = _middlePosition;
        self.noChoice = NO;
    }
 
    return positionY;
    
}

- (float)opacityForWrapperLocalWithPosition:(float)position{
    
    float opacity = 0;
    
    if (position >= AreaLocal - ( CANUSizeTransition / 2) && position < AreaLocal + ( CANUSizeTransition / 2)) {
        
        opacity = (position - ( AreaLocal - ( CANUSizeTransition / 2) )) / CANUSizeTransition;
        
    } else if (position >= AreaLocal + ( CANUSizeTransition / 2)) {
        opacity = 1;
    }
    
    return opacity;
    
}

- (int)positionYForTitleTribesWithPosition:(float)position{
    
    int positionY = _heightScreen + 100;
    
    if (position > AreaTribes - (CANUSizeTransition - 20) && position < AreaTribes) {
        
        float value = (position - ( AreaTribes - (CANUSizeTransition - 20) )) / (CANUSizeTransition - 20);
        
        positionY = (_heightScreen + 100) * (1 - value) + value * (_heightScreen - 100);
        
    } else if (position >= AreaTribes && position < AreaLocal - ( CANUSizeTransition / 2)) {
        positionY = _heightScreen - 100;
    } else if (position >= AreaLocal - ( CANUSizeTransition / 2) && position < AreaLocal + ( CANUSizeTransition / 2)) {
        
        float value = (position - ( AreaLocal - ( CANUSizeTransition / 2) )) / CANUSizeTransition;
        
        positionY = (_heightScreen + 100) * value + (1 - value) * (_heightScreen - 100);
        
    } else if (position >= AreaLocal + ( CANUSizeTransition / 2)) {
        positionY = _heightScreen + 100;
    }
    
    return positionY;
    
}

- (int)positionYForTitleLocalWithPosition:(float)position{
    
    int positionY = _heightScreen + 50;
    
    if (position >= AreaLocal && position < AreaLocal + CANUSizeTransition) {
        
        float value = (position - AreaLocal) / CANUSizeTransition;
        
        positionY = (_heightScreen + 50) * (1 - value) + value * (_heightScreen - 100);
        
    } else if (position >= AreaLocal + CANUSizeTransition) {
        positionY = (_heightScreen - 100);
    }
    
    return positionY;
    
}

@end
