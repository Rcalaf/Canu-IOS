//
//  User.h
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *token;

/*
+ (User *)logInWithUserName:(NSString *)userName Password:(NSString *)password;
+ (User *)signUpWithUserName:(NSString *)userName
                   password:(NSString*)password
                       name:(NSString *)name
                      email:(NSString *)email;
*/
@end
