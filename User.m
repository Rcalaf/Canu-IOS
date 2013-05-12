//
//  User.m
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize name = _name;
@synthesize password = _password;
@synthesize userName = _userName;
@synthesize email = _email;
@synthesize token = _token;


+ (User *)logInWithUserName:(NSString *)userName Password:(NSString *)password
{    
    User *user = [[User alloc] init];
    return user;
}

+ (User *)SignUpWithUserName:(NSString *)userName
                   Password:(NSString*)password
                       Name:(NSString *)name
                      Email:(NSString *)email
{
    User *user = [[User alloc] init];
    return user;
}
@end
