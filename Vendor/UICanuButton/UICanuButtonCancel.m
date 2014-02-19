//
//  UICanuButtonCancel.m
//  CANU
//
//  Created by Vivien Cormier on 19/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuButtonCancel.h"

@implementation UICanuButtonCancel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
        [self setTitleColor:UIColorFromRGB(0xabb3b7) forState:UIControlStateNormal];
    }
    return self;
}

- (void)detectSize{
    
    [self sizeToFit];
    
    self.maxWidth = 20 + self.frame.size.width;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 47);
    
}

@end
