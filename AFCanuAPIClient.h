//
//  AFCanuAPIClient.h
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface AFCanuAPIClient : AFHTTPClient

@property (nonatomic) BOOL distributionMode;
@property (nonatomic) NSString *urlBase;

+ (AFCanuAPIClient *)sharedClient;

@end

