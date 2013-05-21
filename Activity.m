//
//  Activity.m
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Activity.h"
#import "AFCanuAPIClient.h"

@implementation Activity

@synthesize activityId = _activityId;
@synthesize title = _title;
@synthesize description = _description;

//@synthesize user = _user;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityId = [[attributes valueForKeyPath:@"id"] integerValue];
    _title = [attributes valueForKeyPath:@"title"];
    
   //_user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    
    return self;
}


+ (void)userActivitiesWithBlock:(void (^)(NSArray *activities, NSError *error))block {
    [[AFCanuAPIClient sharedClient] getPath:@"activities/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"%@",JSON);
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
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




@end
