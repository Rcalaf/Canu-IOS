//
//  UICanuCalendarButtonPicker.m
//  CANU
//
//  Created by Vivien Cormier on 12/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuCalendarButtonPicker.h"

@interface UICanuCalendarButtonPicker ()

@property (nonatomic) CANUCalendarButtonType canuCalendarButtonType;
@property (strong, nonatomic) UILabel *labelDay;
@property (strong, nonatomic) UILabel *labelMonth;
@property (strong, nonatomic) UIImageView *buttonBackground;

@end

@implementation UICanuCalendarButtonPicker

- (id)initWithFrame:(CGRect)frame Date:(NSDate *)date Type:(CANUCalendarButtonType)canuCalendarButtonType{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.clipsToBounds = YES;
        
        self.canuCalendarButtonType = canuCalendarButtonType;
        
        self.date = date;
        
        self.selected = NO;
        
        NSDateFormatter * formatDayNumber = [[NSDateFormatter alloc] init];
        [formatDayNumber setLocale: [NSLocale currentLocale]];
        [formatDayNumber setDateFormat:@"MMM"];
        
        self.buttonBackground = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - 25)/2, frame.size.height - 34, 25, 25)];
        if (canuCalendarButtonType == CANUCalendarButtonWithMonth) {
           self.buttonBackground.image = [UIImage imageNamed:@"F_calendar_button_background_today"];
        }
        [self addSubview:_buttonBackground];
        
        self.labelDay = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 25)/2, 7, 25, 25)];
        self.labelDay.text = [NSString stringWithFormat:@"%i",[date mk_day]];
        self.labelDay.font = [UIFont fontWithName:@"Lato-Regular" size:13];
        self.labelDay.textAlignment = NSTextAlignmentCenter;
        self.labelDay.textColor = UIColorFromRGB(0x2b4b58);
        self.labelDay.alpha = 0.3f;
        if (canuCalendarButtonType == CANUCalendarButtonOff) {
            self.labelDay.alpha = 0.1f;
        }
        self.labelDay.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelDay];
        
        self.labelMonth = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 25)/2, frame.size.height - 7, 25, 7)];
        self.labelMonth.text = [[formatDayNumber stringFromDate:date] uppercaseString];
        self.labelMonth.font = [UIFont fontWithName:@"Lato-Regular" size:7];
        self.labelMonth.textAlignment = NSTextAlignmentCenter;
        self.labelMonth.textColor = UIColorFromRGB(0x2b4b58);
        self.labelMonth.backgroundColor = [UIColor clearColor];
        self.labelMonth.alpha = 0;
        [self addSubview:_labelMonth];
        
        if (canuCalendarButtonType == CANUCalendarButtonWithMonth) {
            self.labelMonth.alpha = 0.4f;
        }
        
        if (canuCalendarButtonType != CANUCalendarButtonOff) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [button addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
        }
        
    }
    return self;
}

- (void)selectDate{
    self.selected = YES;
}

- (void)setSelected:(BOOL)selected{
    
    if (_canuCalendarButtonType != CANUCalendarButtonOff) {
        
        if (selected) {
            self.buttonBackground.image = [UIImage imageNamed:@"F_calendar_button_background_selected"];
            
            self.labelDay.textColor = [UIColor whiteColor];
            self.labelDay.alpha = 1;
            
            self.labelMonth.alpha = 1;
            self.labelMonth.textColor = UIColorFromRGB(0x2b4b58);
            
            [self.delegate  dayDidTouch:self];
            
        } else {
            
            self.labelDay.textColor = UIColorFromRGB(0x2b4b58);
            self.labelDay.alpha = 0.3f;
            
            self.labelMonth.textColor = UIColorFromRGB(0x2b4b58);
            self.labelMonth.alpha = 0.4f;
            
            if (_canuCalendarButtonType != CANUCalendarButtonWithMonth) {
                self.labelMonth.alpha = 0;
                self.buttonBackground.image = nil;
            } else {
                self.buttonBackground.image = [UIImage imageNamed:@"F_calendar_button_background_today"];
            }
            
        }
    
    }
    
}

@end
