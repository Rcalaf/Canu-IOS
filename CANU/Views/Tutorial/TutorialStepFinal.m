//
//  TutorialStepFinal.m
//  CANU
//
//  Created by Vivien Cormier on 22/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "TutorialStepFinal.h"

#import "UICanuButtonSignBottomBar.h"

@implementation TutorialStepFinal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30, (self.frame.size.height - 480)/2 + 80, 260, 60)];
        title.textColor = UIColorFromRGB(0x16a1bf);
        title.numberOfLines = 3;
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.text = NSLocalizedString(@"That’s how you instantly create an activity.", nil);
        title.font = [UIFont fontWithName:@"Lato-Bold" size:20];
        [self addSubview:title];
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(50, (self.frame.size.height - 480)/2 + 200, 220, 80)];
        text.textColor = UIColorFromRGB(0x16a1bf);
        text.textAlignment = NSTextAlignmentCenter;
        text.numberOfLines = 3;
        text.backgroundColor = [UIColor clearColor];
        text.text = NSLocalizedString(@"We’re all done. Enjoy.", nil);
        text.font = [UIFont fontWithName:@"Lato-Regular" size:19];
        [self addSubview:text];
        
        UICanuButtonSignBottomBar *next = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(80, (self.frame.size.height - 480)/2 + 400, 160, 37) andBlue:YES];
        [next addTarget:self action:@selector(endStep) forControlEvents:UIControlEventTouchDown];
        [next setTitle:NSLocalizedString(@"GOT IT", nil) forState:UIControlStateNormal];
        [self addSubview:next];
        
    }
    return self;
}

- (void)endStep{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.delegate tutorialStepFinalEnd];
    }];
}

@end
