//
//  ResetPassword.m
//  CANU
//
//  Created by Vivien Cormier on 07/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "ResetPassword.h"
#import "User.h"
#import "UICanuTextFieldLine.h"

@interface ResetPassword () <UITextFieldDelegate>

@property (strong, nonatomic) UICanuTextFieldLine *proxyPassword;
@property (strong, nonatomic) User *user;

@end

@implementation ResetPassword

- (id)initWithFrame:(CGRect)frame AndUser:(User *)user
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.user = user;
        
        UILabel *editProfileTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 320, 20)];
        editProfileTitle.text = NSLocalizedString(@"Edit your password", nil);
        editProfileTitle.textColor = UIColorFromRGB(0x2b4b58);
        editProfileTitle.font = [UIFont fontWithName:@"Lato-Regular" size:18];
        editProfileTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:editProfileTitle];
        
        self.backgroundColor = backgroundColorView;
        
        self.password = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 85, 280, 45)];
        self.password.placeholder = NSLocalizedString(@"New Password", nil);
        self.password.secureTextEntry = YES;
        [self.password setReturnKeyType:UIReturnKeyNext];
        self.password.delegate = self;
        [self addSubview:self.password];
        
        self.proxyPassword = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 85 + 5 + 45, 280, 45)];
        self.proxyPassword.placeholder = NSLocalizedString(@"Password Confirmation", nil);
        self.proxyPassword.secureTextEntry = YES;
        [self.proxyPassword setReturnKeyType:UIReturnKeyDone];
        self.proxyPassword.delegate = self;
        [self addSubview:self.proxyPassword];
        
        [self.password becomeFirstResponder];
        
    }
    return self;
}

#pragma mark - Public

- (void)updatePasswordBlock:(void (^)(User *user))block{
    
    self.password.rightView = nil;
    self.proxyPassword.rightView = nil;
    
    if ([self.password.text isEqualToString:_proxyPassword.text]) {
        
        [self.user editPassword:_password.text ForUser:self.user Block:^(User *user, NSError *error) {
            NSLog(@"%@",[error localizedRecoverySuggestion]);
            if (error && [[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                
                NSLog(@"editUser Error");
                
            } else {
                
                if (error && [[error localizedRecoverySuggestion] rangeOfString:@"proxy_password"].location != NSNotFound) {
                    self.proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                }else{
                    self.proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                }
                if (error && [[error localizedRecoverySuggestion] rangeOfString:@"password"].location != NSNotFound){
                    self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                }else{
                    self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                }
                
            }
            
            if (user) {
                if (block) {
                    block(user);
                } else {
                    block(nil);
                }
            }
        }];

    } else {
        if (!_password.text)  self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
        self.proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.password) {
        [self.password textChange:newString];
    } else if (textField == self.proxyPassword) {
        [self.proxyPassword textChange:newString];
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.password isFirstResponder]) {
        [self.proxyPassword becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
