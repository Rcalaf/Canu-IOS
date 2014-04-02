//
//  UserManager.m
//  CANU
//
//  Created by Vivien Cormier on 14/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UserManager.h"
#import "ErrorManager.h"
#import "AFCanuAPIClient.h"
#import "User.h"

NSInteger const kVersionData = 1; // If you want a automatic logout for the next release, add +1 to this value

@interface UserManager ()

@property (nonatomic) NSString *urlApi;
@property (nonatomic) NSInteger versionData;
@property (strong, nonatomic) User *user;

@end

@implementation UserManager

#pragma mark - Lifecycle

+(UserManager*)sharedUserManager
{
    
    static UserManager* _sharedUserManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedUserManager = [[self alloc] init];
    });
    
	return _sharedUserManager;
}

- (id)init{
    
    self = [super init];
    if (self) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        _urlApi = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlApi"];
        
        _versionData = [[NSUserDefaults standardUserDefaults] integerForKey:@"versionData"];

        if([dic count] == 0) {
            _user = nil;
        } else {
            _user = [[User alloc]initWithAttributes:dic];
        }
        
        if (_urlApi != [[AFCanuAPIClient sharedClient] urlBase]) {
            NSLog(@"Logout : Not connect to the same api");
            [self logOut];
        }
        
        if (_versionData != kVersionData) {
            NSLog(@"Logout : New version of the user data");
            [self logOut];
        }
        
    }
    return self;
}

#pragma mark - Public

/**
 *  Login the user
 *
 *  @param user
 *
 *  @return
 */
- (BOOL)logIn:(User *)user{
    
    if (_user) {
        return NO;
    }
    
    self.user = user;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user.attributes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"User"];
    [defaults setObject:data forKey:@"User"];
    
    [defaults setObject:[[AFCanuAPIClient sharedClient] urlBase] forKey:@"urlApi"];
    
    [defaults setInteger:kVersionData forKey:@"versionData"];
    
    [defaults synchronize];
    
    return YES;
    
}

/**
 *  Logout the user
 *
 *  @return
 */
- (BOOL)logOut{
    
    [self.user logOut];
    
    _user = nil;
    
    NSDictionary *dicEmpty;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicEmpty];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"User"];
    [defaults setObject:data forKey:@"User"];
    
    [defaults removeObjectForKey:@"logToDistributionMode"];
    [defaults setBool:NO forKey:@"logToDistributionMode"];
    
    [defaults removeObjectForKey:@"urlApi"];
    
    [defaults removeObjectForKey:@"versionData"];
    
    [defaults synchronize];
    
    [[ErrorManager sharedErrorManager] resetAlertPushNotification];
    
    return YES;
    
}

/**
 *  Update the current user
 *
 *  @param user
 */
- (void)updateUser:(User *)user{
    
    self.user = user;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user.attributes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"User"];
    [defaults setObject:data forKey:@"User"];
    [defaults synchronize];
    
}

/**
 *
 *  @return the current User
 */
- (User*)currentUser{
    
    return _user;
    
}

/**
 *  Check if there is User connected
 *
 *  @return
 */
- (BOOL)userIsLogIn{
    
    BOOL isLogIn = false;
    
    if (_user) {
        isLogIn = true;
    }
    
    return isLogIn;
    
}

@end
