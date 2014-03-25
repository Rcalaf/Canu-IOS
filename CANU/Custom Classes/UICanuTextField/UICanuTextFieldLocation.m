//
//  UICanuTextFieldLocation.m
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextFieldLocation.h"

@interface UICanuTextFieldLocation () <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *resetSearch;

@end

@implementation UICanuTextFieldLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        
        self.activeSearch = YES;
        
        self.activeReset = NO;
        
        UIImageView *imgClose = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 47, 47)];
        imgClose.image = [UIImage imageNamed:@"F1_input_Location_reset"];
        
        self.resetSearch = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 47, 47)];
        [self.resetSearch addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchDown];
        self.resetSearch.backgroundColor = [UIColor whiteColor];
        self.resetSearch.clipsToBounds = YES;
        [self.resetSearch addSubview:imgClose];
        
    }
    return self;
}

- (void)setActiveReset:(BOOL)activeReset{
    NSLog(@"Reset");
    _activeReset = activeReset;
    
    if (activeReset) {
        self.rightView = _resetSearch;
    } else {
        self.rightView = nil;
    }
    
}

- (void)setActiveSearch:(BOOL)activeSearch{
    
    _activeSearch = activeSearch;
    
    if (activeSearch) {
        self.textColor = UIColorFromRGB(0xabb3b7);
        NSLog(@"Active Search");
    } else {
        self.textColor = UIColorFromRGB(0x2b4b58);
        NSLog(@"Not Active Search");
    }
    
}

- (void)reset{
    self.text = @"";
    self.activeReset = NO;
    self.activeSearch = YES;
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
