//
//  Notification.h
//  CANU
//
//  Created by Vivien Cormier on 14/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, Activity;

@interface Notification : NSObject

@property (nonatomic) BOOL isRead;
@property (strong, nonatomic) NSString *text;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)readNotificationsForUser:(User *)user ToActivity:(Activity *)activity Block:(void (^)(NSError *error))block;

@end
