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
        
        self.activity = activity;
        
        UIView *wrapperUser = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 166, 34)];
        wrapperUser.backgroundColor = UIColorFromRGB(0xf9f9f9);
        [self addSubview:wrapperUser];
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
        [avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,_activity.user.profileImageUrl]] placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        [wrapperUser addSubview:avatar];
        
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(37.0f, 5.0f, 128.0f, 25.0f)];
        userName.text = self.activity.user.userName;
        userName.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
        userName.backgroundColor = UIColorFromRGB(0xf9f9f9);
        userName.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [wrapperUser addSubview:userName];
        
        UIView *wrapperTime = [[UIView alloc]initWithFrame:CGRectMake(167, 0, 133, 34)];
        wrapperTime.backgroundColor = UIColorFromRGB(0xf9f9f9);
        [self addSubview:wrapperTime];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"d MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 33, 34)];
        day.text = [dateFormatter stringFromDate:self.activity.start];
        day.font = [UIFont fontWithName:@"Lato-Regular" size:10.0];
        day.backgroundColor = UIColorFromRGB(0xf9f9f9);
        day.textColor = UIColorFromRGB(0x2b4b58);
        [wrapperTime addSubview:day];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        UILabel *timeStart = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 44, 34)];
        timeStart.text = [timeFormatter stringFromDate:self.activity.start];
        timeStart.font = [UIFont fontWithName:@"Lato-Bold" size:11.0];
        timeStart.backgroundColor = UIColorFromRGB(0xf9f9f9);
        timeStart.textColor = UIColorFromRGB(0x2b4b58);
        [wrapperTime addSubview:timeStart];
        
        UILabel *timeEnd = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 44, 34)];
        timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:self.activity.end]];
        timeEnd.font = [UIFont fontWithName:@"Lato-Italic" size:11.0];
        timeEnd.backgroundColor = UIColorFromRGB(0xf9f9f9);
        timeEnd.textColor = UIColorFromRGB(0x2b4b58);
        timeEnd.alpha = 0.5;
        [wrapperTime addSubview:timeEnd];
        
        UIView *wrapperName = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 300, 85)];
        wrapperName.backgroundColor = [UIColor whiteColor];
        [self addSubview:wrapperName];
        
        UILabel *nameActivity = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, 210, 28)];
        nameActivity.font = [UIFont fontWithName:@"Lato-Bold" size:22.0];
        nameActivity.backgroundColor = [UIColor whiteColor];
        nameActivity.textColor = UIColorFromRGB(0x2b4b58);
        nameActivity.text = _activity.title;
        [wrapperName addSubview:nameActivity];
        
        UILabel *location = [[UILabel alloc]initWithFrame:CGRectMake(16, 52, 210, 16)];
        location.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
        location.backgroundColor = [UIColor whiteColor];
        location.textColor = UIColorFromRGB(0x2b4b58);
        location.text = _activity.locationDescription;
        [wrapperName addSubview:location];
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.frame = CGRectMake(243.0f, 19.0f, 47.0f, 47.0f);
        [wrapperName addSubview:_loadingIndicator];
        
        UIView *wrapperAnimatiomButton = [[UIView alloc]initWithFrame:CGRectMake(243.0f, 19.0f, 47.0f, 47.0f)];
        wrapperAnimatiomButton.clipsToBounds = YES;
        [wrapperName addSubview:wrapperAnimatiomButton];
        
        self.animationButtonGo = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, 67, 67)];
        self.animationButtonGo.image = [UIImage imageNamed:@"feed_action_circle_go"];
        self.animationButtonGo.hidden = YES;
        [wrapperAnimatiomButton addSubview:_animationButtonGo];
        
        self.animationButtonToGo = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -10, 67, 67)];
        self.animationButtonToGo.image = [UIImage imageNamed:@"feed_action_circle_togo"];
        self.animationButtonToGo.hidden = YES;
        [wrapperAnimatiomButton addSubview:_animationButtonToGo];
        
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame = CGRectMake(243.0f, 19.0f, 47.0f, 47.0f);
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
