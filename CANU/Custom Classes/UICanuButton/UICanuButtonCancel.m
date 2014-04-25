//
//  UICanuButtonCancel.m
//  CANU
//
//  Created by Vivien Cormier on 19/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuButtonCancel.h"

@interface UICanuButtonCancel ()

@property (nonatomic, strong) UIImageView *backgroundButton;
@property (nonatomic, strong) UILabel *titleButton;

@end

@implementation UICanuButtonCancel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.titleLabel.textColor = [UIColor clearColor];
        
        [self setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        
        self.backgroundButton = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"All_button_red_normal"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0]];
        [self addSubview:_backgroundButton];
        
        self.titleButton = [[UILabel alloc]init];
        self.titleButton.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.titleButton.textAlignment = NSTextAlignmentCenter;
        self.titleButton.textColor = [UIColor whiteColor];
        self.titleButton.backgroundColor = [UIColor clearColor];
        self.titleButton.text = NSLocalizedString(@"Cancel", nil);
        [self addSubview:_titleButton];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    [super setTitle:title forState:state];
    
    self.titleButton.text = title;
    
}

- (void)detectSize{
    
    [self sizeToFit];
    
    self.maxWidth = 20 + self.frame.size.width;
    self.frame = CGRectMake(self.frame.origin.x - _maxWidth - 5, self.frame.origin.y, _maxWidth, 33);
    
    self.titleButton.frame = CGRectMake(0, 0, _maxWidth, 33);
    
    self.backgroundButton.frame = CGRectMake(0, 0, _maxWidth, 33);
    
}

@end
