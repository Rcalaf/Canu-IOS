//
//  User.m
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"
#import "Activity.h"
#import "AFNetworking.h"
#import "MainViewController.h"
#import "ErrorManager.h"
#import "UserManager.h"
#import "Contact.h"

@interface User ()

/**
 *  Url of the profil picture without the hostname
 */
@property (strong, nonatomic) NSString *profileImageUrlShort;

@end

@implementation User

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_attributes forKey:@"dicUser"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    self.attributes = [decoder decodeObjectForKey:@"dicUser"];
    return [self initWithAttributes:_attributes];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        
        _firstName = @"";
        _lastName = @"";
        _email = @"";
        
        _phoneIsVerified = false;
        
        _attributes      = attributes;
        
        _userId          = [[attributes valueForKeyPath:@"id"] integerValue];
        _userName        = [attributes valueForKeyPath:@"user_name"];
        if ([attributes objectForKey:@"email"] != [NSNull null] && [attributes objectForKey:@"email"] != nil) {
            _email           = [attributes valueForKeyPath:@"email"];
        }
        
        if ([attributes objectForKey:@"first_name"] != [NSNull null] && [attributes objectForKey:@"first_name"] != nil) {
            _firstName   = [attributes valueForKeyPath:@"first_name"];
        }
        if ([attributes objectForKey:@"last_name"] != [NSNull null] && [attributes objectForKey:@"last_name"] != nil) {
            _lastName    = [attributes valueForKeyPath:@"last_name"];
        }
        _token           = [attributes valueForKeyPath:@"token"];
        _phoneNumber     = [attributes valueForKeyPath:@"phone_number"];
        if ([attributes objectForKey:@"phone_verified"] != [NSNull null] && [attributes objectForKey:@"phone_verified"] != nil) {
            _phoneIsVerified  = [[attributes valueForKeyPath:@"phone_verified"] boolValue];
        }
        
        if ([attributes objectForKey:@"profile_pic"] != [NSNull null] && [attributes objectForKey:@"profile_pic"] != nil) {
            
            if (![[attributes objectForKey:@"profile_pic"] isEqualToString:@"/profile_images/default/missing.png"] && ![[attributes objectForKey:@"profile_pic"] isEqualToString:@"/profile_images/thumb/missing.png"] ) {
                _profileImageUrlShort = [attributes valueForKey:@"profile_pic"];
                
                NSString *urlWithoutHttps = [[AFCanuAPIClient sharedClient].urlBase stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
                _profileImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlWithoutHttps,[attributes valueForKey:@"profile_pic"]]];
            }
            
        }
       
    }
    
    return self;
}

+ (void)userWithToken:(NSString *)token
             andBlock:(void (^)(User *user, NSError *error))block{
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:token] forKeys: [NSArray arrayWithObject:@"token"]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", [[UserManager sharedUserManager] currentUser].token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] POST:@"session/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block([[User alloc] initWithAttributes:responseObject], nil);
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

+ (void)logInWithEmail:(NSString *)email Password:(NSString *)password Block:(void (^)(User *user, NSError *error))block {

    if (!email) email = @"";
    if (!password) password = @"";
    
    NSArray *objectsArray = [NSArray arrayWithObjects:email,password,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"email",@"password",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] POST:@"session/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block([[User alloc] initWithAttributes:responseObject], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

+ (void)checkUsername:(NSString *)username Block:(void (^)(NSError *error))block{
    
    if (!username) username = @"";
    
    NSArray *objectsArray = [NSArray arrayWithObjects:username,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"user_name",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] POST:@"session/check-username" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (profilePicture) {
        NSData *imageData = UIImageJPEGRepresentation(profilePicture, 1.0);
        
        [[AFCanuAPIClient sharedClient] POST:@"users/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"profile_image" fileName:[NSString stringWithFormat:@"avatar_%@.jpg",[dateFormatter stringFromDate:[NSDate date]]] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            User *user= [[User alloc] initWithAttributes:responseObject];
            if (block) {
                block(user, nil);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                NSLog(@"%@",error);
                NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                block(nil, error);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
    } else {
        [[AFCanuAPIClient sharedClient] POST:@"users/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            User *user= [[User alloc] initWithAttributes:responseObject];
            if (block) {
                block(user, nil);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (block) {
                NSLog(@"%@",error);
                NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                block(nil, error);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
    }

}

- (void)sendSMSWithCode:(NSInteger)code countrycode:(NSString *)countryCode countryName:(NSString *)countryName andPhoneNumber:(NSString *)phoneNumber Block:(void (^)(NSError *error))block{
    
    NSArray *objectsArray;
    NSArray *keysArray;
    
    objectsArray = [NSArray arrayWithObjects:[NSNumber numberWithLong:code],countryCode,countryName,phoneNumber,nil];
    keysArray = [NSArray arrayWithObjects:@"code",@"country_code",@"country_name",@"phone_number",nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    NSString *url = @"users/send-sms";
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (block) {
            block(nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (block) {
            NSLog(@"Request Failed with Error: %@", error);
            block(error);
        }
    }];
    
}

- (void)phoneNumber:(NSString *)phoneNumber isVerifiedBlock:(void (^)(User *user, NSError *error))block{
    
    NSArray *objectsArray;
    NSArray *keysArray;
    
    objectsArray = [NSArray arrayWithObjects:[NSNumber numberWithLong:self.userId],phoneNumber,nil];
    keysArray = [NSArray arrayWithObjects:@"user_id",@"phone_number",nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    NSString *url = @"users/sms-verification-v2";
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        User *user= [[User alloc] initWithAttributes:responseObject];
        if (block) {
            block(user, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (block) {
            NSLog(@"Request Failed with Error: %@", error);
            block(nil, error);
        }
    }];
    
}

+ (void)SignUpWithUserName:(NSString *)userName
                  Password:(NSString*)password
                     Block:(void (^)(User *user, NSError *error))block
{
    
    if (!userName) userName = @"";
    if (!password) password = @"";
    
    NSArray *objectsArray = [NSArray arrayWithObjects:userName,password,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"user_name",@"proxy_password",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"YYYYddHHmm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] POST:@"users/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        User *user= [[User alloc] initWithAttributes:responseObject];
        if (block) {
            block(user, nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (block) {
            NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

+ (void)sendSMSForResetPasswordWithCode:(NSInteger)code countrycode:(NSString *)countryCode countryName:(NSString *)countryName andPhoneNumber:(NSString *)phoneNumber Block:(void (^)(User *user, NSError *error))block{
    
    NSArray *objectsArray;
    NSArray *keysArray;
    
    NSString *devKey = @"9384nc934875";
    
    if ([AFCanuAPIClient distributionMode]) {
        devKey = @"";
    }
    
    objectsArray = [NSArray arrayWithObjects:[NSNumber numberWithLong:code],countryCode,countryName,phoneNumber,devKey,nil];
    keysArray = [NSArray arrayWithObjects:@"code",@"country_code", @"country_name",@"phone_number",@"key",nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    NSString *url = @"users/send-sms-reset-password";
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        User *user = [[User alloc]initWithAttributes:responseObject];
        if (block) {
            block(user,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (block) {
            NSLog(@"Request Failed with Error: %@", error);
            block(nil,error);
        }
    }];
    
}

- (void)logOut{
    NSLog(@"logOut");
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.token,@"token", nil];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] POST:@"session/logout/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [appDelegate logOut];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [appDelegate logOut];
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
    
    
    NSString *url = [NSString stringWithFormat:@"/users/%lu",(unsigned long)self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    
    NSString *url = [NSString stringWithFormat:@"/users/%lu",(unsigned long)self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *user= [[User alloc] initWithAttributes:responseObject];
        if (block) {
            block(user, nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ErrorManager sharedErrorManager] detectError:error AndRespondData:operation.responseData Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block(nil,customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"userActivitiesWithBlock:"];
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }];
        
        
    }];
    
}

- (void)editPassword:(NSString *) password ForUser:(User *) user Block:(void (^)(User *user, NSError *error))block{
    
    NSString *userName = user.userName;
    NSString *firstName = user.firstName;
    NSString *lastName = user.lastName;
    NSString *email = user.email;
    
    if (!userName) { userName = @""; }
    if (!firstName){ firstName = @""; }
    if (!lastName) { lastName = @""; }
    if (!email)    { email = @""; }
    
    NSArray *objectsArray;
    NSArray *keysArray;
    objectsArray = [NSArray arrayWithObjects:userName,password,firstName,lastName,email,nil];
    keysArray = [NSArray arrayWithObjects:@"user_name",@"proxy_password",@"first_name",@"last_name",@"email",nil];
    
    NSDictionary *userDic = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects:userDic,@"9348yr20qo98r4",nil] forKeys: [NSArray arrayWithObjects:@"user",@"key",nil]];
    
    
    NSString *url = [NSString stringWithFormat:@"/users/%lu/reset-password",(unsigned long)self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *user= [[User alloc] initWithAttributes:responseObject];
        if (block) {
            block(user, nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ErrorManager sharedErrorManager] detectError:error AndRespondData:operation.responseData Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block(nil,customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"userActivitiesWithBlock:"];
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }];
        
        
    }];
    
}

- (void)editUserProfilePicture:(UIImage *)profilePicture Block:(void (^)(User *user, NSError *error))block{
    
    NSData *imageData = UIImageJPEGRepresentation(profilePicture, 1.0);
    
    NSString *url = [NSString stringWithFormat:@"/users/%lu/profile-image",(unsigned long)self.userId];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"YYYYddHHmm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"profile_image" fileName:[NSString stringWithFormat:@"avatar_%@.jpg",[dateFormatter stringFromDate:[NSDate date]] ] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Process completed %@",responseObject);
        User *user= [[User alloc] initWithAttributes:responseObject];
        if (block) {
            block(user, nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil, error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

/**
 *  Get activities of the user
 *
 *  @param block Activities's user / Errors
 */
- (void)userActivitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block {
    
    NSString *url = [NSString stringWithFormat:@"/users/%lu/activities",(unsigned long)self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *attributes in responseObject) {
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            [mutableActivities addObject:activity];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block([NSArray alloc],customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"userActivitiesWithBlock:"];
            }
            
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

/**
 *  Get activities of the tribes's user
 *
 *  @param block Activities's user / Errors
 */
- (void)userActivitiesTribesWithBlock:(void (^)(NSArray *activities, NSError *error))block {
    
    NSString *url = [NSString stringWithFormat:@"/users/%lu/activities/tribes/",(unsigned long)self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFCanuAPIClient *operation = [AFCanuAPIClient sharedClient];
    
    [operation.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [operation GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *attributes in responseObject) {
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            [mutableActivities addObject:activity];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block([NSArray alloc],customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"userActivitiesTribesWithBlock:"];
            }
            
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

#pragma mark - User/device notification logic

- (void)updateDeviceToken:(NSString *)device_token Block:(void (^)(NSError *error))block{
    
    if (!device_token) device_token = @"";
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:device_token] forKeys: [NSArray arrayWithObject:@"device_token"]];
    
    NSString *url = [NSString stringWithFormat:@"/users/%lu/device_token",(unsigned long)self.userId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block(customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"updateDeviceToken:Block:"];
            }
            
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

- (void)updateDevice:(NSString *)device_token Badge:(NSInteger)badge WithBlock:(void (^)(NSError *))block{
    
    if (!device_token) device_token = @"";
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:[NSNumber numberWithInteger:badge]] forKeys: [NSArray arrayWithObject:@"badge"]];
    
    NSString *url = [NSString stringWithFormat:@"/devices/%@/badge",device_token];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block(customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"updateDevice:Badge:WithBlock:"];
            }
            
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

#pragma mark Phone Book

/**
 *  Detec the CANU User with the phone number in the phone book
 *
 *  @param arrayPhoneNumer Array with phone clean number
 *  @param block
 */
- (void)checkPhoneBook:(NSMutableArray*)arrayContact WithBlock:(void (^)(NSMutableArray *arrayCANUUser,NSError *error))block{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.arrayContactCanuUser) {
        if (block) {
            NSLog(@"Use cache Canu User");
            block([[NSMutableArray alloc] initWithArray:appDelegate.arrayContactCanuUser],nil);
        }
    } else {
        
        NSMutableArray *arrayPhoneNumber = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [arrayContact count]; i++) {
            Contact *contact = [arrayContact objectAtIndex:i];
            [arrayPhoneNumber addObject:contact.convertNumber];
        }
        
        NSString *url = @"users/search/phonebook";
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:arrayPhoneNumber] forKeys: [NSArray arrayWithObject:@"phone_numbers"]];
        
        [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
        
        [[AFCanuAPIClient sharedClient] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *respond = (NSArray *)responseObject;
            
            NSMutableArray *arrayCANUUser = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < [respond count]; i++) {
                User *user = [[User alloc]initWithAttributes:[respond objectAtIndex:i]];
                [arrayCANUUser addObject:user];
            }
            
            if (block) {
                NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:arrayCANUUser];
                appDelegate.arrayContactCanuUser = newArray;
                block(arrayCANUUser,nil);
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
                
                NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
                
                if (block) {
                    block(nil,customError);
                }
                
                if (canuError == CANUErrorServerDown) {
                    [[ErrorManager sharedErrorManager] serverIsDown];
                } else if (canuError == CANUErrorUnknown) {
                    [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"checkPhoneBook:WithBlock:"];
                }
                
            }];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }];
        
    }
    
}

#pragma mark - Counter

- (void)checkCounterWithBlock:(void (^)(NSNumber *countTotal, NSNumber *isCountIn, NSNumber *isUnlock, NSError *error))block{
    
    NSString *url = @"counter/";
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:[NSNumber numberWithInteger:self.userId]] forKeys: [NSArray arrayWithObject:@"user_id"]];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            
            NSNumber *countTotal = [responseObject objectForKey:@"countTotal"];
            NSNumber *isCountIn = [NSNumber numberWithBool:[[responseObject objectForKey:@"isCountIn"] boolValue]];
            NSNumber *isUnlock = [NSNumber numberWithBool:[[responseObject objectForKey:@"isUnlock"] boolValue]];
            block(countTotal, isCountIn, isUnlock,nil);
            
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, nil, nil,error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

- (void)countMeWithBlock:(void (^)(NSError *error))block{
    
    NSString *url = @"counter/";
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:[NSNumber numberWithInteger:self.userId]] forKeys: [NSArray arrayWithObject:@"user_id"]];
    
    [[AFCanuAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", self.token] forHTTPHeaderField:@"Authorization"];
    
    [[AFCanuAPIClient sharedClient] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

@end
