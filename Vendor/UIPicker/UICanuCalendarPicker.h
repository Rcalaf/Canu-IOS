//
//  UICanuCalendarPicker.h
//  CANU
//
//  Created by Vivien Cormier on 12/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuCalendarPicker : UIView

@property (retain) id delegate;

- (void)resetCalendar;

- (NSDate *)selectedDate;

@end

@protocol UICanuCalendarPickerDelegate <NSObject>

@required
- (void)calendarTouchTodayOrTomorrowDay:(NSDate *)date;
@end
