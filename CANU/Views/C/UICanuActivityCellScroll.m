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
#import "ProfilePicture.h"
#import "UICanuLabelDate.h"

@interface UICanuActivityCellScroll ()

@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UILabel *counterInvit;
@property (nonatomic, strong) UICanuLabelUserName *userName;
@property (nonatomic, strong) UICanuLabelActivityName *nameActivity;
@property (nonatomic, strong) UICanuLabelLocation *location;
@property (nonatomic, strong) UICanuLabelDate *date;

@end

@implementation UICanuActivityCellScroll

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activity                         = activity;

        UIImageView *background               = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 134)];
        background.image                      = [UIImage imageNamed:@"C_activity_background"];
        background.userInteractionEnabled     = YES;
        [self addSubview:background];

        self.profilePicture                   = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
        [self.profilePicture setImageWithURL:_activity.user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
        [background addSubview:_profilePicture];

        UIImageView *strokePicture            = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        strokePicture.image                   = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
        [self.profilePicture addSubview:strokePicture];

        self.userName                         = [[UICanuLabelUserName alloc] initWithFrame:CGRectMake(55, 18, 200, 17)];
        self.userName.text                    = self.activity.user.userName;
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
        self.nameActivity.text                     = _activity.title;
        [background addSubview:_nameActivity];

        self.location         = [[UICanuLabelLocation alloc]initWithFrame:CGRectMake( 2 + 10, frame.size.height - 29, 210, 30)];
        self.location.text                         = _activity.locationDescription;
        [background addSubview:_location];

        self.date                 = [[UICanuLabelDate alloc]initWithFrame:CGRectMake(frame.size.width - 310, frame.size.height - 29, 300, 30)];
        [self.date setDate:_activity];
        [background addSubview:_date];

        self.loadingIndicator                 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.frame           = CGRectMake(243.0f, 45, 45, 45);
        [background addSubview:_loadingIndicator];

        self.actionButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame               = CGRectMake(frame.size.width - 10 - 45, 45, 45, 45);
        [self.actionButton addTarget:self action:@selector(touchActionButton) forControlEvents:UIControlEventTouchDown];
        [background addSubview:_actionButton];
        
        if ( _activity.status == UICanuActivityCellGo ) {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
        } else if ( _activity.status == UICanuActivityCellToGo ){
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
        } else {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_edit"] forState:UIControlStateNormal];
            self.actionButton.frame = CGRectMake(frame.size.width - 23 - 18, 17, 18, 18);
        }
        
    }
    return self;
}

- (void)touchActionButton{
    [self.delegate cellEventActionButton:self];
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
    }];
    
}

@end
