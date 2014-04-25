//
//  ErrorManager.h
//  CANU
//
//  Created by Vivien Cormier on 23/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CANUError) {
    CANUErrorNoError = 42,              // No error
    CANUErrorUnknown = 0,               // Unknow error
    CANUErrorNoInternetConnection = 1,  // No internet connection
    CANUErrorServerDown = 2,            // The canu api server is down
    CANUErrorPhoneBookRestricted = 3,   // If We don't have access to the phone book
    CANUErrorPhoneBookNotDetermined = 4,// If We don't have access to the phone book
    CANUErrorLocationRestricted = 5,    // If We don't have access to the location
    CANUErrorLocationNotDetermined = 6, // If We don't have access to the location
    CANUErrorPushNotDetermined = 7,     // If We don't know if the user allow push notification
    CANUErrorPushG3b = 8                // If the user don't allow the push and he click on Go.
};

@interface ErrorManager : NSObject

/**
 *  Shared function
 *
 *  @return Current Error Manager
 */
+ (ErrorManager *)sharedErrorManager;

#pragma mark - Public

#pragma mark - - Detect Manager Error

/**
 *  Detect error and convert it to CANUError
 *
 *  @param error NSError
 *  @param block CANUError
 */
- (void)detectError:(NSError *)error Block: (void (^)(CANUError canuError))block;

#pragma mark - - Detect Manager Error Push Notification

/**
 *  Show the G3b Alert if necessary
 */
- (void)showG3bAlertIfNecessary;

/**
 *  Reset and delete the dic after logout
 */
- (void)resetAlertPushNotification;

#pragma mark - - User Manager Error

/**
 *  Show a visual alert for the user
 *
 *  @param canuError Code Error
 */
- (void)visualAlertFor:(CANUError)canuError;

#pragma mark - - Back Manager Error

/**
 *  Send a email to Canu Tean with the error
 *
 *  @param errorUnknown The error
 *  @param fileName  Name of the file
 *  @param functionName  Name of the function
 */
- (void)unknownErrorDetected:(NSError *)errorUnknown ForFile:(NSString *)fileName function:(NSString *)functionName;

/**
 *  Send a email to Canu Tean if the server is down
 */
- (void)serverIsDown;

#pragma mark - - Manager Current Error

/**
 *  Delete the error
 *
 *  @param canuError
 */
- (void)deleteError:(CANUError)canuError;

@end
