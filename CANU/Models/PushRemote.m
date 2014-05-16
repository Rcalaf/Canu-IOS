//
//  PushRemote.m
//  CANU
//
//  Created by Vivien Cormier on 15/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "PushRemote.h"

@implementation PushRemote

- (instancetype)initWitApplication:(UIApplication *)application AndUserInfo:(NSDictionary *)userInfo{
    self = [super init];
    if (self) {
        
        if ( application.applicationState == UIApplicationStateActive ){
            self.pushRemoteType = PushRemoteTypeNotification;
        } else {
            self.pushRemoteType = PushRemoteTypeDeepLinking;
        }
        
        if ([[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"id"] != [NSNull null] && [[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"id"] != nil) {
            self.activityID   = [[[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"id"] integerValue];
        }
        
        if ([[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"type"] != [NSNull null] && [[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"type"] != nil) {
            
            NSString *type = [[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"type"];
            
            if ([type isEqualToString:@"chat"]) {
                self.pushRemoteAction = PushRemoteActionChat;
            }
            
            if ([type isEqualToString:@"edit activity"]) {
                self.pushRemoteAction = PushRemoteActionEditActivity;
            }
            
            if ([type isEqualToString:@"new invit"]) {
                self.pushRemoteAction = PushRemoteActionUserGo;
            }
            
            if ([type isEqualToString:@"remove invit"]) {
                self.pushRemoteAction = PushRemoteActionUserDontGo;
            }
            
            if ([type isEqualToString:@"delete activity"]) {
                self.pushRemoteAction = PushRemoteActionDeleteActivity;
            }
            
            if ([type isEqualToString:@"create activity around"]) {
                self.pushRemoteAction = PushRemoteActionNewActivityAround;
            }
            
            if ([type isEqualToString:@"create activity invit"]) {
                self.pushRemoteAction = PushRemoteActionNewActivityInvit;
            }
            
        }
        
        self.text = [[userInfo valueForKeyPath:@"aps"] valueForKeyPath:@"alert"];
        
    }
    return self;
}

@end
