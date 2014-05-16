//
//  Activity.h
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "User.h"
#import "Message.h"



@interface Activity : NSObject //<MKAnnotation>

@property (readonly) BOOL privacyLocation;
@property (readonly) NSUInteger activityId;
@property (readonly) NSUInteger ownerId;
@property (readonly) NSString *title;
@property (readonly) NSString *description;
@property (readonly) NSString *street;
@property (readonly) NSString *placeName;
@property (readonly) NSString *city;
@property (readonly) NSString *zip;
@property (readonly) NSString *country;
@property (readonly) NSDate *start;
@property (readonly) NSDate *end;
@property (readonly) NSString *length;
@property (readonly) NSString *invitationToken;
@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) MKMapItem *location;
@property (readonly) NSURL *pictureUrl;
@property (readonly) NSInteger status;
@property (readonly) NSArray *attendeeIds;
@property (readonly) NSMutableArray *notifications;

@property (readonly) User *user;

- (id)initWithAttributes:(NSDictionary *)attributes;

/**
 *  All activities around the user
 *
 *  @param coordinate
 *  @param block
 */
+ (void)publicFeedWithCoorindate:(CLLocationCoordinate2D)coordinate andUser:(User *)user WithBlock:(void (^)(NSArray *activities, NSError *error))block;

+ (void)createActivityForUserWithTitle:(NSString *)title
                           Description:(NSString *)description
                             StartDate:(NSString *)startDate
                                Length:(NSString *)length
                             PlaceName:(NSString *)placeName
                                Street:(NSString *)street
                                  City:(NSString *)city
                                   Zip:(NSString *)zip
                               Country:(NSString *)country
                              Latitude:(NSString *)latitude
                             Longitude:(NSString *)longitude
                                Guests:(NSMutableArray *)arrayGuests
                       PrivateLocation:(BOOL)privatelocation
                                 Block:(void (^)(Activity *activity,NSError *error))block;

- (void)editActivityForUserWithTitle:(NSString *)title
                         Description:(NSString *)description
                           StartDate:(NSString *)startDate
                              Length:(NSString *)length
                           PlaceName:(NSString *)placeName
                              Street:(NSString *)street
                                City:(NSString *)city
                                 Zip:(NSString *)zip
                             Country:(NSString *)country
                            Latitude:(NSString *)latitude
                           Longitude:(NSString *)longitude
                              Guests:(NSMutableArray *)arrayGuests
                     PrivateLocation:(BOOL)privatelocation
                               Block:(void (^)(NSError *error))block;

- (void)addPeopleActivityWithGuests:(NSMutableArray *)arrayGuests Block:(void (^)(NSError *error))block;

+ (void)activityWithId:(NSUInteger)activityId
              andBlock:(void (^)(Activity *activity, NSError *error))block;

- (void)removeActivityWithBlock:(void (^)(NSError *error))block;

- (void)attendees:(void (^)(NSArray *attendees, NSArray *invitationUser, NSArray *invitationGhostuser, NSError *error))block;
- (void)attendWithBlock:(void (^)(NSArray *activities, NSError *error))block;
- (void)dontAttendWithBlock:(void (^)(NSArray *activities, NSError *error))block;

- (void)messagesWithBlock:(void (^)(NSArray *messages, NSError *error))block;
- (void)newMessage:(NSString *)message
         WithBlock:(void (^)(NSError *error))block;

- (void)deleteNotifications;

+ (NSString *)lengthToString:(NSInteger)length;
- (NSInteger)lengthToInteger;
- (NSString *)locationDescription;

@end
