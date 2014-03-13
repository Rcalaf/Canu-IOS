//
//  TutorialStepProfile.m
//  CANU
//
//  Created by Vivien Cormier on 21/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "TutorialStepProfile.h"

#import "TTTAttributedLabel.h"
#import "UIProfileView.h"
#import "AppDelegate.h"

@interface TutorialStepProfile ()

@property (strong, nonatomic) UIImageView *illustration3;
@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) TTTAttributedLabel *information3;
@property (strong, nonatomic) UIProfileView *profileView;

@end

@implementation TutorialStepProfile

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.illustration3 = [[UIImageView alloc]initWithFrame:CGRectMake(320, (self.frame.size.height - 480)/2, 320, 480)];
        self.illustration3.image = [UIImage imageNamed:@"Tutorial_Step3"];
        self.illustration3.alpha = 0;
        [self addSubview:_illustration3];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(30 + 320,  (self.frame.size.height - 480)/2 + 150, 260, 180)];
        self.text.backgroundColor = [UIColor clearColor];
        self.text.textColor = [UIColor whiteColor];
        self.text.numberOfLines = 3;
        self.text.textAlignment= NSTextAlignmentCenter;
        self.text.font = [UIFont fontWithName:@"Lato-Bold" size:19];
        self.text.text = NSLocalizedString(@"These are the activities you are going to.", nil);
        self.text.alpha = 0;
        [self addSubview:_text];
        
        self.information3 = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake( 320, (self.frame.size.height - 480)/2 + 310, 320, 20)];
        self.information3.text = NSLocalizedString(@"Move the white box up", nil);
        self.information3.textColor = [UIColor whiteColor];
        self.information3.font = [UIFont fontWithName:@"Lato-LightItalic" size:15];
        self.information3.textAlignment = NSTextAlignmentCenter;
        self.information3.backgroundColor = [UIColor clearColor];
        self.information3.alpha = 0;
        [self addSubview:_information3];
        
        [self.information3 setText:self.information3.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Move", nil) options:NSCaseInsensitiveSearch];
            
            UIFont *boldSystemFont = [UIFont fontWithName:@"Lato-BoldItalic" size:15];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
            
            return mutableAttributedString;
            
        }];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        
        self.profileView = [[UIProfileView alloc] initWithFrame:CGRectMake(320, self.frame.size.height - 119, 320, 119) User:appDelegate.user];
        self.profileView.userInteractionEnabled = NO;
        self.profileView.alpha = 0;
        [self addSubview:_profileView];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.illustration3.alpha = 1;
            self.illustration3.frame = CGRectMake( 0, (self.frame.size.height - 480)/2, 320, 480);
            self.profileView.frame = CGRectMake(0, self.frame.size.height - 119, 320, 119);
            self.profileView.alpha = 1;
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.text.alpha = 1;
            self.text.frame = CGRectMake( 30, (self.frame.size.height - 480)/2 + 150, 260, 180);
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.information3.alpha = 1;
            self.information3.frame = CGRectMake( 0, (self.frame.size.height - 480)/2 + 310, 320, 20);
        } completion:nil];
        
    }
    return self;
}

@end
