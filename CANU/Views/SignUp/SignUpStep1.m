//
//  SignUpStep1.m
//  CANU
//
//  Created by Vivien Cormier on 15/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "SignUpStep1.h"

#import "UICanuTextField.h"
#import "TTTAttributedLabel.h"

@interface SignUpStep1 () <UITextFieldDelegate>

@end

@implementation SignUpStep1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        title1.text = NSLocalizedString(@"Create Account", nil);
        title1.textAlignment = NSTextAlignmentCenter;
        title1.backgroundColor = [UIColor clearColor];
        title1.textColor = UIColorFromRGB(0x1ca6c3);
        title1.font = [UIFont fontWithName:@"Lato-Bold" size:24];
        [self addSubview:title1];
        
        TTTAttributedLabel *termsAmdPrivacy = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 50, 320, 20)];
        termsAmdPrivacy.text = NSLocalizedString(@"By signing up I agree with the Terms and the Privacy Policy", nil);
        termsAmdPrivacy.textColor = UIColorFromRGB(0x1ca6c3);
        termsAmdPrivacy.font = [UIFont fontWithName:@"Lato-Regular" size:9];
        termsAmdPrivacy.textAlignment = NSTextAlignmentCenter;
        termsAmdPrivacy.backgroundColor = [UIColor clearColor];
        [self addSubview:termsAmdPrivacy];
        
        [termsAmdPrivacy setText:termsAmdPrivacy.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange termsRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Terms", nil) options:NSCaseInsensitiveSearch];
            NSRange privacyRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Privacy Policy", nil) options:NSCaseInsensitiveSearch];
            
            [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:termsRange];
            [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:privacyRange];
            
            return mutableAttributedString;
            
        }];
        
        UIImageView *iconeUsername = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 47, 47)];
        iconeUsername.image = [UIImage imageNamed:@"icon_username"];
        [self addSubview:iconeUsername];
        
        self.userName = [[UICanuTextField alloc] initWithFrame:CGRectMake(57.5, 80, 252.5, 47.0)];
        self.userName.placeholder = @"Username";
        [self.userName setReturnKeyType:UIReturnKeyNext];
        self.userName.delegate = self;
        [self addSubview:self.userName];
        
        UIImageView *iconePassword = [[UIImageView alloc]initWithFrame:CGRectMake(10, 128, 47, 47)];
        iconePassword.image = [UIImage imageNamed:@"icon_password"];
        [self addSubview:iconePassword];
        
        self.password = [[UICanuTextField alloc] initWithFrame:CGRectMake(57.5, 128, 252.5, 47.0)];
        self.password.placeholder = @"Password";
        [self.password setReturnKeyType:UIReturnKeyNext];
        self.password.secureTextEntry = YES;
        self.password.delegate = self;
        [self addSubview:self.password];
        
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _userName) {
        [self.userName resignFirstResponder];
        [self.password becomeFirstResponder];
    }else if (textField == _password){
        [self.delegate signUpStep1CheckUsername];
    }
    
    return YES;
    
}

- (void)openAnimation{
    [self.userName becomeFirstResponder];
}

@end
