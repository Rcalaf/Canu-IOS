//
//  Activity.m
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Activity.h"

@implementation Activity

@synthesize activityID = _activityID;
@synthesize text = _text;

//@synthesize user = _user;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityID = [[attributes valueForKeyPath:@"id"] integerValue];
    _text = [attributes valueForKeyPath:@"text"];
    
   //_user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    
    return self;
}

@end
