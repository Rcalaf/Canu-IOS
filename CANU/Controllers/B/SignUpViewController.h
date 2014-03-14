//
//  SignUpViewController.h
//  CANU
//
//  Created by Vivien Cormier on 13/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (nonatomic) BOOL isForCheckPhoneNumber;
@property (retain) id delegate;

- (id)initForCheckPhonenumber:(BOOL)isForCheckPhoneNumber;

@end

@protocol SignUpViewControllerDelegate <NSObject>

@required
- (void)signUpGoBackHome;
- (void)checkPhoneNumberDidAppear;
- (void)checkPhoneNumberDidDisappear;
@end
