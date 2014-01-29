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

@property (strong, nonatomic) UIImageView *illustration;
@property (strong, nonatomic) UIImageView *illustration3;
@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) UILabel *text2;
@property (strong, nonatomic) TTTAttributedLabel *information;
@property (strong, nonatomic) TTTAttributedLabel *information2;
@property (strong, nonatomic) TTTAttributedLabel *information3;
@property (strong, nonatomic) UIProfileView *profileView;

@end

@implementation TutorialStepProfile

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.illustration = [[UIImageView alloc]initWithFrame:CGRectMake(320, (self.frame.size.height - 480)/2, 320, 480)];
        self.illustration.image = [UIImage imageNamed:@"Tutorial_Step3"];
        self.illustration.alpha = 0;
        [self addSubview:_illustration];
        
        self.illustration3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height - 480)/2, 320, 480)];
        self.illustration3.image = [UIImage imageNamed:@"Tutorial_Step5"];
        self.illustration3.alpha = 0;
        [self addSubview:_illustration3];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(30 + 320,  (self.frame.size.height - 480)/2 + 190, 260, 180)];
        self.text.backgroundColor = [UIColor clearColor];
        self.text.textColor = [UIColor whiteColor];
        self.text.numberOfLines = 3;
        self.text.textAlignment= NSTextAlignmentCenter;
        self.text.font = [UIFont fontWithName:@"Lato-Bold" size:19];
        self.text.text = NSLocalizedString(@"These are the activities you are going to.", nil);
        self.text.alpha = 0;
        [self addSubview:_text];
        
        self.text2 = [[UILabel alloc]initWithFrame:CGRectMake( 30,  (self.frame.size.height - 480)/2 + 190 + 119, 260, 180)];
        self.text2.backgroundColor = [UIColor clearColor];
        self.text2.textColor = [UIColor whiteColor];
        self.text2.numberOfLines = 3;
        self.text2.textAlignment= NSTextAlignmentCenter;
        self.text2.font = [UIFont fontWithName:@"Lato-Bold" size:19];
        self.text2.text = NSLocalizedString(@"This is you.", nil);
        self.text2.alpha = 0;
        [self addSubview:_text2];
        
        self.information = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(320, (self.frame.size.height - 480)/2 + 350, 320, 20)];
        self.information.text = NSLocalizedString(@"Tap the white box", nil);
        self.information.textColor = [UIColor whiteColor];
        self.information.font = [UIFont fontWithName:@"Lato-LightItalic" size:15];
        self.information.textAlignment = NSTextAlignmentCenter;
        self.information.backgroundColor = [UIColor clearColor];
        self.information.alpha = 0;
        [self addSubview:_information];
        
        self.information2 = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake( 0,(self.frame.size.height - 480)/2 + 320 + 119, 320, 20)];
        self.information2.text = NSLocalizedString(@"Tap again", nil);
        self.information2.textColor = [UIColor whiteColor];
        self.information2.font = [UIFont fontWithName:@"Lato-LightItalic" size:15];
        self.information2.textAlignment = NSTextAlignmentCenter;
        self.information2.backgroundColor = [UIColor clearColor];
        self.information2.alpha = 0;
        [self addSubview:_information2];
        
        self.information3 = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake( 0, (self.frame.size.height - 480)/2 + 350, 320, 20)];
        self.information3.text = NSLocalizedString(@"Move the white box up", nil);
        self.information3.textColor = [UIColor whiteColor];
        self.information3.font = [UIFont fontWithName:@"Lato-LightItalic" size:15];
        self.information3.textAlignment = NSTextAlignmentCenter;
        self.information3.backgroundColor = [UIColor clearColor];
        self.information3.alpha = 0;
        [self addSubview:_information3];
        
        [self.information setText:self.information.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Tap", nil) options:NSCaseInsensitiveSearch];
            
            UIFont *boldSystemFont = [UIFont fontWithName:@"Lato-BoldItalic" size:15];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
            
            return mutableAttributedString;
            
        }];
        
        [self.information2 setText:self.information2.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Tap", nil) options:NSCaseInsensitiveSearch];
            
            UIFont *boldSystemFont = [UIFont fontWithName:@"Lato-BoldItalic" size:15];
            CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            if (font) {
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                CFRelease(font);
            }
            
            return mutableAttributedString;
            
        }];
        
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
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.illustration.alpha = 1;
            self.illustration.frame = CGRectMake( 0, (self.frame.size.height - 480)/2, 320, 480);
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.text.alpha = 1;
            self.text.frame = CGRectMake( 30, (self.frame.size.height - 480)/2 + 190, 260, 180);
        } completion:nil];
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.information.alpha = 1;
            self.information.frame = CGRectMake( 0, (self.frame.size.height - 480)/2 + 350, 320, 20);
        } completion:nil];
        
    }
    return self;
}

- (void)animationStartProfileView{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.profileView = [[UIProfileView alloc] initWithUser:appDelegate.user WithBottomBar:NO AndNavigationchangement:NO OrTutorial:YES];
    [self addSubview:_profileView];
    
    [self.profileView hideComponents:YES];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.illustration.alpha = 0;
        self.illustration.frame = CGRectMake( 0, (self.frame.size.height - 480)/2 - 119, 320, 480);
        self.text.alpha = 0;
        self.text.frame = CGRectMake( 30,  (self.frame.size.height - 480)/2 + 190 - 119, 260, 180);
        self.information.alpha = 0;
        self.information.frame = CGRectMake( 0, (self.frame.size.height - 480)/2 + 350 - 119, 320, 20);
        self.information2.alpha = 1;
        self.information2.frame = CGRectMake( 0, (self.frame.size.height - 480)/2 + 320, 320, 20);
        self.text2.alpha = 1;
        self.text2.frame = CGRectMake( 30, (self.frame.size.height - 480)/2 + 160, 260, 180);
    } completion:nil];
    
}

- (void)animationStartProfileViewDisappear{
    
    [self.profileView hideComponents:NO];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.information2.alpha = 0;
        self.information2.frame = CGRectMake( 0, (self.frame.size.height - 480)/2 + 320 + 119, 320, 20);
        self.text2.alpha = 0;
        self.text2.frame = CGRectMake( 30, (self.frame.size.height - 480)/2 + 190 + 119, 260, 180);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.information3.alpha = 1;
            self.illustration3.alpha = 1;
        } completion:^(BOOL finished) {
            [self.profileView removeFromSuperview];
            self.profileView = nil;
        }];
        [self.profileView removeFromSuperview];
        self.profileView = nil;
    }];
}

@end
