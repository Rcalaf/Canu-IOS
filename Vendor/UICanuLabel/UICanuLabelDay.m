//
//  UICanuLabelDay.m
//  CANU
//
//  Created by Vivien Cormier on 10/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelDay.h"

@implementation UICanuLabelDay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font            = [UIFont fontWithName:@"Lato-Regular" size:10.0];
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
        self.textColor       = UIColorFromRGB(0x2b4b58);
        
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat       = @"d MMM";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    self.text = [dateFormatter stringFromDate:date];
    
}

@end
