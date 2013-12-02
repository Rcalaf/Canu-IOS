//
//  Message.m
//  CANU
//
//  Created by Roger Calaf on 15/11/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize text = _text;
@synthesize date = _date;
@synthesize user = _user;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    //NSLog(@"%@",attributes);
    _text = [attributes valueForKeyPath:@"text"];
    
    _date = [attributes valueForKeyPath:@"created_at"];
    _user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    return self;
}



@end
