//
//  AlertNotification.m
//  CANU
//
//  Created by Vivien Cormier on 15/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "AlertNotification.h"
#import "Activity.h"
#import "AppDelegate.h"
#import "PushRemote.h"

@interface AlertNotification ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *activityName;
@property (strong, nonatomic) UILabel *notificationText;
@property (strong, nonatomic) UIImageView *icone;
@property (strong, nonatomic) PushRemote *push;

@end

@implementation AlertNotification

- (id)initWithPush:(PushRemote *)push{
    
    CGRect frame = CGRectMake(0, -42, 320, 42);
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.enable = YES;
        
        self.push = push;
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 42)];
        background.image = [UIImage imageNamed:@"All_notification_background"];
        [self addSubview:background];
        
        self.activityName = [[UILabel alloc]initWithFrame:CGRectMake(40, 9, 240, 12)];
        self.activityName.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        self.activityName.textColor = UIColorFromRGB(0x2b4b58);
        if (push.pushRemoteAction == PushRemoteActionChat) {
            self.activityName.text = NSLocalizedString(@"New message", nil);
        } else if (push.pushRemoteAction == PushRemoteActionEditActivity) {
            self.activityName.text = NSLocalizedString(@"Activity updated", nil);
        } else if (push.pushRemoteAction == PushRemoteActionUserGo) {
            self.activityName.text = NSLocalizedString(@"Attendees list", nil);
        } else if (push.pushRemoteAction == PushRemoteActionUserDontGo) {
            self.activityName.text = NSLocalizedString(@"Attendees list", nil);
        } else if (push.pushRemoteAction == PushRemoteActionNewActivityAround) {
            self.activityName.text = NSLocalizedString(@"New activity around you", nil);
        } else if (push.pushRemoteAction == PushRemoteActionNewActivityInvit) {
            self.activityName.text = NSLocalizedString(@"New activity with your tribe", nil);
        }
        [self addSubview:_activityName];
        
        self.notificationText = [[UILabel alloc]initWithFrame:CGRectMake(40, 21, 240, 12)];
        self.notificationText.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        self.notificationText.textColor = UIColorFromRGB(0x2b4b58);
        self.notificationText.text = push.text;
        [self addSubview:_notificationText];
        
        self.icone = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22, 22)];
        self.icone.image = [UIImage imageNamed:@"All_notification_badge"];
        [self addSubview:_icone];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openActivity)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)show{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self];
    
    self.icone.transform = CGAffineTransformMakeScale(0, 0);
    self.activityName.frame = CGRectMake( 20 + _activityName.frame.origin.x, _activityName.frame.origin.y, _activityName.frame.size.width, _activityName.frame.size.height);
    self.notificationText.frame = CGRectMake( 20 + _notificationText.frame.origin.x, _notificationText.frame.origin.y, _notificationText.frame.size.width, _notificationText.frame.size.height);
    self.activityName.alpha = 0;
    self.notificationText.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, 320, 42);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.icone.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.activityName.frame = CGRectMake( - 20 + _activityName.frame.origin.x, _activityName.frame.origin.y, _activityName.frame.size.width, _activityName.frame.size.height);
            self.activityName.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.4 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.notificationText.frame = CGRectMake( - 20 + _notificationText.frame.origin.x, _notificationText.frame.origin.y, _notificationText.frame.size.width, _notificationText.frame.size.height);
            self.notificationText.alpha = 1;
        } completion:^(BOOL finished) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval: 4 target: self selector:@selector(close) userInfo: nil repeats:NO];
        }];
    }];
    
}

- (void)panEvent:(UIPanGestureRecognizer *)sender{
    
    CGPoint velocity = [sender velocityInView:self];
    
    if (velocity.y < 0) {
        [sender removeTarget:self action:@selector(panEvent:)];
        [self close];
    }
    
}

- (void)close{
    
    [self.timer invalidate];
    self.timer = nil;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(0, -42, 320, 42);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - Private

- (void)openActivity{
    
    [self close];
    
    if (self.enable) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate deepLinkingActivity:_push];
    }
    
}

@end
