//
//  UICanuActivityCellScroll.m
//  CANU
//
//  Created by Vivien Cormier on 11/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuActivityCellScroll.h"
#import "UIImageView+AFNetworking.h"
#import "AFCanuAPIClient.h"
#import "UICanuLabelUserName.h"
#import "UICanuLabelActivityName.h"
#import "UICanuLabelLocation.h"
#import "Activity.h"
#import "Notification.h"
#import "ProfilePicture.h"
#import "UICanuLabelDate.h"
#import <QuartzCore/QuartzCore.h>

@interface UICanuActivityCellScroll ()

@property (nonatomic) NSInteger previousNotification;
@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UIImageView *badge;
@property (nonatomic, strong) UILabel *counterInvit;
@property (nonatomic, strong) UILabel *textNotification;
@property (nonatomic, strong) UICanuLabelUserName *userName;
@property (nonatomic, strong) UICanuLabelActivityName *nameActivity;
@property (nonatomic, strong) UICanuLabelLocation *location;
@property (nonatomic, strong) UICanuLabelDate *date;
@property (nonatomic, strong) UIView *wrapperActivityBottom;
@property (nonatomic, strong) UIScrollView *wrapperActivityBottomNotification;
@property (nonatomic) BOOL stopAnimation;
@property (nonatomic) BOOL adressIsShowed;

@end

@implementation UICanuActivityCellScroll

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activity                         = activity;
        
        self.stopAnimation = NO;
        self.adressIsShowed = YES;

        UIImageView *background               = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 105)];
        background.image                      = [UIImage imageNamed:@"F_activity_background"];
        background.userInteractionEnabled     = YES;
        [self addSubview:background];

        self.profilePicture                   = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
        [self.profilePicture setImageWithURL:_activity.user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
        [background addSubview:_profilePicture];

        UIImageView *strokePicture            = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        strokePicture.image                   = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
        [self.profilePicture addSubview:strokePicture];

        self.userName                         = [[UICanuLabelUserName alloc] initWithFrame:CGRectMake(55, 18, 200, 17)];
        if ([self.activity.user.firstName mk_isEmpty]) {
            self.userName.text = self.activity.user.userName;
        } else {
            self.userName.text = self.activity.user.firstName;
        }
        
        [background addSubview:_userName];
        
        CGSize expectedLabelSize = [self.userName.text sizeWithFont:self.userName.font
                                          constrainedToSize:self.userName.frame.size
                                              lineBreakMode:self.userName.lineBreakMode];
        
        self.counterInvit = [[UILabel alloc]initWithFrame:CGRectMake( 55 + 5 + expectedLabelSize.width, 18, 70, 17)];
        self.counterInvit.textColor = UIColorFromRGB(0x2b4b58);
        self.counterInvit.alpha = 0.3;
        self.counterInvit.backgroundColor = [UIColor clearColor];
        self.counterInvit.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        if ([_activity.attendeeIds count] != 1) {
            self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[_activity.attendeeIds count] -1];
        }
        [background addSubview:_counterInvit];

        self.nameActivity = [[UICanuLabelActivityName alloc]initWithFrame:CGRectMake(10, 57, 280, 25)];
        self.nameActivity.text                     = self.activity.title;
        [background addSubview:_nameActivity];

        self.loadingIndicator                 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.frame           = CGRectMake(243.0f, 45, 45, 45);
        [background addSubview:_loadingIndicator];

        self.actionButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame               = CGRectMake(frame.size.width - 10 - 45, 45, 45, 45);
        [self.actionButton addTarget:self action:@selector(touchActionButton) forControlEvents:UIControlEventTouchUpInside];
        [background addSubview:_actionButton];
        
        if ( _activity.status == UICanuActivityCellGo ) {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
        } else if ( _activity.status == UICanuActivityCellToGo ){
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
        } else {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_edit"] forState:UIControlStateNormal];
            self.actionButton.frame = CGRectMake(frame.size.width - 23 - 30, 8, 45, 45);
        }
        
        self.wrapperActivityBottom = [[UIView alloc]initWithFrame:CGRectMake(2, 102, 300, 30)];
        [background addSubview:_wrapperActivityBottom];
        
        UIImageView *backgroundBottom = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -1, 304, 33)];
        backgroundBottom.image = [UIImage imageNamed:@"E_Activity_bottom"];
        [self.wrapperActivityBottom addSubview:backgroundBottom];
        
        self.wrapperActivityBottomNotification = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -1, 300, 30)];
        self.wrapperActivityBottomNotification.scrollEnabled = NO;
        self.wrapperActivityBottomNotification.contentSize = CGSizeMake(300, 60);
        [self.wrapperActivityBottom addSubview:_wrapperActivityBottomNotification];
        
        UIImageView *badgeBottom = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8 + 30, 13, 13)];
        badgeBottom.image = [UIImage imageNamed:@"All_badge_notification"];
        [self.wrapperActivityBottomNotification addSubview:badgeBottom];
        
        self.textNotification = [[UILabel alloc]initWithFrame:CGRectMake( 25, 30, 240, 30)];
        self.textNotification.textColor = UIColorFromRGB(0x2b4b58);
        self.textNotification.backgroundColor = [UIColor clearColor];
        self.textNotification.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        [self.wrapperActivityBottomNotification addSubview:_textNotification];
        
        self.location = [[UICanuLabelLocation alloc]initWithFrame:CGRectMake(10, 0, 210, 30)];
        self.location.text = _activity.locationDescription;
        [self.wrapperActivityBottomNotification addSubview:_location];
        
        self.date = [[UICanuLabelDate alloc]initWithFrame:CGRectMake(frame.size.width - 310 -2, 0, 300, 30)];
        [self.date setDate:_activity];
        [self.wrapperActivityBottomNotification addSubview:_date];
        
        CGSize sizeLocation = [self.location.text sizeWithFont:self.location.font
                                             constrainedToSize:self.location.frame.size
                                                 lineBreakMode:self.location.lineBreakMode];
        
        CGSize sizeDate = [self.date.text sizeWithFont:self.date.font
                                     constrainedToSize:self.date.frame.size
                                         lineBreakMode:self.date.lineBreakMode];
        
        if (10 + sizeLocation.width + 10 + sizeDate.width + 10 > 280) {
            int gap = 10 + sizeLocation.width + 10 + sizeDate.width + 10 - 300;
            self.location.frame = CGRectMake(10, 0, sizeLocation.width - gap, 30);
        }
        
        UIButton *areaTouch = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 240, 95)];
        [areaTouch addTarget:self action:@selector(touchArea) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:areaTouch];
        
        UIButton *areaAdress = [[UIButton alloc]initWithFrame:CGRectMake(0, 95, 150, 35)];
        [areaAdress addTarget:self action:@selector(touchAdress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:areaAdress];
        
        if ([self.activity.notifications count] != 0) {
            self.badge = [[UIImageView alloc] initWithFrame:CGRectMake(33, 9, 13, 13)];
            self.badge.image = [UIImage imageNamed:@"All_badge_notification"];
            [self addSubview:_badge];
            
            self.previousNotification = 0;
            
            [self animateNotification];
            
        }
        
    }
    return self;
}

- (void)touchArea{
    [self.delegate cellEventTouched:self];
}

- (void)touchActionButton{
    [self.delegate cellEventActionButton:self];
}

- (void)touchAdress{
    if (_adressIsShowed) {
        [self.delegate cellEventAdresse:self];
    } else {
        [self.delegate cellEventTouched:self]; 
    }
}

- (void)animateAfterDelay:(float)delay{
    
    self.alpha = 0;
    self.profilePicture.transform = CGAffineTransformMakeScale(0, 0);
    self.userName.frame = CGRectMake( 20 + _userName.frame.origin.x, _userName.frame.origin.y, _userName.frame.size.width, _userName.frame.size.height);
    self.userName.alpha = 0;
    self.counterInvit.frame = CGRectMake( 20 + _counterInvit.frame.origin.x, _counterInvit.frame.origin.y, _counterInvit.frame.size.width, _counterInvit.frame.size.height);
    self.counterInvit.alpha = 0;
    self.nameActivity.frame = CGRectMake( 20 + _nameActivity.frame.origin.x, _nameActivity.frame.origin.y, _nameActivity.frame.size.width, _nameActivity.frame.size.height);
    self.nameActivity.alpha = 0;
    self.location.alpha = 0;
    self.date.alpha = 0;
    self.actionButton.transform = CGAffineTransformMakeScale(0, 0);
    self.badge.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.4 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.profilePicture.transform = CGAffineTransformMakeScale(1, 1);
            self.userName.frame = CGRectMake( - 20 + _userName.frame.origin.x, _userName.frame.origin.y, _userName.frame.size.width, _userName.frame.size.height);
            self.userName.alpha = 1;
            self.counterInvit.frame = CGRectMake( - 20 + _counterInvit.frame.origin.x, _counterInvit.frame.origin.y, _counterInvit.frame.size.width, _counterInvit.frame.size.height);
            self.counterInvit.alpha = 0.3;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.location.alpha = 1;
                self.date.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.nameActivity.frame = CGRectMake( - 20 + _nameActivity.frame.origin.x, _nameActivity.frame.origin.y, _nameActivity.frame.size.width, _nameActivity.frame.size.height);
            self.nameActivity.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.actionButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.badge.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

- (void)hiddenBottomBar:(BOOL)hidden{
    
    if (hidden) {
        self.counterInvit.alpha = 0;
        self.actionButton.alpha = 0;
        self.wrapperActivityBottom.alpha = 0;
        self.wrapperActivityBottom.frame = CGRectMake(_wrapperActivityBottom.frame.origin.x, _wrapperActivityBottom.frame.origin.y + 100, _wrapperActivityBottom.frame.size.width, _wrapperActivityBottom.frame.size.height);
    } else {
        self.counterInvit.alpha = 0.3;
        self.actionButton.alpha = 1;
        self.wrapperActivityBottom.alpha = 1;
        self.wrapperActivityBottom.frame = CGRectMake(2, 102, 300, 30);
    }
    
}

- (void)updateWithActivity:(Activity *)activity{
    
    self.activity = activity;
    
    if ([activity.user.firstName mk_isEmpty]) {
        self.userName.text = activity.user.userName;
    } else {
        self.userName.text = activity.user.firstName;
    }
    if ([_activity.attendeeIds count] != 1) {
        self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[activity.attendeeIds count] -1];
    } else {
        self.counterInvit.text = @"";
    }
    self.nameActivity.text = activity.title;
    self.location.text     = activity.locationDescription;
    [self.date setDate:_activity];
    
    if ( _activity.status == UICanuActivityCellGo ) {
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
    } else if ( _activity.status == UICanuActivityCellToGo ){
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
    } else {
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_edit"] forState:UIControlStateNormal];
        self.actionButton.frame = CGRectMake(self.frame.size.width - 23 - 30, 8, 45, 45);
    }
    
    [self.badge removeFromSuperview];
    
    if ([activity.notifications count] != 0) {
        
        self.stopAnimation = NO;
        
        self.badge = [[UIImageView alloc] initWithFrame:CGRectMake(33, 9, 13, 13)];
        self.badge.image = [UIImage imageNamed:@"All_badge_notification"];
        [self addSubview:_badge];
        
        self.previousNotification = 0;
        
        [self animateNotification];
        
    } else {
        self.stopAnimation = YES;
        self.wrapperActivityBottomNotification.contentOffset = CGPointMake(0, 0);
        [self.wrapperActivityBottomNotification.layer removeAllAnimations];
        self.adressIsShowed = YES;
    }
    
}

- (void)forceDealloc{
    
    self.stopAnimation = YES;
    
}

- (void)animateNotification{
    
    if (!_stopAnimation) {
        
        self.adressIsShowed = YES;
        
        Notification *notif = [self.activity.notifications objectAtIndex:_previousNotification];
        
        self.previousNotification++;
        
        if (self.previousNotification >= [self.activity.notifications count]) {
            self.previousNotification = 0;
        }
        
        self.textNotification.text = notif.text;
        
        [UIView animateWithDuration:0.4 delay:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.wrapperActivityBottomNotification.contentOffset = CGPointMake(0, 30);
        } completion:^(BOOL finished) {
            self.adressIsShowed = NO;
            [UIView animateWithDuration:0.4 delay:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.wrapperActivityBottomNotification.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                
                [self animateNotification];
                
            }];
        }];
    }

}

@end
