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

@interface UICanuTimePicker () <UICanuScrollPickerDelegate,UICanuAMPMPickerDelegate>

@property (nonatomic) BOOL isBlokedValue;
@property (nonatomic) BOOL valueIsChanged;
@property (nonatomic) BOOL valueIsChangedAmPm;
@property (strong, nonatomic) NSArray *arrayHours;
@property (strong, nonatomic) NSArray *arrayMinutes;
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
    
        if (is24hFormat) {
            self.arrayHours = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        } else {
            self.arrayHours = @[@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
        }
        
        CGRect rectHours = CGRectMake(40, 1, 40, self.frame.size.height - 2);
        
        if (!is24hFormat) {
            rectHours = CGRectMake(35, 1, 30, self.frame.size.height - 2);
        }
        
        self.hoursScroll = [[UICanuScrollPicker alloc]initWithFrame:rectHours WithContent:_arrayHours];
        [self.hoursScroll changeCurrentObjectTo:1];
        self.hoursScroll.delegatePicker = self;
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
        
        self.arrayMinutes = @[@"0",@"15",@"30",@"45"];
        
        CGRect rectMinutes = CGRectMake(80 + 10, 1, 40, self.frame.size.height - 2);
        
        if (!is24hFormat) {
            rectMinutes = CGRectMake(65 + 10, 1, 30, self.frame.size.height - 2);
        }
        
        self.minutesScroll = [[UICanuScrollPicker alloc]initWithFrame:rectMinutes WithContent:_arrayMinutes];
        [self.minutesScroll changeCurrentObjectTo:1];
        [self addSubview:_minutesScroll];
        
        if (!is24hFormat) {
            self.amPmScroll = [[UICanuAMPMPicker alloc] initWithFrame:CGRectMake(100 + 10, 1, 30, self.frame.size.height - 2)];
            [self.amPmScroll changeCurrentObjectTo:1];
            [self.amPmScroll changeCurrentObjectTo:0];
            self.amPmScroll.delegatePicker = self;
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

#pragma mark - Public

- (NSDate *)selectedTime{
    
    int hours = [[_arrayHours objectAtIndex:[self.hoursScroll currentObject]] intValue];
    
    int minutes = [[_arrayMinutes objectAtIndex:[self.minutesScroll currentObject]] intValue];
    
    if (![self timeIs24HourFormat]) {
        
        NSArray *hours24 = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        
        int indexhours24 = [self.hoursScroll currentObject];
        
        if ([self.amPmScroll currentObject] == 1) {
            indexhours24 += 12;
        }
        
        hours = [[hours24 objectAtIndex:indexhours24] intValue];
        
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    [components setHour:hours];
    [components setMinute:minutes];
    
    NSDate *time = [calendar dateFromComponents:components];
    
    return time;
    
}

- (void)changeTo:(NSDate *)date{
    
    int hours = [date mk_hour];
    int mins = [date mk_minutes];
    
    if ([self timeIs24HourFormat]) {
        [self.hoursScroll changeCurrentObjectTo:hours];
        [self.minutesScroll changeCurrentObjectTo:abs(mins/15)];
    } else {
        if (hours < 12) {
            [self.amPmScroll changeCurrentObjectTo:0];
        } else {
            [self.amPmScroll changeCurrentObjectTo:1];
        }
        
        if (hours > 12) {
            hours -= 12;
        }
        
        [self.hoursScroll changeCurrentObjectTo:hours];
        [self.minutesScroll changeCurrentObjectTo:abs(mins/15)];
        
    }
    
}

- (void)isToday:(BOOL)blockedValue{
    
    self.isBlokedValue = blockedValue;
    
    int maxHours = [[NSDate date] mk_hour];
    
    int maxMins = abs([[NSDate date] mk_minutes]/15) + 1;
    
    if (maxMins >= [_arrayMinutes count]) {
        maxMins = 0;
        maxHours++;
    }
    
    if (maxHours >= 24) {
        maxHours = 0;
    }
    
    if (![self timeIs24HourFormat]) {
        
        if (maxHours < 12) {
            [self.amPmScroll blockTo:0];
        } else {
            [self.amPmScroll blockTo:1];
        }
        
        if (maxHours > 12) {
            maxHours -= 12;
        }
        
    }
    
    if (blockedValue) {
        
        [self.hoursScroll blockScrollTo:maxHours];
        [self.minutesScroll blockScrollTo:maxMins];
        
    } else {
        
        [self.hoursScroll blockScrollTo:[_arrayHours count]];
        [self.minutesScroll blockScrollTo:[_arrayMinutes count]];
        [self.amPmScroll blockTo:2];
        
    }
    
}

#pragma mark - UICanuScrollPickerDelegate

- (void)blockedValueIsSelected:(BOOL)isSelected{
    
    if (_valueIsChanged != isSelected && _isBlokedValue) {
        
        self.valueIsChanged = isSelected;
        
        int maxHours = [[NSDate date] mk_hour];
        
        int maxMins = abs([[NSDate date] mk_minutes]/15) + 1;
        
        if (maxMins >= [_arrayMinutes count]) {
            maxMins = 0;
            maxHours++;
        }
        
        if (maxHours >= 24) {
            maxHours = 0;
        }
        
        if (![self timeIs24HourFormat]) {
            
            if (maxHours < 12) {
                [self.amPmScroll blockTo:0];
            } else {
                [self.amPmScroll blockTo:1];
            }
            
            if (maxHours > 12) {
                maxHours -= 12;
            }
            
        }
        
        if (isSelected && _isBlokedValue) {
            
            [self.hoursScroll blockScrollTo:maxHours];
            [self.minutesScroll blockScrollTo:maxMins];
            
        } else {
            
            [self.hoursScroll blockScrollTo:maxHours];
            [self.minutesScroll blockScrollTo:[_arrayMinutes count]];
            
            
        }
        
        
        
    }
    
}

#pragma mark - UICanuAMPMPickerDelegate

- (void)amPmchangeIsBlockedValue:(BOOL)blockedValue{
    
    if (_valueIsChangedAmPm != blockedValue) {
        
        self.valueIsChangedAmPm = blockedValue;
        
        int maxHours = [[NSDate date] mk_hour];
        
        int maxMins = abs([[NSDate date] mk_minutes]/15) + 1;
        
        if (maxMins >= [_arrayMinutes count]) {
            maxMins = 0;
            maxHours++;
        }
        
        if (maxHours >= 24) {
            maxHours = 0;
        }
        
        if (![self timeIs24HourFormat]) {
            
            if (maxHours < 12) {
                [self.amPmScroll blockTo:0];
            } else {
                [self.amPmScroll blockTo:1];
            }
            
            if (maxHours > 12) {
                maxHours -= 12;
            }
            
        }
        
        if (blockedValue) {
            
            [self.hoursScroll blockScrollTo:maxHours];
            [self.minutesScroll blockScrollTo:maxMins];
            
        } else {
            
            [self.hoursScroll blockScrollTo:[_arrayHours count]];
            [self.minutesScroll blockScrollTo:[_arrayMinutes count]];
            
        }
        
    }
    
}

@end
