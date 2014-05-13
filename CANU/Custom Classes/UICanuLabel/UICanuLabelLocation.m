//
//  UICanuLabelLocation.m
//  CANU
//
//  Created by Vivien Cormier on 10/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelLocation.h"

@implementation UICanuLabelLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *pin = [[UIImageView alloc]initWithFrame:CGRectMake(-12, 0, 30, 30)];
        pin.image = [UIImage imageNamed:@"C_pins"];
        [self addSubview:pin];
        
        self.font            = [UIFont fontWithName:@"Lato-Regular" size:10.0];
        self.backgroundColor = [UIColor clearColor];
        self.textColor       = UIColorFromRGB(0x829096);
        
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 11, 0, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
