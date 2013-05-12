//
//  Activity.h
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (readonly) NSUInteger activityID;
@property (readonly) NSString *text;

//@property (readonly) User *user;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)userActivitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block;

@end
