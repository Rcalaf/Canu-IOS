//
//  UICanuTextFieldLine.m
//  CANU
//
//  Created by Vivien Cormier on 08/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextFieldLine.h"

@interface UICanuTextFieldLine ()

@property (strong, nonatomic) UIView *line;

@end

@implementation UICanuTextFieldLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textColor = UIColorFromRGB(0x2b4b58);
        self.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        
        self.line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2 + 15, frame.size.width, 1)];
        self.line.backgroundColor = UIColorFromRGB(0x2b4b58);
        self.line.alpha = 0.16f;
        [self addSubview:_line];
        
        if (IS_OS_7_OR_LATER) {
            [self setTintColor:UIColorFromRGB(0x2b4b58)];
        }
        
        self.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    self.line.frame = CGRectMake(0, frame.size.height/2 + 15, frame.size.width, 1);
}

- (void)setValueValide:(BOOL)valueValide{
    
    if (valueValide) {
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
    }else{
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
    }
    
}

@end
