//
//  SignInViewController.h
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate>

@property (retain) id delegate;

@end

@protocol SignInViewControllerDelegate <NSObject>

@required
- (void)signInGoBackHome;
- (void)signInGoToFeed;
@end
