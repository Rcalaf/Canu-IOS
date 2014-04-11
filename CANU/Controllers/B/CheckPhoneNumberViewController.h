//
//  CheckPhoneNumberViewController.h
//  CANU
//
//  Created by Vivien Cormier on 10/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UICanuButton.h"

typedef NS_ENUM(NSInteger, CheckPhoneNumberViewControllerView) {
    CheckPhoneNumberViewControllerViewPhoneNumber = 1,
    CheckPhoneNumberViewControllerViewChooseCountry = 2,
    CheckPhoneNumberViewControllerViewPhoneCode = 3
};

@class User;

@interface CheckPhoneNumberViewController : UIViewController

@property (nonatomic) CheckPhoneNumberViewControllerView viewType;
@property (strong, nonatomic) UICanuButton *nextButton;
@property (strong, nonatomic) UIButton *backButton;

- (instancetype)initForUser:(User *)user ForceVerified:(BOOL)isForceVerified;

- (void)checkPhoneCode;

- (void)checkPhoneNumber;

- (void)goBackPhoneNumber;

- (void)selectCountry;

- (void)hiddenPickCountryCode;

@end
