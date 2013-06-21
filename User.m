//
//  User.m
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "AFCanuAPIClient.h"

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

+ (User *)logInWithUserName:(NSString *)userName Password:(NSString *)password
{    
    User *user = [[User alloc] init];
    
    return user;
}

+ (void)logInWithEmail:(NSString *)email Password:(NSString *)password Block:(void (^)(User *user, NSError *error))block {

    NSArray *objectsArray = [NSArray arrayWithObjects:email,password,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"email",@"password",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    [[AFCanuAPIClient sharedClient] postPath:@"login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
            NSLog(@"%@",JSON);
            User *user= [[User alloc] initWithAttributes:JSON];
        if (block) {
            block(user, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            NSLog(@"%@",error);
            block(nil, error);
        }
    }];
}

+ (void)SignUpWithUserName:(NSString *)userName
                   Password:(NSString*)password
                       Name:(NSString *)name
                      Email:(NSString *)email
                      Block:(void (^)(User *user, NSError *error))block 
{
;
    
/*    [[AFCanuAPIClient sharedClient] postPath:@"session/" parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         //NSLog(@"%@",operation);
                                         NSLog(@"%@",[JSON valueForKey:@"token"]);
                                         [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"token"] forKey:@"token"];
                                         UserProfileViewController *upvc = [[UserProfileViewController alloc] init];
                                         [self.navigationController setViewControllers:[NSArray arrayWithObject:upvc]];
                                         
                                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //NSLog(@"%@",operation);
                                         //NSLog(@"%@",error);
                                         NSLog(@"Error");
                                     }];*/

}
@end
