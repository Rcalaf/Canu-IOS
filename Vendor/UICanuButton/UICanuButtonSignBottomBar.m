//
//  UICanuButtonSignBottomBar.m
//  CANU
//
//  Created by Vivien Cormier on 13/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuButtonSignBottomBar.h"

@implementation UICanuButtonSignBottomBar

- (id)initWithFrame:(CGRect)frame andBlue:(BOOL)isBlue
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12.0];
        
        if (isBlue) {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
        }else{
            [self setTitleColor:[UIColor colorWithRed:109.0/256.0 green:110.0/256.0 blue:122.0/256.0 alpha:1.0] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 1]];
        }
        
    }
    return self;
}

@end
