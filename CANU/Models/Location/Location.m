//
//  Location.m
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "Location.h"

#import "AppDelegate.h"

#import "AFCanuAPIClient.h"

@implementation Location

#pragma mark - Lifecycle

- (id)initCurrentLocation:(MKMapItem *)currentLocation{
    
    self = [super init];
    if (self) {
        
        self.name    = @"";
        self.street  = @"";
        self.city    = @"";
        self.zip     = @"";
        self.country = @"";
        
        self.name    = NSLocalizedString(@"Current Location", nil);
        self.street  = currentLocation.placemark.addressDictionary[@"Street"];
        self.city    = currentLocation.placemark.addressDictionary[@"City"];
        self.zip     = currentLocation.placemark.addressDictionary[@"ZIP"];
        self.country = currentLocation.placemark.addressDictionary[@"Country"];
        
    }
    return self;
}

- (id)initSearchLocationWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (self) {
        
        self.name    = @"";
        self.street  = @"";
        self.city    = @"";
        self.zip     = @"";
        self.country = @"";
        
        self.name    = [attributes objectForKey:@"name"];
        self.street  = [[attributes objectForKey:@"location"] objectForKey:@"address"];
        self.city    = [[attributes objectForKey:@"location"] objectForKey:@"city"];
        self.zip     = [[attributes objectForKey:@"location"] objectForKey:@"postalCode"];
        self.country = [[attributes objectForKey:@"location"] objectForKey:@"country"];
        
    }
    return self;
}

#pragma mark - Public

+ (void)seacrhLocation:(MKMapItem *)currentLocation SearchWords:(NSString *)searchWords Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block{
    
    if (!searchWords || [searchWords mk_isEmpty]) {
        
        NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
        
        if (currentLocation) {
            
            Location *location = [[Location alloc]initCurrentLocation:currentLocation];
            [arrayLocation addObject:location];
            
        }
        
        if (block) {
            block(arrayLocation,nil);
        }
        
    } else {
        
        
        
        AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&limit=4&oauth_token=01SK0VSRTMIFZUMB0DWDJRZBE00S2FNSKX0SFK3ZXBJDR5IA&v=20140214",appDelegate.currentLocation.latitude,appDelegate.currentLocation.longitude,[searchWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [[AFCanuAPIClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
            
            NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
            
            NSArray *arrayJson = [[JSON objectForKey:@"response"] objectForKey:@"venues"];
            
            int maxObject = 4;
            
            if (maxObject > [arrayJson count]) {
                maxObject = [arrayJson count];
            }
            
            for (int i = 0; i < maxObject; i++) {
                
                NSDictionary *dic = [arrayJson objectAtIndex:i];
                
                Location *location = [[Location alloc]initSearchLocationWithAttributes:dic];
                [arrayLocation addObject:location];
                
            }
            
            if (block) {
                block(arrayLocation, nil);
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (block) {
                
                NSError *error = [NSError errorWithDomain:@"CANUError" code:12 userInfo:nil];
                
                block(nil,error);
            }
            
//            [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
//                
//                NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
//                
//                if (block) {
//                    block([NSArray alloc],customError);
//                }
//                
//                if (canuError == CANUErrorServerDown) {
//                    [[ErrorManager sharedErrorManager] serverIsDown];
//                } else if (canuError == CANUErrorUnknown) {
//                    [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"userActivitiesWithBlock:"];
//                }
//                
//            }];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
    }
    
}

@end
