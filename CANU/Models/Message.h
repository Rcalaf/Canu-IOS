//
//  Message.h
//  CANU
//
//  Created by Roger Calaf on 15/11/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject

@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) User *user;


-(id)initWithAttributes:(NSDictionary *)attributes;

- (void)addDate:(NSDate *)date;

@end
