//
//  User.m
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "AFCanuAPIClient.h"
#import "Activity.h"

@implementation User

@synthesize userId = _userId;
@synthesize password = _password;
@synthesize userName = _userName;
@synthesize email = _email;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize profileImage = _profileImage;
@synthesize token = _token;


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _userId = [[attributes valueForKeyPath:@"id"] integerValue];
    _userName = [attributes valueForKeyPath:@"user_name"];
    _email = [attributes valueForKeyPath:@"email"];
    _firstName = [attributes valueForKeyPath:@"first_name"];
    _lastName = [attributes valueForKeyPath:@"last_name"];
    _token = [attributes valueForKeyPath:@"token"];
    
    return self;
}

+ (void)userWithToken:(NSString *)token
             andBlock:(void (^)(User *user, NSError *error))block{
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:token] forKeys: [NSArray arrayWithObject:@"token"]];
    
    [[AFCanuAPIClient sharedClient] postPath:@"session/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
         //NSLog(@"%@",JSON);
         User *user= [[User alloc] initWithAttributes:[JSON objectForKey:@"user"]];
        //NSLog(@"userName: %@",user.userName);
        if (block) {
            block(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            //NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil, error);
        }
    }];

    
}

+ (void)logInWithEmail:(NSString *)email Password:(NSString *)password Block:(void (^)(User *user, NSError *error))block {

    NSArray *objectsArray = [NSArray arrayWithObjects:email,password,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"email",@"password",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    [[AFCanuAPIClient sharedClient] postPath:@"session/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
           // NSLog(@"%@",JSON);
        User *user= [[User alloc] initWithAttributes:[JSON objectForKey:@"user"]];
        NSLog(@"userName: %@",user.userName);
        if (block) {
            block(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            //NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil, error);
        }
    }];
}

+ (void)SignUpWithUserName:(NSString *)userName
                   Password:(NSString*)password
                  FirstName:(NSString *)firstName
                   LastName:(NSString *)lastName
                      Email:(NSString *)email
            // ProfilePicture:(UIImage *)profilePicture
                      Block:(void (^)(User *user, NSError *error))block
{

    if (!userName) { userName = @""; }
    if (!password) { password = @""; }
    if (!userName) { userName = @""; }
    if (!firstName){ firstName = @""; }
    if (!lastName) { lastName = @""; }
    if (!email)    { email = @""; }    
    
    NSArray *objectsArray = [NSArray arrayWithObjects:userName,password,firstName,lastName,email,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"user_name",@"proxy_password",@"first_name",@"last_name",@"email",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
  //  NSLog(@"%@",parameters);
    
    
    [[AFCanuAPIClient sharedClient] postPath:@"users/" parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         NSLog(@"%@",JSON);
                                         User *user= [[User alloc] initWithAttributes:[JSON objectForKey:@"user"]];
                                         if (block) {
                                             block(user, nil);
                                         }
                                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //NSLog(@"%@",operation);
                                         NSLog(@"%@",error);
                                         if (block) {
                                             //NSLog(@"%@",error);
                                             NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                                             block(nil, error);
                                         }
                                         
                                     }];

}

- (void)userActivitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block {
    
    NSString *url = [NSString stringWithFormat:@"/users/%d/activities",self.userId];
    [[AFCanuAPIClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        //NSLog(@"%@",JSON);
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            Activity *activity = [[Activity alloc] initWithAttributes:[attributes objectForKey:@"activity"]];
            [mutableActivities addObject:activity];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
@end
