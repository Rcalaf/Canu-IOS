//
//  AFCanuAPIClient.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AFCanuAPIClient.h"
#import "AFURLResponseSerialization.h"

NSString * const kAFCanuAPIBaseUDistributionRLString = @"https://api.canu.se";
//NSString * const kAFCanuAPIDevBaseURLString = @"https://api.canu.se";
NSString * const kAFCanuAPIDevBaseURLString = @"http://172.18.61.130:3000";

// Change with Product / Scheme / Edit Scheme / Run CANU.app / Build Configuration / (Release | Debug)
#ifdef DEBUG
    BOOL const kAFCanuAPIDistributionMode = NO;
#else
    BOOL const kAFCanuAPIDistributionMode = YES;
#endif

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
    
    self.securityPolicy.allowInvalidCertificates = YES;
    
    if (kAFCanuAPIDistributionMode) {
        self.urlBase = kAFCanuAPIBaseUDistributionRLString;
    } else {
        self.urlBase = kAFCanuAPIDevBaseURLString;
    }
    
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];

    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return self;
}

+ (BOOL)distributionMode{
    
    return kAFCanuAPIDistributionMode;
    
}

@end
