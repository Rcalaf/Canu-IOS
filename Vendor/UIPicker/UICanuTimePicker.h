//
//  UICanuTimePicker.h
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuTimePicker : UIView

- (NSDate *)selectedTime;

- (void)changeTo:(NSDate *)date;

- (void)isToday:(BOOL)blockedValue;

@end
