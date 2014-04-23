//
//  PushRemote.h
//  CANU
//
//  Created by Vivien Cormier on 15/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PushRemoteAction) {
    PushRemoteActionChat = 1,
    PushRemoteActionEditActivity = 2,
    PushRemoteActionUserGo = 3,
    PushRemoteActionUserDontGo = 4,
    PushRemoteActionDeleteActivity = 5,
    PushRemoteActionNewActivityInvit = 6,
    PushRemoteActionNewActivityAround = 7
};

typedef NS_ENUM(NSInteger, PushRemoteType) {
    PushRemoteTypeDeepLinking = 1,
    PushRemoteTypeNotification = 2
};

@interface PushRemote : NSObject

@property (nonatomic) PushRemoteType pushRemoteType;
@property (nonatomic) PushRemoteAction pushRemoteAction;
@property (nonatomic) NSInteger activityID;

- (instancetype)initWitApplication:(UIApplication *)application AndUserInfo:(NSDictionary *)userInfo;

@end
