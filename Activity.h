//
//  Activity.h
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (readonly) NSUInteger activityId;
@property (readonly) NSUInteger ownerId;
@property (readonly) NSString *title;
@property (readonly) NSString *description;
@property (readonly) UIImage *picture;


//@property (readonly) User *user;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)activitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block;
- (void)removeActivityFromUserWithBlock:(void (^)(NSError *error))block;

@end
