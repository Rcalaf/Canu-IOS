//
//  UICanuButton.m
//  CANU
//
//  Created by Vivien Cormier on 18/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuButton.h"

@interface UICanuButton ()

@property (nonatomic) UICanuButtonStyle canuButtonStyle;
@property (nonatomic, strong) UIImageView *backgroundButton;
@property (nonatomic, strong) UILabel *titleButton;

@end

@implementation UICanuButton

- (id)initWithFrame:(CGRect)frame forStyle:(UICanuButtonStyle)canuButtonStyle{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.titleLabel.textColor = [UIColor clearColor];
        
        self.backgroundButton = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"All_button_red_normal"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0]];
        [self addSubview:_backgroundButton];
        
        self.titleButton = [[UILabel alloc]init];
        self.titleButton.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.titleButton.textColor = [UIColor whiteColor];
        self.titleButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleButton];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    [super setTitle:title forState:state];
    
    self.titleButton.frame = CGRectMake((self.frame.size.width - self.titleLabel.frame.size.width)/2, 0, self.titleLabel.frame.size.width, self.frame.size.height);
    
    self.titleButton.text = title;
    
    float maxWidth = self.titleLabel.frame.size.width + 40;
    
    if (maxWidth > self.frame.size.width) {
        maxWidth = self.frame.size.width;
    }
    
    self.backgroundButton.frame = CGRectMake((self.frame.size.width - maxWidth )/2, 0, maxWidth, self.frame.size.height);
    
}

@end
