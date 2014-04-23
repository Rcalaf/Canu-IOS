//
//  UICanuBottomBar.m
//  CANU
//
//  Created by Vivien Cormier on 18/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuBottomBar.h"

@interface UICanuBottomBar ()

@property (nonatomic, strong) UIImageView *backgroundImage;

@end

@implementation UICanuBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.backgroundImage = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"All_bottom_bar_background"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0]];
        self.backgroundImage.frame = CGRectMake(0, -2, frame.size.width, 47);
        [self addSubview:_backgroundImage];
        
        UIView *marginForBounce = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height * 2)];
        marginForBounce.backgroundColor = [UIColor whiteColor];
        [self addSubview:marginForBounce];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    self.backgroundImage.frame = CGRectMake(0, -2, frame.size.width, 47);
    
}

@end
