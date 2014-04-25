//
//  TutorialViewController.m
//  CANU
//
//  Created by Vivien Cormier on 20/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "TutorialViewController.h"

#import "AppDelegate.h"
#import "UICanuNavigationController.h"
#import "TutorialPopUp.h"

@interface TutorialViewController () <TutorialPopUpDelegate>

@property (strong, nonatomic) UIView *backgroundOpacity;
@property (strong, nonatomic) UIImageView *arrowAnimate;
@property (strong, nonatomic) UIImageView *circle;
@property (strong, nonatomic) TutorialPopUp *tutorialPopUp;
@property (nonatomic) float limitHiddenArrow;
@property (nonatomic) TutorialStep stepTutorial;

@end

@implementation TutorialViewController

#pragma mark - Lifecycle

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.limitHiddenArrow = 0.24;
    
    self.backgroundOpacity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundOpacity.backgroundColor = UIColorFromRGB(0x2b4b58);
    self.backgroundOpacity.alpha = 0.5;
    [self.view addSubview:_backgroundOpacity];
    
    self.stepTutorial = TutorialStepTribes;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.canuViewController blockForStep:TutorialStepTribes];
    appDelegate.canuViewController.userInteractionEnabled = NO;
    
    self.tutorialPopUp = [[TutorialPopUp alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 185, 280, 110)];
    self.tutorialPopUp.delegate = self;
    [self.view addSubview:_tutorialPopUp];
    
    self.arrowAnimate = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 14, 39)];
    self.arrowAnimate.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"T_arraw_animation-1"],
                                         [UIImage imageNamed:@"T_arraw_animation-2"],
                                         [UIImage imageNamed:@"T_arraw_animation-3"],
                                         [UIImage imageNamed:@"T_arraw_animation-4"],
                                         [UIImage imageNamed:@"T_arraw_animation-5"],
                                         [UIImage imageNamed:@"T_arraw_animation-6"],nil];
    self.arrowAnimate.animationDuration = 1.0f;
    self.arrowAnimate.animationRepeatCount = 0;
    [self.arrowAnimate startAnimating];
    self.arrowAnimate.alpha = 0;
    [self.view addSubview:_arrowAnimate];
    
    self.circle = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 41, 20, 20)];
    self.circle.image = [UIImage imageNamed:@"T_goal"];
    self.circle.hidden = YES;
    [self.view addSubview:_circle];
    
    CABasicAnimation* opacityScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    opacityScale.fromValue = [NSNumber numberWithDouble:1];
    opacityScale.toValue = [NSNumber numberWithDouble:0.5];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:0.3];
    opacityAnim.toValue = [NSNumber numberWithFloat:1];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:opacityAnim,opacityScale, nil];
    animGroup.duration = 1;
    animGroup.autoreverses = YES;
    animGroup.repeatCount = HUGE_VALF;
    animGroup.delegate = self;
    [self.circle.layer addAnimation:animGroup forKey:nil];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)forceDealloc{
    [self.circle.layer removeAllAnimations];
}

- (void)dealloc
{
    NSLog(@"Dealloc");
}

#pragma mark - Private

- (void)changeToStepLocal{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.canuViewController.userInteractionEnabled = NO;
    [appDelegate.canuViewController blockForStep:TutorialStepLocal];
    [self.tutorialPopUp popUpGoToPosition:TutorialStepLocal];
    self.stepTutorial = TutorialStepLocal;
    [appDelegate.canuViewController changePage:0];
    self.arrowAnimate.alpha = 0;
    self.arrowAnimate.transform = CGAffineTransformMakeRotation(0);
    self.circle.hidden = YES;
}

- (void)changeToStepProfile{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.canuViewController.userInteractionEnabled = NO;
    [appDelegate.canuViewController blockForStep:TutorialStepProfile];
    [self.tutorialPopUp popUpGoToPosition:TutorialStepProfile];
    self.stepTutorial = TutorialStepProfile;
    [appDelegate.canuViewController changePage:1];
    self.arrowAnimate.alpha = 0;
    self.arrowAnimate.transform = CGAffineTransformMakeRotation(0);
    self.circle.hidden = YES;
}

#pragma mark - Public

- (void)positionNavBox:(float)position{
    
    if (_stepTutorial == TutorialStepTribes) {
        
        if (position < 0.3) {
            self.arrowAnimate.alpha = 0;
        } else {
            self.arrowAnimate.alpha = 1;
        }
        
        if (position == 0) {
            [NSThread detachNewThreadSelector:@selector(changeToStepLocal) toTarget:self withObject:nil];
        }
    } else if (_stepTutorial == TutorialStepLocal) {
        
        if (position > _limitHiddenArrow) {
            self.arrowAnimate.alpha = 0;
        } else {
            self.arrowAnimate.alpha = 1;
        }
        
        if (position == 1) {
            [NSThread detachNewThreadSelector:@selector(changeToStepProfile) toTarget:self withObject:nil];
        }
    }
    
}

- (void)tutorialStopMiddelLocalStep{
    
    self.limitHiddenArrow = 0.72f;
    
    self.arrowAnimate.transform = CGAffineTransformMakeRotation(0);
    self.arrowAnimate.frame = CGRectMake(210, self.view.frame.size.height - 50, 14, 39);
    self.arrowAnimate.transform = CGAffineTransformMakeRotation( M_PI / 2);
    [UIView animateWithDuration:0.4 animations:^{
        self.arrowAnimate.alpha = 1;
    }];
    
}

#pragma mark - TutorialPopUpDelegate

- (void)nextStep{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.canuViewController.userInteractionEnabled = YES;
    
    if (_stepTutorial == TutorialStepTribes) {
        self.arrowAnimate.frame = CGRectMake(100, self.view.frame.size.height - 50, 14, 39);
        self.arrowAnimate.transform = CGAffineTransformMakeRotation(- M_PI / 2);
        self.circle.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.arrowAnimate.alpha = 1;
        }];
    } else if (_stepTutorial == TutorialStepLocal) {
        self.arrowAnimate.frame = CGRectMake(85, self.view.frame.size.height - 50, 14, 39);
        self.arrowAnimate.transform = CGAffineTransformMakeRotation( M_PI / 2);
        self.circle.frame = CGRectMake(280, self.view.frame.size.height - 41, 20, 20);
        self.circle.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.arrowAnimate.alpha = 1;
        }];
    } else if (_stepTutorial == TutorialStepProfile) {
        self.arrowAnimate.frame = CGRectMake(280, self.view.frame.size.height - 110, 14, 39);
        [UIView animateWithDuration:0.4 animations:^{
            self.arrowAnimate.alpha = 1;
        }];
    }
    
}

@end
