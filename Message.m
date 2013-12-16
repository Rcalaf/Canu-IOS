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

- (void)setDate:(id)date{
    
    if ([[date class] isKindOfClass:[NSDate class]] ) {
        _date = date;
    } else {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSArray *dateParts = [date componentsSeparatedByString:@"T"];
        NSArray *dayParts = [[dateParts objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSArray *timeParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@":"];
        [comps setYear:[[dayParts objectAtIndex:0] integerValue]];
        [comps setMonth:[[dayParts objectAtIndex:1] integerValue]];
        [comps setDay:[[dayParts objectAtIndex:2] integerValue]];
        
        [comps setHour:[[timeParts objectAtIndex:0] integerValue]];
        [comps setMinute:[[timeParts objectAtIndex:1] integerValue]];
        [comps setSecond:[[timeParts objectAtIndex:2] integerValue]];
        _date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    }
    
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    //NSLog(@"%@",attributes);
    _text = [attributes valueForKeyPath:@"text"];
    
    self.date = [attributes valueForKeyPath:@"created_at"];
    _user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    return self;
}



@end
