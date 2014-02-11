//
//  UICanuTimePicker.m
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTimePicker.h"

#import "UICanuScrollPicker.h"
#import "UICanuAMPMPicker.h"

@interface UICanuTimePicker ()

@property (strong, nonatomic) UICanuScrollPicker *hoursScroll;
@property (strong, nonatomic) UICanuScrollPicker *minutesScroll;
@property (strong, nonatomic) UICanuAMPMPicker *amPmScroll;

@end

@implementation UICanuTimePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 47)];
        icon.image = [UIImage imageNamed:@"F1_time_picker"];
        [self addSubview:icon];
        
        BOOL is24hFormat = [self timeIs24HourFormat];
        
        NSArray *arrayHours;
        
        if (is24hFormat) {
            arrayHours = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        } else {
            arrayHours = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        }
        
        CGRect rectHours = CGRectMake(40, 1, 40, self.frame.size.height - 2);
        
        if (!is24hFormat) {
            rectHours = CGRectMake(35, 1, 30, self.frame.size.height - 2);
        }
        
        self.hoursScroll = [[UICanuScrollPicker alloc]initWithFrame:rectHours WithContent:arrayHours];
        [self.hoursScroll changeCurrentObjectTo:13];
        [self addSubview:_hoursScroll];
        
        CGRect rectDoubleDote = CGRectMake(80, 19, 10, 16);
        
        if (!is24hFormat) {
            rectDoubleDote = CGRectMake(65, 19, 10, 16);
        }
        
        UILabel *doubleDote = [[UILabel alloc]initWithFrame:rectDoubleDote];
        doubleDote.font = [UIFont fontWithName:@"Lato-Bold" size:15];
        doubleDote.textColor = UIColorFromRGB(0x1ca6c3);
        doubleDote.textAlignment = NSTextAlignmentCenter;
        doubleDote.text = @":";
        doubleDote.backgroundColor = [UIColor whiteColor];
        [self addSubview:doubleDote];
        
        NSArray *arrayMinutes = @[@"0",@"15",@"30",@"45"];
        
        CGRect rectMinutes = CGRectMake(80 + 10, 1, 40, self.frame.size.height - 2);
        
        if (!is24hFormat) {
            rectMinutes = CGRectMake(65 + 10, 1, 30, self.frame.size.height - 2);
        }
        
        self.minutesScroll = [[UICanuScrollPicker alloc]initWithFrame:rectMinutes WithContent:arrayMinutes];
        [self.minutesScroll changeCurrentObjectTo:13];
        [self addSubview:_minutesScroll];
        
        if (!is24hFormat) {
            self.amPmScroll = [[UICanuAMPMPicker alloc] initWithFrame:CGRectMake(100 + 10, 1, 30, self.frame.size.height - 2)];
            [self.amPmScroll changeCurrentObjectTo:0];
            [self addSubview:_amPmScroll];
        }
        
    }
    return self;
}

- (BOOL)timeIs24HourFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
    return is24Hour;
}

@end
