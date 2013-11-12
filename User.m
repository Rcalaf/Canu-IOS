//
//  User.m
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"
#import "Activity.h"
#import "AFNetworking.h"
#import "MainViewController.h"

@implementation User

@synthesize userId = _userId;
@synthesize password = _password;
@synthesize userName = _userName;
@synthesize email = _email;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize profileImageUrl = _profileImageUrl;
@synthesize profileImage = _profileImage;
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
    //_profileImageUrl = [[NSURL URLWithString:kAFCanuAPIBaseURLString] URLByAppendingPathComponent:[attributes valueForKey:@"profile_pic"]];
    _profileImageUrl = [NSURL URLWithString:[attributes valueForKey:@"profile_pic"]];
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
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:token];
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

    if (!email) email = @""; 
    if (!password) password = @""; 
    
    NSArray *objectsArray = [NSArray arrayWithObjects:email,password,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"email",@"password",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] postPath:@"session/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
       // NSLog(@"%@",JSON);
        if (block) {
            block([[User alloc] initWithAttributes:JSON], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
           // [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
           /* NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);*/
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

    if (!userName) userName = @"";
    if (!password) password = @"";
    if (!userName) userName = @"";
    if (!firstName) firstName = @"";
    if (!lastName) lastName = @"";
    if (!email)    email = @""; 
    
    NSArray *objectsArray = [NSArray arrayWithObjects:userName,password,firstName,lastName,email,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"user_name",@"proxy_password",@"first_name",@"last_name",@"email",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"YYYYddHHmm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSMutableURLRequest *request;
    if (profilePicture) {
        NSData *imageData = UIImageJPEGRepresentation(profilePicture, 1.0);
        request = [[AFCanuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:@"users/" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:imageData name:@"profile_image" fileName:[NSString stringWithFormat:@"avatar_%@.jpg",[dateFormatter stringFromDate:[NSDate date]]] mimeType:@"image/jpeg"];
        }];
        
        //AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        /*[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
         }];*/
    } else {
        request = [[AFCanuAPIClient sharedClient] requestWithMethod:@"POST" path:@"users/" parameters:parameters];
    }
    

    
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

- (void)logOut
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token", nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] postPath:@"session/logout/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
        appDelegate.user = nil;
        
        MainViewController *mvc = [[MainViewController alloc] init];
        appDelegate.window.rootViewController = mvc;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
        appDelegate.user = nil;
        
        MainViewController *mvc = [[MainViewController alloc] init];
        appDelegate.window.rootViewController = mvc;
       
        /*[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];*/
        
        NSLog(@"logout Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

- (void)editLatitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude{
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!latitude) { latitude = appDelegate.currentLocation.latitude; }
    if (!longitude) { longitude = appDelegate.currentLocation.longitude; }
    
    NSArray *objectsArray;
    NSArray *keysArray;
  
    objectsArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:latitude],[NSNumber numberWithDouble:longitude],nil];
    keysArray = [NSArray arrayWithObjects:@"latitude",@"longitude",nil];
   
    
    NSDictionary *user = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:user] forKeys: [NSArray arrayWithObject:@"user"]];
    
    
    NSString *url = [NSString stringWithFormat:@"/users/%d",self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:self.token];
    [[AFCanuAPIClient sharedClient] putPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


- (void)editUserWithUserName:(NSString *)userName
                    Password:(NSString *)password
                   FirstName:(NSString *)firstName
                    LastName:(NSString *)lastName
                       Email:(NSString *)email
                       Block:(void (^)(User *user, NSError *error))block
{
    
    if (!userName) { userName = @""; }
    if (!userName) { userName = @""; }
    if (!firstName){ firstName = @""; }
    if (!lastName) { lastName = @""; }
    if (!email)    { email = @""; }

    NSArray *objectsArray;
    NSArray *keysArray;
    if (!password) {
        objectsArray = [NSArray arrayWithObjects:userName,firstName,lastName,email,nil];
        keysArray = [NSArray arrayWithObjects:@"user_name",@"first_name",@"last_name",@"email",nil];
    } else {
        objectsArray = [NSArray arrayWithObjects:userName,password,firstName,lastName,email,nil];
        keysArray = [NSArray arrayWithObjects:@"user_name",@"proxy_password",@"first_name",@"last_name",@"email",nil];
    }

    NSDictionary *user = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:user] forKeys: [NSArray arrayWithObject:@"user"]];
    
    
    NSString *url = [NSString stringWithFormat:@"/users/%d",self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:self.token];
    [[AFCanuAPIClient sharedClient] putPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        User *user= [[User alloc] initWithAttributes:JSON];
        if (block) {
            block(user, nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)editUserProfilePicture:(UIImage *)profilePicture
                         Block:(void (^)(User *user, NSError *error))block
{
  //  AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSData *imageData = UIImageJPEGRepresentation(profilePicture, 1.0);
    
    NSString *url = [NSString stringWithFormat:@"/users/%d/profile-image",self.userId];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"YYYYddHHmm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:self.token];
    NSMutableURLRequest *request = [[AFCanuAPIClient sharedClient] multipartFormRequestWithMethod:@"PUT" path:url parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"profile_image" fileName:[NSString stringWithFormat:@"avatar_%@.jpg",[dateFormatter stringFromDate:[NSDate date]] ] mimeType:@"image/jpeg"];
    }];
    
    //AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    /*[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];*/
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                            NSLog(@"Process completed %@",JSON);
                                                            User *user= [[User alloc] initWithAttributes:JSON];
                                                            //[[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
                                                            //appDelegate.user = user;
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
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:self.token];
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

#pragma mark - User/device notification logic

- (void)updateDeviceToken:(NSString *)device_token
                    Block: (void (^)(NSError *error))block{
    
    if (!device_token) device_token = @"";
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:device_token] forKeys: [NSArray arrayWithObject:@"device_token"]];
    
    NSString *url = [NSString stringWithFormat:@"/users/%d/device_token",self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:self.token];
    [[AFCanuAPIClient sharedClient] postPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        //NSLog(@"%@",JSON);
        if (block) {
            block(nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            //NSLog(@"%@",error);
            // NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)updateDevice:(NSString *)device_token Badge:(NSInteger)badge WithBlock:(void (^)(NSError *))block
{
    if (!device_token) device_token = @"";
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:[NSNumber numberWithInteger:badge]] forKeys: [NSArray arrayWithObject:@"badge"]];
    
    NSString *url = [NSString stringWithFormat:@"/devices/%@/badge",device_token];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:self.token];
    [[AFCanuAPIClient sharedClient] putPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        //NSLog(@"%@",JSON);
        if (block) {
            block(nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            //NSLog(@"%@",error);
            // NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}


@end
