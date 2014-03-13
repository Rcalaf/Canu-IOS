//
//  TutorialStepStart.m
//  CANU
//
//  Created by Vivien Cormier on 21/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "TutorialStepStart.h"

#import "UICanuButtonSignBottomBar.h"

@implementation TutorialStepStart

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, (self.frame.size.height - 480)/2 + 80, 300, 35)];
        title.textColor = UIColorFromRGB(0x16a1bf);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.text = NSLocalizedString(@"Welcome", nil);
        title.font = [UIFont fontWithName:@"Lato-Bold" size:32];
        [self addSubview:title];
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(50, (self.frame.size.height - 480)/2 + 200, 220, 80)];
        text.textColor = UIColorFromRGB(0x16a1bf);
        text.textAlignment = NSTextAlignmentCenter;
        text.numberOfLines = 3;
        text.backgroundColor = [UIColor clearColor];
        text.text = NSLocalizedString(@"Let’s see where your upcoming activities are.", nil);
        text.font = [UIFont fontWithName:@"Lato-Regular" size:19];
        [self addSubview:text];
        
        UICanuButtonSignBottomBar *next = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(80, (self.frame.size.height - 480)/2 + 400, 160, 37) andBlue:YES];
        [next addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchDown];
        [next setTitle:NSLocalizedString(@"SURE", nil) forState:UIControlStateNormal];
        [self addSubview:next];
        
    }
    return self;
}

- (void)nextStep{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.delegate tutorialStepStartNext];
    }];
    
}

@end
