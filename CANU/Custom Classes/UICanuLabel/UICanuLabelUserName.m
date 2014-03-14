//
//  UICanuLabelUserName.m
//  CANU
//
//  Created by Vivien Cormier on 10/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelUserName.h"

@implementation UICanuLabelUserName

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font            = [UIFont fontWithName:@"Lato-Bold" size:13.0];
        self.backgroundColor = UIColorFromRGB(0xf9f9f9);
        self.textColor       = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
    }
    return self;
}

@end
