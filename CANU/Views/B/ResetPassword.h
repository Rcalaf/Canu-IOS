//
//  ResetPassword.h
//  CANU
//
//  Created by Vivien Cormier on 07/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User,UICanuTextFieldLine;

@interface ResetPassword : UIView

@property (strong, nonatomic) UICanuTextFieldLine *password;

- (id)initWithFrame:(CGRect)frame AndUser:(User *)user;

- (void)updatePasswordBlock:(void (^)(User *user))block;

@end
