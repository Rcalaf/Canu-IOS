//
//  User.h
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (readonly) NSUInteger userId;
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) UIImage *profileImage;
@property (strong,nonatomic) NSString *token;


- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)logInWithEmail:(NSString *)userName Password:(NSString *)password Block:(void (^)(User *user, NSError *error))block;
/*
+ (User *)logInWithUserName:(NSString *)userName Password:(NSString *)password;
+ (User *)signUpWithUserName:(NSString *)userName
                   password:(NSString*)password
                       name:(NSString *)name
                      email:(NSString *)email;
*/
@end
