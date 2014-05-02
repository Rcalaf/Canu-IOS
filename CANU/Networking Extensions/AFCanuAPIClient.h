//
//  AFCanuAPIClient.h
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface AFCanuAPIClient : AFHTTPRequestOperationManager

@property (nonatomic) NSString *urlBase;

+ (AFCanuAPIClient *)sharedClient;

+ (BOOL)distributionMode;

@end

