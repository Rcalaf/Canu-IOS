//
//  Contact.h
//  CANU
//
//  Created by Vivien Cormier on 30/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic) NSString *initialNumber;
@property (nonatomic) NSString *convertNumber;
@property (nonatomic) NSString *fullName;

- (id)initWithFullName:(NSString *)fullName phoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode;

@end
