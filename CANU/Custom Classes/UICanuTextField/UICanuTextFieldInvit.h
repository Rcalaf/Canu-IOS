//
//  UICanuTextFieldInvit.h
//  CANU
//
//  Created by Vivien Cormier on 20/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextField.h"

@class User,Contact;

typedef NS_ENUM(NSInteger, CANUTextfieldInvitStep) {
    CANUTextfieldInvitStep0 = 0, // Delete user is disable
    CANUTextfieldInvitStep1 = 1, // Cursor visible but with space before
    CANUTextfieldInvitStep2 = 2  // Cursor no visible but with white space before and first user selected
};

@interface UICanuTextFieldInvit : UICanuTextField

@property (retain) id delegateFieldInvit;

@property (nonatomic) BOOL activeReset;

@property (nonatomic) BOOL activeDeleteUser;

- (void)updateUserSelected:(NSMutableArray *)arrayAllUserSelected;

- (void)touchDelete;

@end

@protocol UICanuTextFieldInvitDelegate <NSObject>

- (void)inputFieldInvitIsEmpty;

- (void)deleteLastUser:(User *)user;

- (void)deleteLastContact:(Contact *)contact;

@end
