//
//  PhoneBook.m
//  CANU
//
//  Created by Vivien Cormier on 04/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "PhoneBook.h"

#import <AddressBook/AddressBook.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "ErrorManager.h"

#import "Contact.h"

@interface PhoneBook ()

@end

@implementation PhoneBook

#pragma mark - Public

+ (NSMutableArray *)contactPhoneBook{
    
    NSMutableArray *arryContact;
    
    NSError *error = [self checkPhoneBookAccess];
    
    if (!error) {
        
    }
    
    return arryContact;
    
}

/**
 *  Return all contacts with phone number
 *
 *  @param block
 */
+ (void)contactPhoneBookWithBlock:(void (^)(NSMutableArray *arrayContact,NSError *error))block{
    
    NSError *error = [self checkPhoneBookAccess];
    
    if (error && error.code != CANUErrorPhoneBookNotDetermined) {
        
        if (block) {
            block(nil,error);
        }
        
    } else {
        
        NSMutableArray *arrayContact = [[NSMutableArray alloc]init];
        
        CFErrorRef *errorBook = nil;
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, errorBook);
        
        __block BOOL accessGranted = NO;
        if (ABAddressBookRequestAccessWithCompletion != NULL) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        
        if (accessGranted) {
            
            CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrier = [networkInfo subscriberCellularProvider];
            NSString *mcc = [carrier isoCountryCode];
            
            NSString *countryCode;
            
            if (mcc){
                
                NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DiallingCodes" ofType:@"plist"];
                NSDictionary *dictConvertion = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                
                countryCode = [dictConvertion objectForKey:[mcc lowercaseString]];
                
            }
            
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, errorBook);
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
            
            for (int i = 0; i < nPeople; i++) {
                
                ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                
                ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
                
                NSString *theFinalPhoneNumber;
                
                for (int j = 0; j < ABMultiValueGetCount(multiPhones); j++) {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, 0);
                    NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                    if (phoneNumber) {
                        theFinalPhoneNumber = phoneNumber;
                    }
                }
                
                
                if (theFinalPhoneNumber) {
                    
                    NSString *firstNames = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                    
                    NSString *lastNames =  (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                    
                    UIImage *image;
                    
                    if(ABPersonHasImageData(person)){
                        image = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(person)];
                    }
                    
                    Contact *contact;
                    
                    if (firstNames && ![firstNames mk_isEmpty] && lastNames && ![lastNames mk_isEmpty]) {
                        NSString *fullName = [NSString stringWithFormat:@"%@ %@",firstNames,lastNames];
                        contact = [[Contact alloc]initWithFullName:fullName profilePicture:image phoneNumber:theFinalPhoneNumber countryCode:countryCode];;
                    } else if (firstNames && ![firstNames mk_isEmpty]) {
                        contact = [[Contact alloc]initWithFullName:firstNames profilePicture:image phoneNumber:theFinalPhoneNumber countryCode:countryCode];
                    } else if (lastNames && ![lastNames mk_isEmpty]) {
                        contact = [[Contact alloc]initWithFullName:lastNames profilePicture:image phoneNumber:theFinalPhoneNumber countryCode:countryCode];
                    }
                    
                    if (contact) {
                        
                        BOOL isAlreadyIn = NO;
                        
                        for (int y = 0; y < [arrayContact count]; y++) {
                            
                            Contact *contactData = [arrayContact objectAtIndex:y];
                            
                            if ([contactData.convertNumber isEqualToString:contact.convertNumber]) {
                                isAlreadyIn = YES;
                            }
                            
                        }
                        
                        if (!isAlreadyIn) {
                            [arrayContact addObject:contact];
                        }
                        
                    }

                }
                
            }
            
            if (block) {
                block(arrayContact,nil);
            }
            
        } else {
            
            // Cannot fetch Phone Book
            
            error = [NSError errorWithDomain:@"CANUError" code:CANUErrorPhoneBookRestricted userInfo:nil];
            
            if (block) {
                block(nil,error);
            }
            
        }
        
    }
    
}

+ (NSError *)checkPhoneBookAccess{
    
    NSError *error = nil;
    
    switch (ABAddressBookGetAuthorizationStatus()){
        case  kABAuthorizationStatusAuthorized:
            break;
        case  kABAuthorizationStatusNotDetermined :
            error = [NSError errorWithDomain:@"CANUError" code:CANUErrorPhoneBookNotDetermined userInfo:nil];
            break;
        case  kABAuthorizationStatusDenied:
            error = [NSError errorWithDomain:@"CANUError" code:CANUErrorPhoneBookRestricted userInfo:nil];
            break;
        case  kABAuthorizationStatusRestricted:
            error = [NSError errorWithDomain:@"CANUError" code:CANUErrorPhoneBookRestricted userInfo:nil];
            break;
        default:
            break;
    }
    
    return error;
    
}

+ (void)requestPhoneBookAccessBlock:(void (^)(NSError *error))block{
    
    ABAddressBookRef addressBook = NULL;
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef errorCF){
        if (granted){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [PhoneBook checkPhoneBookAccess];
                if (block) {
                    block(error);
                }
            });
        } else {
            NSError *error = [PhoneBook checkPhoneBookAccess];
            if (block) {
                block(error);
            }
        }
    });
    
}

@end
