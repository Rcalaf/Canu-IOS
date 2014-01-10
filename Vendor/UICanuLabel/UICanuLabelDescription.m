//
//  UICanuLabelDescription.m
//  CANU
//
//  Created by Vivien Cormier on 10/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelDescription.h"

@implementation UICanuLabelDescription

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.font            = [UIFont fontWithName:@"Lato-Regular" size:12.0];
        self.numberOfLines   = 2;
        self.textColor       = UIColorFromRGB(0x2b4b58);
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

@end
