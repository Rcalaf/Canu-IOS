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
@property (strong, nonatomic) UIView *buttonBackground;

@end

@implementation UICanuCalendarButtonPicker

- (id)initWithFrame:(CGRect)frame Date:(NSDate *)date Type:(CANUCalendarButtonType)canuCalendarButtonType{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xe9eeee);
        
        self.clipsToBounds = YES;
        
        self.canuCalendarButtonType = canuCalendarButtonType;
        
        self.date = date;
        
        self.selected = NO;
        
        NSDateFormatter * formatDayNumber = [[NSDateFormatter alloc] init];
        [formatDayNumber setLocale: [NSLocale currentLocale]];
        [formatDayNumber setDateFormat:@"MMM"];
        
        self.buttonBackground = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width - 37)/2, frame.size.height - 37, 37, 37)];
        self.buttonBackground.backgroundColor = UIColorFromRGB(0xe9eeee);
        [self addSubview:_buttonBackground];
        
        self.labelDay = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 25)/2, (frame.size.height - 25)/2, 25, 25)];
        self.labelDay.text = [NSString stringWithFormat:@"%i",[date mk_day]];
        self.labelDay.font = [UIFont fontWithName:@"Lato-Regular" size:12];
        self.labelDay.textAlignment = NSTextAlignmentCenter;
        self.labelDay.textColor = UIColorFromRGB(0xabb3b7);
        if (canuCalendarButtonType == CANUCalendarButtonOff) {
            self.labelDay.textColor = UIColorFromRGB(0xdce3e6);
        }
        self.labelDay.backgroundColor = [UIColor clearColor];
        [self addSubview:_labelDay];
        
        self.labelMonth = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 25)/2, frame.size.height - 13, 25, 8)];
        self.labelMonth.text = [[formatDayNumber stringFromDate:date] uppercaseString];
        self.labelMonth.font = [UIFont fontWithName:@"Lato-Regular" size:8];
        self.labelMonth.textAlignment = NSTextAlignmentCenter;
        self.labelMonth.textColor = UIColorFromRGB(0xabb3b7);
        self.labelMonth.backgroundColor = [UIColor clearColor];
        self.labelMonth.alpha = 0;
        [self addSubview:_labelMonth];
        
        if (canuCalendarButtonType == CANUCalendarButtonWithMonth) {
            self.labelMonth.alpha = 1;
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
            self.buttonBackground.backgroundColor = UIColorFromRGB(0x1ca6c3);
            
            self.labelDay.textColor = [UIColor whiteColor];
            
            self.labelMonth.alpha = 1;
            self.labelMonth.textColor = [UIColor whiteColor];
            
            [self.delegate  dayDidTouch:self];
            
        } else {
            
            self.buttonBackground.backgroundColor = UIColorFromRGB(0xe9eeee);
            
            self.labelDay.textColor = UIColorFromRGB(0xabb3b7);
            
            if (_canuCalendarButtonType != CANUCalendarButtonWithMonth) {
                self.labelMonth.alpha = 0;
            }
            
            self.labelMonth.textColor = UIColorFromRGB(0xabb3b7);
            
        }
    
    }
    
}

@end
