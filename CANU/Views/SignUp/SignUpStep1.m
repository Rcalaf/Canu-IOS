//
//  SignUpStep1.m
//  CANU
//
//  Created by Vivien Cormier on 15/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "SignUpStep1.h"

#import "UICanuTextField.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SignUpStep1 () <UITextFieldDelegate,UIWebViewDelegate>

@property (nonatomic) BOOL userStartForm;
@property (nonatomic) UIWebView *termsPrivacy;

@end

@implementation SignUpStep1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userStartForm = NO;
        
        UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        title1.text = NSLocalizedString(@"Create Account", nil);
        title1.textAlignment = NSTextAlignmentCenter;
        title1.backgroundColor = [UIColor clearColor];
        title1.textColor = UIColorFromRGB(0x1ca6c3);
        title1.font = [UIFont fontWithName:@"Lato-Bold" size:24];
        [self addSubview:title1];
        
        self.termsPrivacy = [[UIWebView alloc]initWithFrame:CGRectMake(0, 50, 320, 20)];
        self.termsPrivacy.delegate = self;
        self.termsPrivacy.alpha = 0;
        self.termsPrivacy.backgroundColor = UIColorFromRGB(0xe8eeee);
        [self addSubview:_termsPrivacy];
        
        UIImageView *iconeUsername = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 47, 47)];
        iconeUsername.image = [UIImage imageNamed:@"icon_username"];
        [self addSubview:iconeUsername];
        
        self.userName = [[UICanuTextField alloc] initWithFrame:CGRectMake(57.5, 80, 252.5, 47.0)];
        self.userName.placeholder = NSLocalizedString(@"Username", nil);
        [self.userName setReturnKeyType:UIReturnKeyNext];
        self.userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.userName.delegate = self;
        [self addSubview:self.userName];
        
        UIImageView *iconePassword = [[UIImageView alloc]initWithFrame:CGRectMake(10, 128, 47, 47)];
        iconePassword.image = [UIImage imageNamed:@"icon_password"];
        [self addSubview:iconePassword];
        
        self.password = [[UICanuTextField alloc] initWithFrame:CGRectMake(57.5, 128, 252.5, 47.0)];
        self.password.placeholder = NSLocalizedString(@"Password", nil);
        [self.password setReturnKeyType:UIReturnKeyNext];
        self.password.secureTextEntry = YES;
        self.password.delegate = self;
        [self addSubview:self.password];
        
        [NSThread detachNewThreadSelector:@selector(addUIWebView)toTarget:self withObject:nil];
        
    }
    return self;
}

- (void)addUIWebView{
    [self.termsPrivacy loadHTMLString:[NSString stringWithFormat:@"<html><head><style type='text/css'>body,html,p{ margin:0px; padding:0px; background-color:#e8eeee; } p { text-align:center; font-family:\"Lato-Regular\"; font-size:9px; color: #1ca6c3;} a{ color:#ff0000; } a{ color:#1ca6c3; }</style></head><body><p>%@ <a href='http://terms/'>%@</a> %@ <a href='http://privacy/'>%@</a></p></body></html>",NSLocalizedString(@"By signing up I agree with the", nil),NSLocalizedString(@"Terms", nil),NSLocalizedString(@"and the", nil),NSLocalizedString(@"Privacy Policy", nil) ] baseURL:nil];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate signUpStep1textFieldShouldAppear];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (!_userStartForm) {
        
        self.userStartForm = YES;
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"Step1" value:nil] build]];
        
    }
    
    return YES;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSURL *url = [request URL];
        
        if ([url.absoluteString isEqualToString:@"http://terms/"]) {
            [self.delegate openTerms];
        }
        
        if ([url.absoluteString isEqualToString:@"http://privacy/"]) {
            [self.delegate openPrivacyPolicy];
        }
        
        return NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        webView.alpha = 1;
    } completion:nil];
}

- (void)openAnimation{
    [self.userName becomeFirstResponder];
}

@end
