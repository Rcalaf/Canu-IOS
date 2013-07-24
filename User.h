//
//  User.h
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (readonly) NSUInteger userId;
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSURL *profileImageUrl;
@property (strong,nonatomic) NSString *token;


-(id)initWithAttributes:(NSDictionary *)attributes;

+(void)userWithToken:(NSString *)token
            andBlock:(void (^)(User *user, NSError *error))block;

+(void)logInWithEmail:(NSString *)userName
             Password:(NSString *)password
                Block:(void (^)(User *user, NSError *error))block;

+(void)SignUpWithUserName:(NSString *)userName
                 Password:(NSString*)password
                FirstName:(NSString *)firstName
                 LastName:(NSString *)lastName
                    Email:(NSString *)email
           ProfilePicture:(UIImage *)profilePicture
                    Block:(void (^)(User *user, NSError *error))block;

-(void)userActivitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block;

-(NSDictionary *)serialize;


@end
