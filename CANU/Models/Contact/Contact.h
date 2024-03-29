//
//  Contact.h
//  CANU
//
//  Created by Vivien Cormier on 30/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic) BOOL isValide;
@property (nonatomic) NSString *initialNumber;
@property (nonatomic) NSString *convertNumber;
@property (nonatomic) NSString *fullName;
@property (nonatomic) UIImage* profilePicture;
@property (nonatomic) BOOL isLocal;

- (instancetype)initForLocal;

- (id)initWithFullName:(NSString *)fullName profilePicture:(UIImage*)profilePicture phoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode;

- (NSString *)convertPhoneNumer:(NSString*)number;

@end
