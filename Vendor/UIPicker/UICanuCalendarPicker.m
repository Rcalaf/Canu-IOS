//
//  UICanuCalendarPicker.m
//  CANU
//
//  Created by Vivien Cormier on 12/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuCalendarPicker.h"

#import "UICanuCalendarButtonPicker.h"

@interface UICanuCalendarPicker () <UICanuCalendarButtonPickerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayCell;
@property (strong, nonatomic) UIImageView *controleSlide1;
@property (strong, nonatomic) UIImageView *controleSlide2;
@property (strong, nonatomic) UICanuCalendarButtonPicker *currentSelected;
@property (strong, nonatomic) UICanuCalendarButtonPicker *firstDay;

@end

@implementation UICanuCalendarPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xe9eeee);
        
        self.clipsToBounds = YES;
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        UIView *headerDay = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        headerDay.backgroundColor = UIColorFromRGB(0xe6ebeb);
        [self addSubview:headerDay];
        
        UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 6)];
        shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        [headerDay addSubview:shadowDescription];
        
        UIImageView *shadowDescriptionReverse = [[UIImageView alloc]initWithFrame:CGRectMake(0, 116 - 6, 320, 6)];
        shadowDescriptionReverse.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        shadowDescriptionReverse.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:shadowDescriptionReverse];
        
        NSDateFormatter * dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setLocale: [NSLocale currentLocale]];
        NSArray * weekdays = [dateFormater weekdaySymbols];
        
        for (int i = 0; i < [weekdays count]; i ++) {
            
            UILabel *dayName = [[UILabel alloc]initWithFrame:CGRectMake(13 + i * 42, 0, 42, 20)];
            dayName.font = [UIFont fontWithName:@"Lato-Regular" size:7];
            dayName.textAlignment = NSTextAlignmentCenter;
            dayName.backgroundColor = [UIColor clearColor];
            dayName.textColor = UIColorFromRGB(0xabb3b7);
            dayName.text = [[weekdays objectAtIndex:i] substringToIndex:1];
            [headerDay addSubview:dayName];
            
        }
        
        UIScrollView *wrapperCalendar = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, 320, 116 - headerDay.frame.size.height)];
        wrapperCalendar.pagingEnabled = YES;
        wrapperCalendar.showsHorizontalScrollIndicator = NO;
        wrapperCalendar.delegate = self;
        [self addSubview:wrapperCalendar];
        
        // Current Date
        NSDateComponents *dateCurrent = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        // Formater for the range of today on this week
        NSDateFormatter * dateFormaterNumberDayForTheWeek = [[NSDateFormatter alloc] init];
        [dateFormaterNumberDayForTheWeek setLocale: [NSLocale currentLocale]];
        [dateFormaterNumberDayForTheWeek setDateFormat:@"c"];
        
        int yearCalendar = [dateCurrent year];
        
        int monthCalendar = [dateCurrent month];
        
        int dayCalendar = [dateCurrent day] - [[dateFormaterNumberDayForTheWeek stringFromDate:[NSDate date]] intValue] + 1;
        
        int dayOff = [[dateFormaterNumberDayForTheWeek stringFromDate:[NSDate date]] intValue] - 2;
        
        if (dayCalendar <= 0) {
            
            // if dayCalendar is <= 0 it's because the previous month
            
            monthCalendar -= 1;
            
            if (monthCalendar <= 0) {
                
                // if monthCalendar is <= 0 it's because the previous year
                
                monthCalendar = 12;
                
                yearCalendar -= 1;
                
            }
            
            NSDate *datePreviousMonth = [self dateWithYear:yearCalendar month:monthCalendar day:15];
            
            int numberofDayForThePreviousMonth = [self numberOfDayForTheCurrentMonth:datePreviousMonth];
            
            dayCalendar = numberofDayForThePreviousMonth + dayCalendar;
            
        }
        
        int numberOfDay = 7 * 4 * 1;
        
        int numberOf2week = 0,colums = 0,row = 0;
        
        NSDate *dateMonth = [self dateWithYear:yearCalendar month:monthCalendar day:dayCalendar];
        
        int numberofDayForTheMonth = [self numberOfDayForTheCurrentMonth:dateMonth];
        
        for (int i = 0; i < numberOfDay; i++) {
            
            CANUCalendarButtonType canuCalendarButtonType = CANUCalendarButtonNone;
            
            if (row == 0 && colums == 0) {
                canuCalendarButtonType = CANUCalendarButtonWithMonth;
            }
            
            if (dayCalendar == 1) {
                canuCalendarButtonType = CANUCalendarButtonWithMonth;
            }
            
            if (i <= dayOff) {
                canuCalendarButtonType = CANUCalendarButtonOff;
            } else if (i == dayOff + 1) {
                canuCalendarButtonType = CANUCalendarButtonWithMonth;
            }
            
            NSDate *date = [self dateWithYear:yearCalendar month:monthCalendar day:dayCalendar];
            
            UICanuCalendarButtonPicker *day = [[UICanuCalendarButtonPicker alloc]initWithFrame:CGRectMake(13 + colums * 42 + numberOf2week * 320, row * 42, 42, 42) Date:date Type:canuCalendarButtonType];
            day.delegate = self;
            [self.arrayCell addObject:day];
            [wrapperCalendar addSubview:day];
            
            if (i == dayOff + 3) {
                day.selected = YES;
                self.firstDay = day;
            }
            
            dayCalendar++;
            
            if (dayCalendar > numberofDayForTheMonth) {
                dayCalendar = 1;
                monthCalendar++;
                
                if (monthCalendar > 12) {
                    monthCalendar = 1;
                    yearCalendar++;
                }
                
                NSDate *dateMonth = [self dateWithYear:yearCalendar month:monthCalendar day:dayCalendar];
                numberofDayForTheMonth = [self numberOfDayForTheCurrentMonth:dateMonth];
                
            }
            
            colums++;
            
            if (colums >= 7) {
                colums = 0;
                row++;
            }
            
            if (row >= 2) {
                row = 0;
                numberOf2week++;
            }
            
        }
        
        wrapperCalendar.contentSize = CGSizeMake(320 * numberOf2week, 87);
        
        self.controleSlide1 = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 2 - 6, 116 - 8, 4, 4)];
        self.controleSlide1.image = [UIImage imageNamed:@"F1_Calendar_dote_Enable"];
        [self addSubview:_controleSlide1];
        
        self.controleSlide2 = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 2 + 6, 116 - 8, 4, 4)];
        self.controleSlide2.image = [UIImage imageNamed:@"F1_Calendar_dote_Disable"];
        [self addSubview:_controleSlide2];
        
    }
    return self;
}

#pragma mark - Public

- (void)resetCalendar{
    
    self.firstDay.selected = YES;
    
}

- (NSDate *)selectedDate{
    
    NSDate *date;
    
    if (self.currentSelected) {
        date = self.currentSelected.date;
    }
    
    return date;
    
}

- (void)changeTo:(NSDate *)date{
    
    for (int i = 0; i < [_arrayCell count]; i++) {
        
        UICanuCalendarButtonPicker *cell = [_arrayCell objectAtIndex:i];
        
        if ([cell.date mk_day] == [date mk_day] && [cell.date mk_month] == [date mk_month] && [cell.date mk_year] == [date mk_year]) {
            [self dayDidTouch:cell];
            return;
        }
        
    }
    
}

#pragma mark - Private

- (void)dayDidTouch:(UICanuCalendarButtonPicker *)day{
    
    if (_currentSelected != day) {
        self.currentSelected.selected = NO;
        _currentSelected = day;
    }
    
    if ([day.date mk_isToday] || [day.date mk_isTomorrow]) {
        [self.delegate calendarTouchTodayOrTomorrowDay:day.date];
    }
    
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

- (int)numberOfDayForTheCurrentMonth:(NSDate *)currentDate{
    
    NSCalendar *calCurrent = [NSCalendar currentCalendar];
    NSDateComponents *compsCurrent = [calCurrent components:NSMonthCalendarUnit fromDate:currentDate];
    
    NSRange range = [calCurrent rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calCurrent dateFromComponents:compsCurrent]];
    
    int numberOfDay = (int)range.length;
    
    return numberOfDay;
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float fractionalPage = scrollView.contentOffset.x/ 320.0f;
    NSInteger nearestNumberCurrent = lround(fractionalPage);
    
    if (nearestNumberCurrent == 0) {
        self.controleSlide1.image = [UIImage imageNamed:@"F1_Calendar_dote_Enable"];
        self.controleSlide2.image = [UIImage imageNamed:@"F1_Calendar_dote_Disable"];
    } else {
        self.controleSlide1.image = [UIImage imageNamed:@"F1_Calendar_dote_Disable"];
        self.controleSlide2.image = [UIImage imageNamed:@"F1_Calendar_dote_Enable"];
    }
    
}

@end
