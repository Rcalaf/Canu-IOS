//
//  TutorialStepTribes.m
//  CANU
//
//  Created by Vivien Cormier on 21/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "TutorialStepTribes.h"

#import "TTTAttributedLabel.h"

@interface TutorialStepTribes ()

@property (strong, nonatomic) UIImageView *illustration;
@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) TTTAttributedLabel *information;

@end

@implementation TutorialStepTribes

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.illustration = [[UIImageView alloc]initWithFrame:CGRectMake(320, (self.frame.size.height - 480)/2, 320, 480)];
        self.illustration.image = [UIImage imageNamed:@"Tutorial_Step2"];
        self.illustration.alpha = 0;
        [self addSubview:_illustration];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(30 + 320,  (self.frame.size.height - 480)/2 + 190, 260, 180)];
        self.text.backgroundColor = [UIColor clearColor];
        self.text.textColor = [UIColor whiteColor];
        self.text.numberOfLines = 3;
        self.text.textAlignment= NSTextAlignmentCenter;
        self.text.font = [UIFont fontWithName:@"Lato-Bold" size:19];
        self.text.text = NSLocalizedString(@"These are activities your friends don’t want you to miss.", nil);
        self.text.alpha = 0;
        [self addSubview:_text];
        
        self.information = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(320, (self.frame.size.height - 480)/2 + 350, 320, 20)];
        self.information.text = NSLocalizedString(@"Move the white box to the right", nil);
        self.information.textColor = [UIColor whiteColor];
        self.information.font = [UIFont fontWithName:@"Lato-LightItalic" size:15];
        self.information.textAlignment = NSTextAlignmentCenter;
        self.information.backgroundColor = [UIColor clearColor];
        self.information.alpha = 0;
        [self addSubview:_information];
        
        [self.information setText:self.information.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Move", nil) options:NSCaseInsensitiveSearch];
            
            UIFont *boldSystemFont = [UIFont fontWithName:@"Lato-BoldItalic" size:15];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
            
            return mutableAttributedString;
            
        }];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.illustration.alpha = 1;
            self.illustration.frame = CGRectMake(0, (self.frame.size.height - 480)/2, 320, 480);
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.text.alpha = 1;
            self.text.frame = CGRectMake(30,  (self.frame.size.height - 480)/2 + 190, 260, 180);
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.information.alpha = 1;
            self.information.frame = CGRectMake(0, (self.frame.size.height - 480)/2 + 350, 320, 20);
        } completion:nil];
        
    }
    return self;
}

- (void)animationEnd{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.illustration.alpha = 0;
        self.illustration.frame = CGRectMake(-320, (self.frame.size.height - 480)/2, 320, 480);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.text.alpha = 0;
        self.text.frame = CGRectMake(-320,  (self.frame.size.height - 480)/2 + 190, 260, 180);
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.information.alpha = 0;
        self.information.frame = CGRectMake(-320, (self.frame.size.height - 480)/2 + 350, 320, 20);
    } completion:nil];
    
}

@end
