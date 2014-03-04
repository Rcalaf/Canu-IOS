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
#import "NewActivityViewController.h"
#import "Activity.h"

#define kNavboxAlpha ((float) .7)
#define KNavboxPosition
#define KNavboxSize ((CGRect) 2.0,418.0 + KIphone5Margin,63.0,63.0)

typedef enum {
    NavBoxLocal = 2,
    NavBoxTribes = 129,
    NavBoxProfil = 255,
} NavBoxPosition;

typedef enum {
    AreaTribes = 110,
    AreaLocal = 280,
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
    
@end

@implementation UICanuNavigationController

@synthesize control = _control;

- (id)initWithActivityFeed:(ActivitiesFeedViewController *)activityFeed
{
    self = [super init];
    if (self) {
        
        self.unknowDirection = YES;
        
        self.panIsDetect = NO;
        
        self.activityFeed = activityFeed;
        
        self.areaSize = (320 - 4.0f) / 3.0f;
        
        self.naveboxPosition = NavBoxLocal;
        
        self.navigationBarHidden = YES;
        self.control = [[UIView alloc] initWithFrame:CGRectMake(2.0, 415.0 + KIphone5Margin, 63.0, 63.0)];
        self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_local.png"]];
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
    
    [_control addGestureRecognizer:bounceGesture];
    [_control addGestureRecognizer:panGesture];
    
}

- (void)bounce:(UITapGestureRecognizer *)gesture{
    
    if (!_panIsDetect) {
        
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _control.frame;
            frame.origin.y = 400.0f + KIphone5Margin;
            _control.frame = frame;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:.2 animations:^{
                CGRect frame = _control.frame;
                frame.origin.y = 415.0f + KIphone5Margin;
                _control.frame = frame;
            }completion:^(BOOL finished) {
            }];
        }];
        
    }
    
}

- (void)swipeControl:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint location = [recognizer locationInView:self.view];
    
    // Start Mouvement
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        
        self.oldPositionControl = location;
        self.unknowDirection = YES;
        self.panIsDetect = YES;
        self.gapTouchControl = CGPointMake(location.x - _control.frame.origin.x, location.y - _control.frame.origin.y);
        
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
            
            self.unknowDirection = NO;
            
        }
        
        if (_verticalDirection) {
            _control.frame = CGRectMake(_naveboxPosition, location.y - _gapTouchControl.y, _control.frame.size.width, _control.frame.size.height);
            
            if (self.view.frame.size.height - _control.frame.origin.y > AreaTribes - 50 && !self.activityFeed.animationCreateActivity.active) {
                
                self.activityFeed.animationCreateActivity.localIsUnlock = [self.activityFeed localFeedIsUnlock];
                [self.activityFeed.animationCreateActivity startView];
                
            }
            
            [self.activityFeed.animationCreateActivity animateWithPosition:self.view.frame.size.height - _control.frame.origin.y];
            
        }else{
            
            float horizontalPosition = location.x;
            
            if (horizontalPosition < NavBoxLocal) {
                horizontalPosition = NavBoxLocal;
            }else if (horizontalPosition > NavBoxProfil){
                horizontalPosition = NavBoxProfil;
            }
            
            _control.frame = CGRectMake(location.x - _gapTouchControl.x, 415.0 + KIphone5Margin, _control.frame.size.width, _control.frame.size.height);
            
            float value = ((location.x - _gapTouchControl.x) - NavBoxLocal) / (NavBoxProfil - NavBoxLocal);
            
            if (value < 0) {
                value = 0;
            }else if (value > 1){
                value = 1;
            }
            
            [self.activityFeed changePosition:value];
            
        }
        
    }
    
    // End Mouvement
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        
        self.velocity = [recognizer velocityInView:self.view].x;
        
        [self performSelectorOnMainThread:@selector(releaseNavBox) withObject:self waitUntilDone:NO];
        
    }
    
}

- (void)releaseNavBox{
    
    if (_verticalDirection) {
        
        float positionToBottom = self.view.frame.size.height - _control.frame.origin.y;
        
        CANUCreateActivity canuCreateActivity;
        
        if (positionToBottom > AreaTribes && positionToBottom < AreaLocal) {
            canuCreateActivity = CANUCreateActivityTribes;
        } else if (positionToBottom > AreaTribes) {
            canuCreateActivity = CANUCreateActivityLocal;
        } else {
            canuCreateActivity = CANUCreateActivityNone;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            _control.frame = CGRectMake(_naveboxPosition, 415.0f + KIphone5Margin,_control.frame.size.width, _control.frame.size.height);
        }completion:^(BOOL finished) {
            
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
                    if (_control.frame.origin.x < NavBoxTribes + 30.f) {
                        _naveboxPosition = NavBoxTribes;
                        value = 0.5;
                    } else {
                        _naveboxPosition = NavBoxProfil;
                        value = 1;
                    }
                }else if (_naveboxPosition == NavBoxTribes) {
                    _naveboxPosition = NavBoxProfil;
                    value = 1;
                }else{
                    _naveboxPosition = NavBoxProfil;
                    value = 1;
                }
                
            }else{
                
                if (_naveboxPosition == NavBoxProfil) {
                    if (_control.frame.origin.x > NavBoxTribes - 30.f) {
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
            
            if (_control.frame.origin.x + (63/2) >= -20 && _control.frame.origin.x + (63/2) < NavBoxLocal + _areaSize) {
                value = 0;
                _naveboxPosition = NavBoxLocal;
            }else if (_control.frame.origin.x + (63/2) >= NavBoxLocal + _areaSize && _control.frame.origin.x + (63/2) <= NavBoxLocal + _areaSize + _areaSize){
                value = 0.5;
                _naveboxPosition = NavBoxTribes;
            }else if (_control.frame.origin.x + (63/2) >= NavBoxLocal + _areaSize + _areaSize && _control.frame.origin.x + (63/2) <= 340){
                value = 1;
                _naveboxPosition = NavBoxProfil;
            }
            
        }
        
        if (value == 0) {
            self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_local"]];
        }else if (value == 0.5){
            self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"NavBox_Tribes"]];
        }else if (value == 1){
            self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_me"]];
        }
        
        [UIView animateWithDuration:duration animations:^{
            _control.frame = CGRectMake(_naveboxPosition, 415.0f + KIphone5Margin,_control.frame.size.width, _control.frame.size.height);
            [self.activityFeed changePosition:value];
        }completion:^(BOOL finished) {
            
        }];
        
    }
    
    self.panIsDetect = NO;
    
}

- (void)changePosition:(float)position{
   
    _control.frame = CGRectMake(_control.frame.origin.x, 415.0f + KIphone5Margin + position * 65,_control.frame.size.width, _control.frame.size.height);
    
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
