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
        self.font            = [UIFont fontWithName:@"Lato-Bold" size:14.0];
        self.textColor       = UIColorFromRGB(0x2b4b58);
    }
    return self;
}

@end
