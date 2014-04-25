//
//  CreateEditUserList.h
//  CANU
//
//  Created by Vivien Cormier on 11/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ErrorManager.h"

@class User,Contact;

@interface CreateEditUserList : UIView

@property (retain) id delegate;
@property (nonatomic) int maxHeight;
@property (nonatomic) int minHeigt;
@property (nonatomic) int active;
@property (nonatomic) CANUError canuError;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *arrayAllUserSelected;
@property (strong, nonatomic) NSMutableArray *peoplesAlreadySelected;

- (void)lauchView;

/**
 *  Phone book is now available
 */
- (void)phoneBookIsAvailable;

- (void)animateToMaxHeight;

- (void)animateToMinHeight;

- (void)searchPhoneBook:(NSString *)searchWords;

- (void)updateAndDeleteUser:(User *)user;

- (void)updateAndDeleteContact:(Contact *)contact;

- (void)forceDealloc;

@end

@protocol CreateEditUserListDelegate <NSObject>

@optional

- (void)hiddenKeyboardUserList;

@required

- (void)changeUserSelected:(NSMutableArray *)arrayAllUserSelected;

- (void)phoneBookIsLoad;

@end