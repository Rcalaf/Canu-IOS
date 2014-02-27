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
@property (nonatomic) CANUError canuError;
@property (strong, nonatomic) NSMutableArray *arrayAllUserSelected;

/**
 *  Phone book is now available
 */
-(void)phoneBookIsAvailable;

- (void)searchPhoneBook:(NSString *)searchWords;

- (void)updateAndDeleteUser:(User *)user;

- (void)updateAndDeleteContact:(Contact *)contact;

@end

@protocol CreateEditUserListDelegate <NSObject>

@required

- (void)changeUserSelected:(NSMutableArray *)arrayAllUserSelected;

@end
