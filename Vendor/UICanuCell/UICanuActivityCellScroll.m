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
#import "UICanuLabelDay.h"
#import "UICanuLabelTimeStart.h"
#import "UICanuLabelTimeEnd.h"
#import "UICanuLabelActivityName.h"
#import "UICanuLabelLocation.h"
#import "UICanuLabelDescription.h"
#import "Activity.h"

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@interface UICanuActivityCellScroll ()



@end

@implementation UICanuActivityCellScroll

@synthesize activity = _activity;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activity                         = activity;

        UIView *wrapperUser                   = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 148, 34)];
        wrapperUser.backgroundColor           = UIColorFromRGB(0xf9f9f9);
        [self addSubview:wrapperUser];

        UIImageView *avatar                   = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
        [avatar setImageWithURL:_activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        [wrapperUser addSubview:avatar];

        UICanuLabelUserName *userName         = [[UICanuLabelUserName alloc] initWithFrame:CGRectMake(37.0f, 5.0f, 107.0f, 25.0f)];
        userName.text                         = self.activity.user.userName;
        [wrapperUser addSubview:userName];

        UIView *wrapperTime                   = [[UIView alloc]initWithFrame:CGRectMake(149, 0, 151, 34)];
        wrapperTime.backgroundColor           = UIColorFromRGB(0xf9f9f9);
        [self addSubview:wrapperTime];

        UICanuLabelDay *day                   = [[UICanuLabelDay alloc]initWithFrame:CGRectMake(5, 0, 33, 34)];
        day.date                              = self.activity.start;
        [wrapperTime addSubview:day];

        UICanuLabelTimeStart *timeStart       = [[UICanuLabelTimeStart alloc]initWithFrame:CGRectMake(35, 0, 51, 34)];
        timeStart.date                        = self.activity.start;
        [wrapperTime addSubview:timeStart];

        UICanuLabelTimeEnd *timeEnd           = [[UICanuLabelTimeEnd alloc]initWithFrame:CGRectMake(87, 0, 58, 34)];
        timeEnd.date                          = self.activity.end;
        [wrapperTime addSubview:timeEnd];

        UIView *wrapperName                   = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 300, 85)];
        wrapperName.backgroundColor           = [UIColor whiteColor];
        [self addSubview:wrapperName];

        UICanuLabelActivityName *nameActivity = [[UICanuLabelActivityName alloc]initWithFrame:CGRectMake(16, 15, 210, 28)];
        nameActivity.text                     = _activity.title;
        [wrapperName addSubview:nameActivity];

        UICanuLabelLocation *location         = [[UICanuLabelLocation alloc]initWithFrame:CGRectMake(16, 52, 210, 16)];
        location.text                         = _activity.locationDescription;
        [wrapperName addSubview:location];

        self.loadingIndicator                 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.frame           = CGRectMake(243.0f, 19.0f, 47.0f, 47.0f);
        [wrapperName addSubview:_loadingIndicator];

        UIView *wrapperAnimationButton        = [[UIView alloc]initWithFrame:CGRectMake(243.0f, 19.0f, 47.0f, 47.0f)];
        wrapperAnimationButton.clipsToBounds  = YES;
        [wrapperName addSubview:wrapperAnimationButton];

        self.animationButtonGo                = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, 67, 67)];
        self.animationButtonGo.image          = [UIImage imageNamed:@"feed_action_circle_go"];
        self.animationButtonGo.hidden         = YES;
        [wrapperAnimationButton addSubview:_animationButtonGo];

        self.animationButtonToGo              = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, 67, 67)];
        self.animationButtonToGo.image        = [UIImage imageNamed:@"feed_action_circle_togo"];
        self.animationButtonToGo.hidden       = YES;
        [wrapperAnimationButton addSubview:_animationButtonToGo];

        self.actionButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame               = CGRectMake(243.0f, 19.0f, 47.0f, 47.0f);
        [self.actionButton addTarget:self action:@selector(touchActionButton) forControlEvents:UIControlEventTouchDown];
        [wrapperName addSubview:_actionButton];
        
        if ( _activity.status == UICanuActivityCellGo ) {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes.png"] forState:UIControlStateNormal];
        } else if ( _activity.status == UICanuActivityCellToGo ){
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go.png"] forState:UIControlStateNormal];
        } else {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_edit.png"] forState:UIControlStateNormal];
        }
        
    }
    return self;
}

- (void)touchActionButton{
    [self.delegate cellEventActionButton:self];
}

@end
