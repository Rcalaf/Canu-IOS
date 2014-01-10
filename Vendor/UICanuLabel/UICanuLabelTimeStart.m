//
//  UICanuLabelTimeStart.m
//  CANU
//
//  Created by Vivien Cormier on 10/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelTimeStart.h"

@implementation UICanuLabelTimeStart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font            = [UIFont fontWithName:@"Lato-Bold" size:11.0];
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
        self.textColor       = UIColorFromRGB(0x2b4b58);
        
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
    timeFormatter.dateFormat       = @"HH:mm";
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    self.text = [timeFormatter stringFromDate:date];
    
}

@end
