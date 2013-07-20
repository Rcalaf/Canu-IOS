//
//  Activity.m
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Activity.h"
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"

@implementation Activity

@synthesize activityId = _activityId;
@synthesize ownerId = _ownerId;
@synthesize title = _title;
@synthesize description = _description;
@synthesize picture = _picture;

//@synthesize user = _user;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityId = [[attributes valueForKeyPath:@"id"] integerValue];
    _title = [attributes valueForKeyPath:@"title"];
    _ownerId = [[attributes valueForKeyPath:@"user_id"] integerValue];
 // _description= [attributes valueForKeyPath:@"description"];
        
    return self;
}


+ (void)publicFeedWithBlock:(void (^)(NSArray *activities, NSError *error))block {

    [[AFCanuAPIClient sharedClient] getPath:@"activities/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        //NSLog(@"%lu",(unsigned long)[[JSON objectForKey:@"activities"] count]);
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        //NSLog(@"%lu",(unsigned long)[mutableActivities count]);
        for (NSDictionary *attributes in JSON) {
             NSLog(@"%@",attributes);
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            [mutableActivities addObject:activity];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
    
}




- (void)removeActivityFromUserWithBlock:(void (^)(NSError *error))block {
    
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];

    NSString *path = [NSString stringWithFormat:@"/users/%lu/activities/%lu",(unsigned long)appDelegate.user.userId,(unsigned long)self.activityId];
    [[AFCanuAPIClient sharedClient] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        if (block) {
            block(nil);
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}




@end
