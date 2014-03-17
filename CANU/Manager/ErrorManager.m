//
//  ErrorManager.m
//  CANU
//
//  Created by Vivien Cormier on 23/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "ErrorManager.h"
#import "AFCanuAPIClient.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "AlertViewController.h"

@interface ErrorManager ()

/**
 *  Send email only if distribution mode is activate ( cf : AFCanuAPIClient )
 */
@property (nonatomic) BOOL feedBackAlert;

/**
 *  Array with the currents errors
 */
@property (strong, nonatomic) NSMutableArray *arrayError;

/**
 *  Alert G3b for Push notification
 */
@property (strong, nonatomic) NSMutableDictionary *alertPush;

/**
 *  For test the Global Internet Connection
 */
@property (strong, nonatomic) Reachability *globalInternetReachable;

/**
 *  For test the Canu Internet Connection
 */
@property (strong, nonatomic) Reachability *canuInternetReachable;

@end

@implementation ErrorManager

static ErrorManager *_sharedErrorManager = nil;
static dispatch_once_t oncePredicate;

/**
 *  Shared function
 *
 *  @return Current Error Manager
 */
+ (ErrorManager *)sharedErrorManager{
    
    dispatch_once(&oncePredicate, ^{
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        if (!appDelegate.errorManager) {
            _sharedErrorManager = [[ErrorManager alloc] init];
            appDelegate.errorManager = _sharedErrorManager;
        } else {
            _sharedErrorManager = appDelegate.errorManager;
        }
        
    });
    
    return _sharedErrorManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _alertPush = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AlertPush"] mutableCopy];

        if (!_alertPush) {
            _alertPush = [[NSMutableDictionary alloc]init];
        }
        
        self.arrayError = [[NSMutableArray alloc]init];
        self.feedBackAlert = [AFCanuAPIClient sharedClient].distributionMode;
        
    }
    return self;
}

#pragma mark - Public

#pragma mark - - Detect Manager Error

/**
 *  Detect error and convert it to CANUError
 *
 *  @param error NSError
 *  @param block CANUError
 */
- (void)detectError:(NSError *)error Block: (void (^)(CANUError canuError))block{
    
    if ([[error localizedDescription] isEqualToString:@"Could not connect to the server."] || [[error localizedDescription] isEqualToString:@"The request timed out."]) {
        
        [self testGlobalInternetConnectionBlock:^(NSNumber *result) {
            if ([result boolValue]) {
                // Internet Connection On
                [self testCanuInternetConnectionBlock:^(NSNumber *result) {
                    if ([result boolValue]) {
                        // Unknown Error
                        if (block) {
                            block(CANUErrorUnknown);
                        }
                    } else {
                        // Server Down
                        if (block) {
                            block(CANUErrorServerDown);
                        }
                    }
                }];
            } else {
                // Internet connection Off
                if (block) {
                    block(CANUErrorNoInternetConnection);
                }
            }
        }];
        
    } else {
        // Unknown Error
        if (block) {
            block(CANUErrorUnknown);
        }
    }
    
}

#pragma mark - - Detect Manager Error Push Notification

/**
 *  Show the G3b Alert if necessary
 */
- (void)showG3bAlertIfNecessary{
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types & UIRemoteNotificationTypeAlert){
        
        
        
    } else {
       
        if (![_alertPush objectForKey:@"G3b"]) {
            
            [self.alertPush setObject:[NSNumber numberWithBool:YES] forKey:@"G3b"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"AlertPush"];
            [defaults setObject:_alertPush forKey:@"AlertPush"];
            [defaults synchronize];
            
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            
            AlertViewController *alert = [[AlertViewController alloc]init];
            alert.canuAlertViewType = CANUAlertViewHeader;
            alert.canuError = CANUErrorPushG3b;
            
            [self addError:CANUErrorUnknown];
            
            [appDelegate.window addSubview:alert.view];
            [appDelegate.window.rootViewController addChildViewController:alert];
            
        }
        
    }
    
}

/**
 *  Reset and delete the dic after logout
 */
- (void)resetAlertPushNotification{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"AlertPush"];
    [defaults synchronize];
    
}

#pragma mark - - User Manager Error

/**
 *  Show a visual alert for the user
 *
 *  @param canuError Code Error
 */
- (void)visualAlertFor:(CANUError)canuError{
    
    switch (canuError) {
        case CANUErrorUnknown:
            [self alertForUnknowError];
            break;
        case CANUErrorNoInternetConnection:
            [self alertForNoInternetConnection];
            break;
        case CANUErrorServerDown:
            [self alertForServerDown];
            break;
        case CANUErrorPhoneBookRestricted:
            [self alertForNotification:CANUErrorPhoneBookRestricted];
            break;
        case CANUErrorLocationRestricted:
            [self alertForNotification:CANUErrorLocationRestricted];
            break;
            default:
            break;
    }
    
}

#pragma mark - - Back Manager Error

/**
 *  Send a email to Canu Tean with the error
 *
 *  @param errorUnknown The error
 *  @param fileName  Name of the file
 *  @param functionName  Name of the function
 */
- (void)unknownErrorDetected:(NSError *)errorUnknown ForFile:(NSString *)fileName function:(NSString *)functionName{
    
    if (_feedBackAlert) {
        NSLog(@"File : %@ Function : %@ Error %@",fileName,functionName,errorUnknown);
    } else {
        NSLog(@"File : %@ Function : %@ Error %@",fileName,functionName,errorUnknown);
    }
    
}

/**
 *  Send a email to Canu Tean if the server is down
 */
- (void)serverIsDown{
    
    if (_feedBackAlert) {
        NSLog(@"Server Down");
    } else {
        NSLog(@"Server Down");
    }
    
}

#pragma mark - Private 

#pragma mark - - UI

/**
 *  Visual alert for unknown error
 */
- (void)alertForUnknowError{
    
    if (![self checkIfErrorIsAlreadyAppear:CANUErrorUnknown]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        AlertViewController *alert = [[AlertViewController alloc]init];
        alert.canuAlertViewType = CANUAlertViewHeader;
        alert.canuError = CANUErrorUnknown;
        
        [self addError:CANUErrorUnknown];
        
        [appDelegate.window addSubview:alert.view];
        [appDelegate.window.rootViewController addChildViewController:alert];
    }
    
}

/**
 *  Visual alert for no internet connection
 */
- (void)alertForNoInternetConnection{
    
    if (![self checkIfErrorIsAlreadyAppear:CANUErrorNoInternetConnection]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        AlertViewController *alert = [[AlertViewController alloc]init];
        alert.canuAlertViewType = CANUAlertViewHeader;
        alert.canuError = CANUErrorNoInternetConnection;
        
        [self addError:CANUErrorNoInternetConnection];
        
        [appDelegate.window addSubview:alert.view];
        [appDelegate.window.rootViewController addChildViewController:alert];
    }
    
}

/**
 *  Visual alert for no internet connection
 */
- (void)alertForServerDown{
    
    if (![self checkIfErrorIsAlreadyAppear:CANUErrorServerDown]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        AlertViewController *alert = [[AlertViewController alloc]init];
        alert.canuAlertViewType = CANUAlertViewHeader;
        alert.canuError = CANUErrorServerDown;
        
        [self addError:CANUErrorServerDown];
        
        [appDelegate.window addSubview:alert.view];
        [appDelegate.window.rootViewController addChildViewController:alert];
    }
    
}

- (void)alertForNotification:(CANUError)error{
    
    CANUAlertViewType canuAlertViewtype = CANUAlertViewPopIn;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    AlertViewController *alert = [[AlertViewController alloc]init];
    alert.canuAlertViewType = canuAlertViewtype;
    alert.canuError = error;
    
    [self addError:CANUErrorServerDown];
    
    [appDelegate.window addSubview:alert.view];
    [appDelegate.window.rootViewController addChildViewController:alert];
    
}

#pragma mark - - Internet Reachability

/**
 *  Use Reachability to detect "No internet connection" or "Server down"
 */
- (void)testGlobalInternetConnectionBlock: (void (^)(NSNumber *result))block{
    
    self.globalInternetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    self.globalInternetReachable.reachableBlock = ^(Reachability*reach){
        // Server is down
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([NSNumber numberWithBool:YES]);
            }
        });
    };
    
    // Internet is not reachable
    self.globalInternetReachable.unreachableBlock = ^(Reachability*reach){
        // Server is probably not down
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([NSNumber numberWithBool:NO]);
            }
        });
    };
    
    [self.globalInternetReachable startNotifier];
}

/**
 *  Use Reachability to detect "No internet connection" or "Server down"
 */
- (void)testCanuInternetConnectionBlock: (void (^)(NSNumber *result))block{
    
    self.canuInternetReachable = [Reachability reachabilityWithHostname:[AFCanuAPIClient sharedClient].urlBase];
    
    // Internet is reachable
    self.canuInternetReachable.reachableBlock = ^(Reachability*reach){
        // Server is down
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([NSNumber numberWithBool:YES]);
            }
        });
    };
    
    // Internet is not reachable
    self.canuInternetReachable.unreachableBlock = ^(Reachability*reach){
        // Server is probably not down
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([NSNumber numberWithBool:NO]);
            }
        });
    };
    
    [self.canuInternetReachable startNotifier];
}

#pragma mark - - Manager Current Error

/**
 *  Add on this array only if the error is showing
 *
 *  @param canuError
 */
- (void)addError:(CANUError)canuError{
    [self.arrayError addObject:[NSNumber numberWithInt:canuError]];
}

/**
 *  Delete the error
 *
 *  @param canuError
 */
- (void)deleteError:(CANUError)canuError{
 
    if ([self checkIfErrorIsAlreadyAppear:canuError]) {
        [self.arrayError removeObject:[NSNumber numberWithInt:canuError]];
    }
    
}

/**
 *  Check if this error is showing
 *
 *  @param canuError
 *
 *  @return BOOL
 */
- (BOOL)checkIfErrorIsAlreadyAppear:(CANUError)canuError{
    
    return [self.arrayError containsObject:[NSNumber numberWithInt:canuError]];
    
}

@end
