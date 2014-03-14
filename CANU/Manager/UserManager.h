//
//  UserManager.h
//  CANU
//
//  Created by Vivien Cormier on 14/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserManager : NSObject

+(UserManager*)sharedUserManager;

/**
 *  Login the user
 *
 *  @param user
 *
 *  @return
 */
- (BOOL)logIn:(User *)user;

/**
 *  Logout the user
 *
 *  @return
 */
- (BOOL)logOut;

/**
 *  Update the current user
 *
 *  @param user
 */
- (void)updateUser:(User *)user;

/**
 *
 *  @return the current User
 */
- (User *)currentUser;

/**
 *  Check if there is User connected
 *
 *  @return
 */
- (BOOL)userIsLogIn;

@end
