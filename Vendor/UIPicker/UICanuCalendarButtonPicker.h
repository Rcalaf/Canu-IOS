//
//  UICanuCalendarButtonPicker.h
//  CANU
//
//  Created by Vivien Cormier on 12/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CANUCalendarButtonType) {
    CANUCalendarButtonOff = 0,
    CANUCalendarButtonWithMonth = 1,
    CANUCalendarButtonNone = 2
};

@interface UICanuCalendarButtonPicker : UIView

@property (retain) id delegate;

@property (nonatomic) BOOL selected;

@property (strong, nonatomic) NSDate *date;

- (id)initWithFrame:(CGRect)frame Date:(NSDate *)date Type:(CANUCalendarButtonType)canuCalendarButtonType;

@end

@protocol UICanuCalendarButtonPickerDelegate <NSObject>

@required
- (void)dayDidTouch:(UICanuCalendarButtonPicker *)day;
@end
