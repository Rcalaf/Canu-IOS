//
//  User.h
//  CANU
//
//  Created by Roger Calaf on 25/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface User : NSObject <NSCoding>

@property (readonly) NSUInteger userId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *codePhone;
@property (strong, nonatomic) NSURL *profileImageUrl;
@property (strong, nonatomic) NSDictionary *attributes;
@property (nonatomic) BOOL phoneIsVerified;


- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)userWithToken:(NSString *)token
             andBlock:(void (^)(User *user, NSError *error))block;

+ (void)logInWithEmail:(NSString *)userName
              Password:(NSString *)password
                 Block:(void (^)(User *user, NSError *error))block;

+ (void)checkUsername:(NSString *)username
                Block:(void (^)(NSError *error))block; // To delete

+ (void)SignUpWithUserName:(NSString *)userName
                  Password:(NSString*)password
                 FirstName:(NSString *)firstName
                  LastName:(NSString *)lastName
                     Email:(NSString *)email
            ProfilePicture:(UIImage *)profilePicture
                     Block:(void (^)(User *user, NSError *error))block;

+ (void)SignUpWithUserName:(NSString *)userName
                  Password:(NSString*)password
                     Block:(void (^)(User *user, NSError *error))block;

- (void)sendSMSWithCode:(NSInteger)code countrycode:(NSString *)countryCode andPhoneNumber:(NSString *)phoneNumber Block:(void (^)(NSError *error))block;

- (void)phoneNumber:(NSString *)phoneNumber isVerifiedBlock:(void (^)(User *user, NSError *error))block;

/**
 *  Get activities of the user
 *
 *  @param block Activities's user / Errors
 */
- (void)userActivitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block;

/**
 *  Get activities of the tribes's user
 *
 *  @param block Activities's user / Errors
 */
- (void)userActivitiesTribesWithBlock:(void (^)(NSArray *activities, NSError *error))block;

- (void)logOut;

+ (void)sendSMSForResetPasswordWithCode:(NSInteger)code countrycode:(NSString *)countryCode andPhoneNumber:(NSString *)phoneNumber Block:(void (^)(User *user, NSError *error))block;

- (void)editLatitude:(CLLocationDegrees)latitude
           Longitude:(CLLocationDegrees)longitude;

- (void)editUserWithUserName:(NSString *)userName
                    Password:(NSString*)password
                   FirstName:(NSString *)firstName
                    LastName:(NSString *)lastName
                       Email:(NSString *)email
                       Block:(void (^)(User *user, NSError *error))block;

- (void)editPassword:(NSString *) password ForUser:(User *) user Block:(void (^)(User *user, NSError *error))block;

- (void)editUserProfilePicture:(UIImage *)profilePicture
                         Block:(void (^)(User *user, NSError *error))block;

- (void)updateDeviceToken:(NSString *)device_token
                    Block: (void (^)(NSError *error))block;

- (void)updateDevice:(NSString *)device_token
               Badge:(NSInteger)badge
           WithBlock:(void (^)(NSError *))block;

/**
 *  Detec the CANU User with the phone number in the phone book
 *
 *  @param arrayPhoneNumer Array with phone clean number
 *  @param block
 */
- (void)checkPhoneBook:(NSMutableArray*)arrayContact WithBlock:(void (^)(NSMutableArray *arrayCANUUser,NSError *error))block;

- (void)checkCounterWithBlock:(void (^)(NSNumber *countTotal, NSNumber *isCountIn, NSNumber *isUnlock, NSError *error))block;

- (void)countMeWithBlock:(void (^)(NSError *error))block;

@end
