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
#import "AFNetworking.h"

@implementation User

@synthesize userId = _userId;
@synthesize password = _password;
@synthesize userName = _userName;
@synthesize email = _email;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize profileImageUrl = _profileImageUrl;
@synthesize token = _token;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_userId forKey:@"userId"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_firstName forKey:@"firstName"];
    [aCoder encodeObject:_lastName forKey:@"lastName"];
    [aCoder encodeObject:_token forKey:@"token"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userId = [aDecoder decodeIntegerForKey:@"userId"];
        _userName = [aDecoder decodeObjectForKey:@"userName"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _firstName = [aDecoder decodeObjectForKey:@"firstName"];
        _lastName = [aDecoder decodeObjectForKey:@"lastName"];
        _token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    //NSLog(@"%@",attributes);
    _userId = [[attributes valueForKeyPath:@"id"] integerValue];
    _userName = [attributes valueForKeyPath:@"user_name"];
    _email = [attributes valueForKeyPath:@"email"];
    _firstName = [attributes valueForKeyPath:@"first_name"];
    _lastName = [attributes valueForKeyPath:@"last_name"];
    _token = [attributes valueForKeyPath:@"token"];
    _profileImageUrl = [[NSURL URLWithString:kAFCanuAPIBaseURLString] URLByAppendingPathComponent:[attributes valueForKey:@"profile_pic"]];
    
    //NSLog(@"user urlpic: %@",self.profileImageUrl);
    return self;
}

- (NSDictionary *)serialize
{
    NSString *userId = [NSString stringWithFormat:@"%lu",(unsigned long)_userId];
    NSString *profileImageUrl = [NSString stringWithFormat:@"%@",self.profileImageUrl];
    //NSLog(@"User data: %@, %@, %@, %@, %@",_userName,_email,_firstName,_lastName,_token);
    //NSLog(@"this is the user id %@",userId);
    
    NSArray *objectsArray = [NSArray arrayWithObjects:userId,self.userName,self.email,self.firstName,self.lastName,self.token,profileImageUrl,nil];
    //NSLog(@"number of objects: %lu",(unsigned long)[objectsArray count]);
    NSArray *keysArray =    [NSArray arrayWithObjects:@"id",@"user_name",@"email",@"first_name",@"last_name",@"token",@"profile_pic",nil];
    //NSLog(@"number of keys: %lu",(unsigned long)[keysArray count]);
    NSDictionary *user = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    return user;
}


+ (void)userWithToken:(NSString *)token
             andBlock:(void (^)(User *user, NSError *error))block{
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:token] forKeys: [NSArray arrayWithObject:@"token"]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] postPath:@"session/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
         //NSLog(@"%@",JSON);
        if (block) {
            block([[User alloc] initWithAttributes:[JSON objectForKey:@"user"]], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            //NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

    
}

+ (void)logInWithEmail:(NSString *)email Password:(NSString *)password Block:(void (^)(User *user, NSError *error))block {

    NSArray *objectsArray = [NSArray arrayWithObjects:email,password,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"email",@"password",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] postPath:@"session/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"%@",JSON);
        if (block) {
            block([[User alloc] initWithAttributes:JSON], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            //NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)SignUpWithUserName:(NSString *)userName
                   Password:(NSString*)password
                  FirstName:(NSString *)firstName
                   LastName:(NSString *)lastName
                      Email:(NSString *)email
             ProfilePicture:(UIImage *)profilePicture
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
    
    
    NSData *imageData = UIImageJPEGRepresentation(profilePicture, 1.0);
    NSMutableURLRequest *request = [[AFCanuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"users/" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"profile_image" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    }];
    
    //AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    /*[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];*/
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                            NSLog(@"Process completed %@",JSON);
                                            User *user= [[User alloc] initWithAttributes:JSON];
                                            if (block) {
                                                block(user, nil);
                                            }
                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                        if (block) {
                                            NSLog(@"%@",error);
                                            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                                            block(nil, error);
                                        }
                                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                        }];
    [operation start];

}

- (void)userActivitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block {
    NSString *url = [NSString stringWithFormat:@"/users/%d/activities",self.userId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        //NSLog(@"%@",JSON);
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            [mutableActivities addObject:activity];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


@end
