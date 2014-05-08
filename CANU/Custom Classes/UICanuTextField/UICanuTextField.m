//
//  UICanuTextField.m
//  CANU
//
//  Created by Roger Calaf on 16/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuTextField.h"

@implementation UICanuTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, frame.size.height)];
        self.leftView = paddingView;
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textColor = UIColorFromRGB(0x2b4b58);
        self.rightViewMode = UITextFieldViewModeAlways;
        if (IS_OS_7_OR_LATER) {
            [self setTintColor:UIColorFromRGB(0x2b4b58)];
        }
    }
    return self;
}

- (void)setValueValide:(BOOL)valueValide{
    
    if (valueValide) {
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
    }else{
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
    }
    
}

@end
