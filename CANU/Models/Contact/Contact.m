//
//  Contact.m
//  CANU
//
//  Created by Vivien Cormier on 30/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "Contact.h"
#import "UserManager.h"
#import "User.h"

@interface Contact ()

@property (nonatomic) NSString *countryCode;

@end

@implementation Contact

- (id)initWithFullName:(NSString *)fullName profilePicture:(UIImage*)profilePicture phoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode{
    self = [super init];
    if (self) {
        
        self.fullName = fullName;
        self.profilePicture = profilePicture;
        self.initialNumber = phoneNumber;
        self.countryCode = countryCode;
        self.convertNumber = [self convertPhoneNumer:phoneNumber];
        self.isLocal = NO;
        
    }
    return self;
}

- (instancetype)initForLocal{
    
    self = [super init];
    if (self) {
        self.fullName = NSLocalizedString(@"Everyone Around", nil);
        self.convertNumber = NSLocalizedString(@"Makes the Activity Local", nil);
        self.profilePicture = [UIImage imageNamed:@"F_local"];
        self.initialNumber = @"";
        self.isLocal = YES;
    }
    
    return self;
}

- (NSString *)convertPhoneNumer:(NSString*)number{
    
    self.isValide = NO;
    
    NSString *newNumber = number;
    
    NSString *firstCharactere = [number substringToIndex:1];
    
    if ([firstCharactere isEqualToString:@"0"]){
        
        NSString *firstAndSecondCharactere = [number substringToIndex:2];
        
        if ([firstAndSecondCharactere isEqualToString:@"00"]){
            newNumber = [NSString stringWithFormat:@"+%@",[number substringFromIndex:2]];
        } else {
            newNumber = [NSString stringWithFormat:@"+%@%@",_countryCode,[number substringFromIndex:1]];
        }
        
    }
    
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    newNumber = [newNumber stringByReplacingOccurrencesOfString:@"(0)" withString:@""];
    
    NSString *phoneRegex = @"^\\+?\\d{10,15}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    BOOL matches = [test evaluateWithObject:newNumber];
    
    if (matches) {
        self.isValide = YES;
        if ([newNumber isEqualToString:[[UserManager sharedUserManager] currentUser].phoneNumber]) {
            self.isValide = NO;
        }
    }
    
    return newNumber;
    
}

@end
