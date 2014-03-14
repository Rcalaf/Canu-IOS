//
//  UserManager.m
//  CANU
//
//  Created by Vivien Cormier on 14/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UserManager.h"
#import "AFCanuAPIClient.h"
#import "User.h"

@interface UserManager ()

@property (nonatomic) User *user;

@end

@implementation UserManager

static UserManager* _sharedUserManager = nil;

#pragma mark - Lifecycle

+(UserManager*)sharedUserManager
{
	@synchronized([UserManager class])
	{
		if (!_sharedUserManager) _sharedUserManager = [[self alloc] init];
        
		return _sharedUserManager;
	}
    
	return nil;
}

- (id)init{
    
    self = [super init];
    if (self) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if([dic count] == 0) {
            _user = nil;
        } else {
            _user = [[User alloc]initWithAttributes:dic];
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
    [defaults synchronize];
    
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
