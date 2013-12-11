//
//  UIScrollViewReverse.m
//  CANU
//
//  Created by Vivien Cormier on 11/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UIScrollViewReverse.h"

@implementation UIScrollViewReverse

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (CGPoint)contentOffset{
//    
//    return c
//    
//}

- (void)setContentOffsetReverse:(CGPoint)contentOffset{
    
    float newX,newY;
    
    newX = contentOffset.x;
    newY = self.contentSize.height - (self.frame.size.height + contentOffset.y);
    
    self.contentOffset = CGPointMake(newX, newY);
    
}

@end
