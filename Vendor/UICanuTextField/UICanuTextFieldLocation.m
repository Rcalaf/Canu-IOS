//
//  UICanuTextFieldLocation.m
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextFieldLocation.h"

@implementation UICanuTextFieldLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activeSearch = YES;
        
    }
    return self;
}

- (void)setActiveSearch:(BOOL)activeSearch{
    
    if (activeSearch) {
        self.textColor = UIColorFromRGB(0xabb3b7);
    } else {
        self.textColor = UIColorFromRGB(0x2b4b58);
    }
    
}

@end
