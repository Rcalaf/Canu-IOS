//
//  SignUpStep1.h
//  CANU
//
//  Created by Vivien Cormier on 15/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICanuTextField;

@interface SignUpStep1 : UIView

@property (retain) id delegate;

@property (nonatomic) UICanuTextField *userName;
@property (nonatomic) UICanuTextField *password;

- (void)openAnimation;

@end

@protocol SignUpStep1Delegate <NSObject>

@required
- (void)openTerms;
- (void)openPrivacyPolicy;
- (void)signUpStep1CheckUsername;
- (void)signUpStep1textFieldShouldAppear;
@end
