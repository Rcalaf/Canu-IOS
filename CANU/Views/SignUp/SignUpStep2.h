//
//  SignUpStep2.h
//  CANU
//
//  Created by Vivien Cormier on 15/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICanuTextField,SignUpViewController;

@interface SignUpStep2 : UIView

@property (retain) id delegate;
@property (nonatomic) UIButton *takePictureButton;
@property (nonatomic) UICanuTextField *name;
@property (nonatomic) UICanuTextField *email;

- (id)initWithFrame:(CGRect)frame AndParentViewController:(SignUpViewController *)parentViewController;

@end

@protocol SignUpStep2Delegate <NSObject>

@required
- (void)signUpUser;
- (void)signUpStep2textFieldShouldAppear;
- (void)signUpStep2textFieldShouldDisappear;
@end
