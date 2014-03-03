//
//  AFCanuAPIClient.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AFCanuAPIClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kAFCanuAPIBaseUDistributionRLString = @"http://api.canu.se";
NSString * const kAFCanuAPIDevBaseURLString = @"http://192.168.0.102:3000";
//NSString * const kAFCanuAPIDevBaseURLString = @"http://172.18.61.130:3000";

BOOL const kAFCanuAPIDistributionMode = NO;


@implementation AFCanuAPIClient


+ (AFCanuAPIClient *)sharedClient {
  
    static AFCanuAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        if (kAFCanuAPIDistributionMode) {
            _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAFCanuAPIBaseUDistributionRLString]];
        } else {
            _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAFCanuAPIDevBaseURLString]];
        }
        
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.distributionMode = kAFCanuAPIDistributionMode;
    
    if (self.distributionMode) {
        self.urlBase = kAFCanuAPIBaseUDistributionRLString;
    } else {
        self.urlBase = kAFCanuAPIDevBaseURLString;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
