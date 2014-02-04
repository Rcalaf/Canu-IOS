//
//  PhoneBook.h
//  CANU
//
//  Created by Vivien Cormier on 04/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneBook : NSObject

/**
 *  Return all contacts with phone number
 *
 *  @param block
 */
+ (void)contactPhoneBookWithBlock:(void (^)(NSMutableArray *arrayContact,NSError *error))block;

@end
