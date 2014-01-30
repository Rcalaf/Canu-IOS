//
//  Contact.m
//  CANU
//
//  Created by Vivien Cormier on 30/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "Contact.h"

@interface Contact ()

@property (nonatomic) NSString *countryCode;

@end

@implementation Contact

- (id)initWithFullName:(NSString *)fullName phoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode {
    self = [super init];
    if (self) {
        
        self.fullName = fullName;
        self.initialNumber = phoneNumber;
        self.countryCode = countryCode;
        self.convertNumber = [self convertPhoneNumer:phoneNumber];
        
    }
    return self;
}

- (NSString *)convertPhoneNumer:(NSString*)number{
    
    NSString *newNumber = number;
    
    NSString *firstCharactere = [number substringToIndex:1];
    
    if ([firstCharactere isEqualToString:@"0"]){
        
        if ([firstCharactere isEqualToString:@"00"]){
            newNumber = [NSString stringWithFormat:@"+%@",[number substringFromIndex:2]];
        } else {
            newNumber = [NSString stringWithFormat:@"+%@%@",_countryCode,[number substringFromIndex:1]];
        }
        
    }
    
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@"(0)" withString:@""];
    
    return newNumber;
    
}

@end
