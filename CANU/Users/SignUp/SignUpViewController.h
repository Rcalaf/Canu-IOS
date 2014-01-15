//
//  SignUpViewController.h
//  CANU
//
//  Created by Vivien Cormier on 13/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

- (id)initForCheckPhonenumber:(BOOL)isForCheckPhoneNumber;

@property (retain) id delegate;

@end

@protocol SignUpViewControllerDelegate <NSObject>

@required
- (void)signUpGoBackHome;
- (void)chechPhoneNumber;
@end
