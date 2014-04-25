//
//  TutorialPopUp.m
//  CANU
//
//  Created by Vivien Cormier on 23/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "TutorialPopUp.h"

#import "UICanuButton.h"

@interface TutorialPopUp ()

@property (strong, nonatomic) UICanuButton *button;
@property (strong, nonatomic) UIImageView *arrow;
@property (nonatomic) TutorialStep stepTutorial;
@property (strong, nonatomic) UILabel *message;
@property (strong, nonatomic) UILabel *title;

@end

@implementation TutorialPopUp

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.stepTutorial = TutorialStepTribes;
        
        UIImageView *backgoundImage = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 284, 114)];
        backgoundImage.image = [[UIImage imageNamed:@"T_background_popup"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        [self addSubview:backgoundImage];
        
        self.arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"T_Arrow"]];
        self.arrow.frame = CGRectMake((self.frame.size.width - 11) / 2, 109, 11, 6);
        [self addSubview:_arrow];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, 280, 30)];
        self.title.font = [UIFont fontWithName:@"Lato-Bold" size:13];
        self.title.text = NSLocalizedString(@"Tribes", nil);
        self.title.textColor = UIColorFromRGB(0x2b4b58);
        self.title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
        
        self.message = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 280, 25)];
        self.message.numberOfLines = 2;
        self.message.font = [UIFont fontWithName:@"Lato-Regular" size:13];
        self.message.text = NSLocalizedString(@"Activities you are invited to", nil);
        self.message.textColor = UIColorFromRGB(0x2b4b58);
        self.message.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_message];
        
        self.button = [[UICanuButton alloc]initWithFrame:CGRectMake(0, 30 + 25 + 5, 280, 37) forStyle:UICanuButtonStyleLarge];
        [self.button setTitle:NSLocalizedString(@"Got it", nil) forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_button];
        
    }
    return self;
}

#pragma mark - Public

- (void)popUpGoToPosition:(TutorialStep)step{
    
    self.stepTutorial = step;
    
    if (step == TutorialStepLocal) {
        self.arrow.frame = CGRectMake(9, 109, 11, 6);
        self.message.text = NSLocalizedString(@"Activities around you", nil);
        self.title.text = NSLocalizedString(@"Local", nil);
    } else if (step == TutorialStepProfile) {
        self.arrow.frame = CGRectMake(262, 109, 11, 6);
        self.message.text = NSLocalizedString(@"Your schedule", nil);
        self.title.text = NSLocalizedString(@"Profile", nil);
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)changeToCreate{
    self.arrow.alpha = 0;
    self.message.text = NSLocalizedString(@"It's how you create an activity", nil);
    self.title.text = NSLocalizedString(@"New activity", nil);
}

#pragma mark - Private

- (void)next{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.delegate nextStep];
    }];
    
}

@end
