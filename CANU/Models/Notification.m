//
//  Notification.m
//  CANU
//
//  Created by Vivien Cormier on 14/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "Notification.h"
#import "User.h"
#import "Activity.h"
#import "AFCanuAPIClient.h"

@implementation Notification

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self updateWithAttributes:attributes];
    
    return self;
}

- (void)updateWithAttributes:(NSDictionary *)attributes{
    
    NSDictionary *dic = [attributes objectForKey:@"notification"];
    
    NSInteger type = [[dic objectForKey:@"type_notifications"] integerValue];
    
    if (type == 1) {
        self.text = NSLocalizedString(@"New activity with your tribe", nil);
    } else if (type == 2) {
        self.text = NSLocalizedString(@"New activity around you", nil);
    } else if (type == 3) {
        self.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"attribute_3_4"],NSLocalizedString(@"is going", nil)];
    } else if (type == 4) {
        self.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"attribute_3_4"],NSLocalizedString(@"is no longer going", nil)];
    } else if (type == 5) {
        self.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"New name for", nil),[dic objectForKey:@"attribute_5"]];
    } else if (type == 6) {
        self.text = NSLocalizedString(@"New date", nil);
    } else if (type == 7) {
        self.text = NSLocalizedString(@"New place", nil);
    } else if (type == 8) {
        self.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"New message from", nil),[dic objectForKey:@"attribute_8"]];
    }
    
}

#pragma mark - Public

+ (void)readNotificationsForUser:(User *)user ToActivity:(Activity *)activity Block:(void (^)(NSError *error))block{
    
    NSString *url = [NSString stringWithFormat:@"/notifications/%lu/activities/%lu",(unsigned long)user.userId,(unsigned long)activity.activityId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFCanuAPIClient *operation = [AFCanuAPIClient sharedClient];
    
    [operation.requestSerializer setValue:[NSString stringWithFormat:@"Token token=\"%@\"", user.token] forHTTPHeaderField:@"Authorization"];
    
    [operation GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger countNotification = [[responseObject objectForKey:@"number_notifications"] integerValue];
        
        UIApplication *application = [UIApplication sharedApplication];
        application.applicationIconBadgeNumber = countNotification;
        
        if (block) {
            block(nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            NSLog(@"%@",error);
            block(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

@end
