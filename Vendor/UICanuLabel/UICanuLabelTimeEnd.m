//
//  UICanuLabelTimeEnd.m
//  CANU
//
//  Created by Vivien Cormier on 10/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelTimeEnd.h"

@implementation UICanuLabelTimeEnd

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font            = [UIFont fontWithName:@"Lato-Italic" size:11.0];
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
        self.textColor       = UIColorFromRGB(0x2b4b58);
        self.textAlignment   = NSTextAlignmentLeft;
        self.alpha           = 0.5;
        
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    
    if ([self timeIs24HourFormat]) {
        timeFormatter.dateFormat = @"HH:mm";
    } else {
        timeFormatter.dateFormat = @"hh:mm a";
    }
    
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    self.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:date]];
    
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
