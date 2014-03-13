//
//  UICanuTextFieldReset.m
//  CANU
//
//  Created by Vivien Cormier on 25/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextFieldReset.h"

@interface UICanuTextFieldReset () <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *resetInput;

@end

@implementation UICanuTextFieldReset

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        
        self.activeReset = NO;
        
        UIImageView *imgClose = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 47, 47)];
        imgClose.image = [UIImage imageNamed:@"F1_input_Location_reset"];
        
        self.resetInput = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 47, 47)];
        [self.resetInput addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchDown];
        self.resetInput.backgroundColor = [UIColor whiteColor];
        self.resetInput.clipsToBounds = YES;
        [self.resetInput addSubview:imgClose];
        
    }
    return self;
}

- (void)setActiveReset:(BOOL)activeReset{
    
    _activeReset = activeReset;
    
    if (activeReset) {
        self.rightView = _resetInput;
    } else {
        self.rightView = nil;
    }
    
}

- (void)reset{
    self.text = @"";
    self.activeReset = NO;
}

- (BOOL)becomeFirstResponder{
    
    BOOL returnValue = [super becomeFirstResponder];
    if (returnValue){
        if (![self.text isEqualToString:@""]) {
            self.activeReset = YES;
        }
    }
    return returnValue;
}

- (BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        self.activeReset = NO;
    }
    return returnValue;
}

@end
