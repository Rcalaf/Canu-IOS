//
//  UICanuNavigationController.m
//  CANU
//
//  Created by Roger Calaf on 30/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "UICanuNavigationController.h"
#import "ActivitiesFeedViewController.h"	
#import "Activity.h"

#define kNavboxAlpha ((float) .7)
#define KNavboxPosition
#define KNavboxSize ((CGRect) 2.0,418.0 + KIphone5Margin,64.0,64.0)

typedef enum {
    NavBoxLocal = 2,
    NavBoxTribes = 129,
    NavBoxProfil = 255,
} NavBoxPosition;

typedef enum {
    AreaCreate = 150
} AreaPosition;

@interface UICanuNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL unknowDirection;
@property (nonatomic) BOOL verticalDirection;
@property (nonatomic) BOOL panIsDetect;
@property (nonatomic) float areaSize;
@property (nonatomic) float velocity;
@property (nonatomic) CGPoint gapTouchControl;
@property (nonatomic) CGPoint oldPositionControl;
@property (nonatomic) NavBoxPosition naveboxPosition;
@property (nonatomic) TutorialStep stepTutorial;
    
@end

@implementation UICanuNavigationController

- (id)initWithActivityFeed:(ActivitiesFeedViewController *)activityFeed
{
    self = [super init];
    if (self) {
        
        self.unknowDirection = YES;
        
        self.panIsDetect = NO;
        
        self.userInteractionEnabled = YES;
        
        self.activityFeed = activityFeed;
        
        self.areaSize = (320 - 4.0f) / 3.0f;
        
        self.naveboxPosition = NavBoxTribes;
        
        self.navigationBarHidden = YES;
        self.control = [[UIView alloc] initWithFrame:CGRectMake(NavBoxTribes, 415.0 + KIphone5Margin, 64.0, 64.0)];
        self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBox_Tribes"]];
        [self.view addSubview:self.control];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeControl:)];
    panGesture.delegate = self;
    
    UITapGestureRecognizer *bounceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bounce:)];
    
    [self.control addGestureRecognizer:bounceGesture];
    [self.control addGestureRecognizer:panGesture];
    
}

- (void)bounce:(UITapGestureRecognizer *)gesture{
    
    if (!_panIsDetect) {
        
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = self.control.frame;
            frame.origin.y = 400.0f + KIphone5Margin;
            self.control.frame = frame;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:.2 animations:^{
                CGRect frame = self.control.frame;
                frame.origin.y = 415.0f + KIphone5Margin;
                self.control.frame = frame;
            }completion:^(BOOL finished) {
            }];
        }];
        
    }
    
}

- (void)swipeControl:(UIPanGestureRecognizer *)recognizer{
    
    if (!_userInteractionEnabled) {
        return;
    }
    
    CGPoint location = [recognizer locationInView:self.view];
    
    // Start Mouvement
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        self.oldPositionControl = location;
        self.unknowDirection = YES;
        self.panIsDetect = YES;
        self.gapTouchControl = CGPointMake(location.x - self.control.frame.origin.x, location.y - self.control.frame.origin.y);
        
    }
    
    // Mouvement
    
    if ([recognizer state] == UIGestureRecognizerStateChanged) {
        
        if (_unknowDirection) {
            
            float gapHorizontal = fabsf(_oldPositionControl.x - location.x);
            float gapVertical = fabsf(_oldPositionControl.y - location.y);
            
            if (gapHorizontal < gapVertical) {
                self.verticalDirection = YES;
            } else {
                self.verticalDirection = NO;
            }
            
            if (self.stepTutorial == TutorialStepTribes || self.stepTutorial == TutorialStepLocal) {
                self.verticalDirection = NO;
            }
            
            if (self.stepTutorial == TutorialStepProfile) {
                self.verticalDirection = YES;
            }
            
            self.unknowDirection = NO;
            
        }
        
        if (_verticalDirection) {
            
            self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBox_Create"]];
            
            self.control.frame = CGRectMake(_naveboxPosition, location.y - _gapTouchControl.y, self.control.frame.size.width, self.control.frame.size.height);
            
            if (self.view.frame.size.height - self.control.frame.origin.y > AreaCreate - 70 && !self.activityFeed.animationCreateActivity.active) {
                
                [self.activityFeed.animationCreateActivity startView];
                
                if (self.stepTutorial == TutorialStepProfile) {
                    self.activityFeed.animationCreateActivity.activeTutorial = YES;
                } else {
                    self.activityFeed.animationCreateActivity.activeTutorial = NO;
                }
                
            }
            
            [self.activityFeed.animationCreateActivity animateWithPosition:self.view.frame.size.height - self.control.frame.origin.y];
            
        }else{
            
            self.control.frame = CGRectMake(location.x - _gapTouchControl.x, 415.0 + KIphone5Margin, self.control.frame.size.width, self.control.frame.size.height);
            
            float value = ((location.x - _gapTouchControl.x) - NavBoxLocal) / (NavBoxProfil - NavBoxLocal);
            
            if (value < 0) {
                value = 0;
            }else if (value > 1){
                value = 1;
            }
            
            if (self.stepTutorial == TutorialStepTribes && value > 0.5f) {
                value = 0.5f;
                self.control.frame = CGRectMake(NavBoxTribes, 415.0 + KIphone5Margin, self.control.frame.size.width, self.control.frame.size.height);
                self.naveboxPosition = NavBoxTribes;
            }
            
            [self.activityFeed changePosition:value];
            [self.activityFeed changePositionForTutorial:value];
            
        }
        
    }
    
    // End Mouvement
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        
        self.velocity = [recognizer velocityInView:self.view].x;
        
        [self releaseNavBox];
        
        
    }
    
}

- (void)releaseNavBox{
    
    if (_verticalDirection) {
        
        float positionToBottom = self.view.frame.size.height - self.control.frame.origin.y;
        
        CANUCreateActivity canuCreateActivity;
        
        if (positionToBottom > AreaCreate) {
            canuCreateActivity = CANUCreateActivityAcitve;
            if (_stepTutorial == TutorialStepProfile) {
                self.stepTutorial = TutorialStepFinish;
                [self.activityFeed stopTutorial];
            }
        } else {
            canuCreateActivity = CANUCreateActivityNone;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.control.frame = CGRectMake(_naveboxPosition, 415.0f + KIphone5Margin,self.control.frame.size.width, self.control.frame.size.height);
        }completion:^(BOOL finished) {
            if (_naveboxPosition == NavBoxLocal) {
                self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_local"]];
            }else if (_naveboxPosition == NavBoxTribes){
                self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBox_Tribes"]];
            }else if (_naveboxPosition == NavBoxProfil){
                self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_me"]];
            }
        }];
        
        if (self.activityFeed.animationCreateActivity.active) {
            [self.activityFeed.animationCreateActivity stopViewFor:canuCreateActivity];
        }

    }else{
        
        float value = 0, duration = 0;
        
        if (fabs(_velocity) > 500) {
            
            duration = 0.2f;
            
            if (_velocity > 0) {
                
                if (_naveboxPosition == NavBoxLocal) {
                    if (self.control.frame.origin.x < NavBoxTribes + 30.f) {
                        _naveboxPosition = NavBoxTribes;
                        value = 0.5;
                    } else {
                        _naveboxPosition = NavBoxProfil;
                        value = 1;
                    }
                }else if (_naveboxPosition == NavBoxTribes) {
                    
                    if (self.stepTutorial == TutorialStepTribes) {
                        _naveboxPosition = NavBoxTribes;
                        value = 0.5;
                    } else {
                        _naveboxPosition = NavBoxProfil;
                        value = 1;
                    }
                }else{
                    _naveboxPosition = NavBoxProfil;
                    value = 1;
                }
                
            }else{
                if (_naveboxPosition == NavBoxProfil) {
                    if (self.control.frame.origin.x > NavBoxTribes - 30.f) {
                        _naveboxPosition = NavBoxTribes;
                        value = 0.5;
                    } else {
                        _naveboxPosition = NavBoxLocal;
                        value = 0;
                    }
                }else if (_naveboxPosition == NavBoxTribes) {
                    _naveboxPosition = NavBoxLocal;
                    value = 0;
                }else{
                    _naveboxPosition = NavBoxLocal;
                    value = 0;
                }
                
            }
            
        }else{
            
            duration = 0.3f;
            
            if (self.control.frame.origin.x + (64/2) >= -20 && self.control.frame.origin.x + (64/2) < NavBoxLocal + _areaSize) {
                value = 0;
                _naveboxPosition = NavBoxLocal;
            }else if (self.control.frame.origin.x + (64/2) >= NavBoxLocal + _areaSize && self.control.frame.origin.x + (64/2) <= NavBoxLocal + _areaSize + _areaSize){
                value = 0.5;
                _naveboxPosition = NavBoxTribes;
            }else if (self.control.frame.origin.x + (64/2) >= NavBoxLocal + _areaSize + _areaSize && self.control.frame.origin.x + (64/2) <= 340){
                value = 1;
                _naveboxPosition = NavBoxProfil;
            }
            
        }
        
        if (value == 0) {
            self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_local"]];
        }else if (value == 0.5){
            if (_stepTutorial == TutorialStepLocal) {
                [self.activityFeed tutorialStopMiddelLocalStep];
            }
            self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBox_Tribes"]];
        }else if (value == 1){
            self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_me"]];
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.control.frame = CGRectMake(_naveboxPosition, 415.0f + KIphone5Margin,self.control.frame.size.width, self.control.frame.size.height);
            [self.activityFeed changePosition:value];
        }completion:^(BOOL finished) {
            [self.activityFeed changePositionForTutorial:value];
        }];
        
    }
    
    self.panIsDetect = NO;
    
}

- (void)changePosition:(float)position{
    
    self.control.frame = CGRectMake(self.control.frame.origin.x, 415.0f + KIphone5Margin + position * 65,self.control.frame.size.width, self.control.frame.size.height);
    
}

- (void)changePage:(float)position{
    
    float navBoxPosition = NavBoxLocal;
    self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_local"]];
    
    if (position == 0.5) {
        navBoxPosition = NavBoxTribes;
        self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBox_Tribes"]];
    } else if (position == 1) {
        navBoxPosition = NavBoxProfil;
        self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_me"]];
    }
    
    self.naveboxPosition = navBoxPosition;
    
    self.control.frame = CGRectMake(navBoxPosition, self.control.frame.origin.y,self.control.frame.size.width, self.control.frame.size.height);
    
}

- (void)blockForStep:(TutorialStep)step{
    
    self.stepTutorial = step;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)dealloc{
    NSLog(@"dealloc UICanuNavigationController");
}

@end
