//
//  UICanuLabelActivityName.m
//  CANU
//
//  Created by Vivien Cormier on 10/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelActivityName.h"

@implementation UICanuLabelActivityName

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font            = [UIFont fontWithName:@"Lato-Bold" size:23.0];
        self.backgroundColor = [UIColor clearColor];
        self.textColor       = UIColorFromRGB(0x2b4b58);
        
    }
    return self;
}

@end
