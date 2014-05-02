//
//  UICanuTextFieldLine.m
//  CANU
//
//  Created by Vivien Cormier on 08/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextFieldLine.h"

@interface UICanuTextFieldLine ()

@property (nonatomic) BOOL positionTop;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *animatePlaceHolder;

@end

@implementation UICanuTextFieldLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.disablePlaceHolderAnimate = NO;
        
        self.textColor = UIColorFromRGB(0x2b4b58);
        self.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        
        self.line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2 + 15, frame.size.width, 1)];
        self.line.backgroundColor = UIColorFromRGB(0x2b4b58);
        self.line.alpha = 0.16f;
        [self addSubview:_line];
        
        self.animatePlaceHolder = [[UILabel alloc]initWithFrame:CGRectMake(self.leftView.frame.size.width, 0, frame.size.width, frame.size.height / 3)];
        self.animatePlaceHolder.font = [UIFont fontWithName:@"Lato-Regular" size:10.0];
        self.animatePlaceHolder.alpha = 0;
        self.animatePlaceHolder.textColor = UIColorFromRGB(0x2b4b58);
        [self addSubview:_animatePlaceHolder];
        
        if (IS_OS_7_OR_LATER) {
            [self setTintColor:UIColorFromRGB(0x2b4b58)];
        }
        
        self.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
    
}

#pragma mark - Public

- (void)textChange:(NSString *)text{
    
    if ([text isEqualToString:@""]) {
        [UIView animateWithDuration:0.4 animations:^{
            [self positionTop:NO];
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            [self positionTop:YES];
        }];
    }
    
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    self.line.frame = CGRectMake(0, frame.size.height/2 + 15, frame.size.width, 1);
}

- (void)setValueValide:(BOOL)valueValide{
    
    if (valueValide) {
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
    } else {
        self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
    }
    
}

- (void)setPlaceholder:(NSString *)placeholder{
    
    [super setPlaceholder:placeholder];
    
    self.animatePlaceHolder.text = placeholder;
    
    if (![self.text isEqualToString:@""]) {
        [UIView animateWithDuration:0.4 animations:^{
            [self positionTop:YES];
        }];
    }
    
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    if (![self.animatePlaceHolder.text isEqualToString:@""]) {
        [self positionTop:YES];
    }
    
    if ([text isEqualToString:@""]) {
        [UIView animateWithDuration:0.4 animations:^{
            [self positionTop:NO];
        }];
    }
    
}

- (void)setDisablePlaceHolderAnimate:(BOOL)disablePlaceHolderAnimate{
    
    if (disablePlaceHolderAnimate) {
        self.animatePlaceHolder.hidden = YES;
    } else {
        self.animatePlaceHolder.hidden = NO;
    }
    
}

- (BOOL)becomeFirstResponder{
    
    BOOL returnValue = [super becomeFirstResponder];
    if (returnValue){
        
    }
    return returnValue;
}

- (BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        
    }
    return returnValue;
}

#pragma mark - Private

- (void)positionTop:(BOOL)top{
    
    if (top) {
        self.animatePlaceHolder.alpha = 0.3;
    } else {
        self.animatePlaceHolder.alpha = 0;
    }
    
}

@end
