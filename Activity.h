//
//  Activity.h
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import "Message.h"



@interface Activity : NSObject //<MKAnnotation>

@property (readonly) NSUInteger activityId;
@property (readonly) NSUInteger ownerId;
@property (readonly) NSString *title;
@property (readonly) NSString *description;
@property (readonly) NSString *street;
@property (readonly) NSString *city;
@property (readonly) NSString *zip;
@property (readonly) NSString *country;
@property (readonly) NSDate *start;
@property (readonly) NSDate *end;
@property (readonly) NSString *length;
//@property (readonly) CLLocationDegrees latitude;
//@property (readonly) CLLocationDegrees longitude;
@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) MKMapItem *location;
@property (readonly) NSURL *pictureUrl;
@property (readonly) int status;
@property (readonly) NSArray *attendeeIds;

@property (readonly) User *user;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)publicFeedWithCoorindate:(CLLocationCoordinate2D)coordinate WithBlock:(void (^)(NSArray *activities, NSError *error))block;
+ (void)createActivityForUserWithTitle:(NSString *)title
                           Description:(NSString *)description
                             StartDate:(NSString *)startDate
                                Length:(NSString *)length
                               EndDate:(NSString *)endDate
                                Street:(NSString *)street
                                  City:(NSString *)city
                                   Zip:(NSString *)zip
                               Country:(NSString *)country
                              Latitude:(NSString *)latitude
                             Longitude:(NSString *)longitude
                                 Image:(UIImage *)activityImage
                                 Block:(void (^)(NSError *error))block;

- (void)editActivityForUserWithTitle:(NSString *)title
                         Description:(NSString *)description
                           StartDate:(NSString *)startDate
                              Length:(NSString *)length
                             EndDate:(NSString *)endDate
                              Street:(NSString *)street
                                City:(NSString *)city
                                 Zip:(NSString *)zip
                             Country:(NSString *)country
                            Latitude:(NSString *)latitude
                           Longitude:(NSString *)longitude
                               Image:(UIImage *)activityImage
                               Block:(void (^)(NSError *error))block;

- (void)removeActivityWithBlock:(void (^)(NSError *error))block;

- (void)attendees:(void (^)(NSArray *attendees, NSError *error))block;
- (void)attendWithBlock:(void (^)(NSArray *activities, NSError *error))block;
- (void)dontAttendWithBlock:(void (^)(NSArray *activities, NSError *error))block;

- (void)messagesWithBlock:(void (^)(NSArray *messages, NSError *error))block;
- (void)newMessage:(NSString *)message
         WithBlock:(void (^)(NSError *error))block;

+ (NSString *)lengthToString:(NSInteger)length;
- (NSInteger)lengthToInteger;
//- (NSDate *)startDate;
- (NSString *)locationDescription;
//- (void)populateLocationDataWith:(MKMapItem *)mapItem;



@end
