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

- (id)initCurrentLocation:(MKMapItem *)item{
    
    self = [super init];
    if (self) {
        
        self.name      = @"";
        self.street    = @"";
        self.city      = @"";
        self.zip       = @"";
        self.country   = @"";
        
        self.locationMap = item;
        
        BOOL allInformation = YES;
    
        if (item.placemark.addressDictionary[@"Street"] != [NSNull null] && item.placemark.addressDictionary[@"Street"] != nil) {
            self.street = item.placemark.addressDictionary[@"Street"];
        } else {
            allInformation = NO;
        }
        
        if (item.placemark.addressDictionary[@"City"] != [NSNull null] && item.placemark.addressDictionary[@"City"] != nil) {
            self.city = item.placemark.addressDictionary[@"City"];
        } else {
            allInformation = NO;
        }
        
        if (item.placemark.addressDictionary[@"ZIP"] != [NSNull null] && item.placemark.addressDictionary[@"ZIP"] != nil) {
            self.zip = item.placemark.addressDictionary[@"ZIP"];
        }
        
        if (item.placemark.addressDictionary[@"Country"] != [NSNull null] && item.placemark.addressDictionary[@"Country"] != nil) {
            self.country = item.placemark.addressDictionary[@"Country"];
        }
        
        if (item.placemark.addressDictionary[@"Country"] != [NSNull null] && item.placemark.addressDictionary[@"Country"] != nil) {
            self.country = item.placemark.addressDictionary[@"Country"];
        }
        
        self.latitude  = item.placemark.location.coordinate.latitude;
        self.longitude = item.placemark.location.coordinate.longitude;
        
        if (allInformation) {
            self.displayAdresse = [NSString stringWithFormat:@"%@, %@",self.street,self.city];
        } else {
            self.displayAdresse = NSLocalizedString(@"Somewhere", nil);
        }
        
        if (item.placemark.addressDictionary[@"Name"] != [NSNull null] && item.placemark.addressDictionary[@"Name"] != nil) {
            self.name = item.placemark.addressDictionary[@"Name"];
        } else {
            if (allInformation) {
                self.name = [NSString stringWithFormat:@"%@, %@",self.street,self.city];
            } else {
                self.name = NSLocalizedString(@"Adress", nil);
            }
            
        }
        
    }
    return self;
}

- (id)initSearchLocationWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (self) {
        
        self.allInformation = YES;
        
        self.name      = @"";
        self.street    = @"";
        self.city      = @"";
        self.zip       = @"";
        self.country   = @"";
        
        if ([attributes objectForKey:@"name"] != [NSNull null] && [attributes objectForKey:@"name"] != nil) {
            self.name      = [attributes objectForKey:@"name"];
        } else {
            self.allInformation = NO;
        }
        
        if ([[attributes objectForKey:@"location"] objectForKey:@"address"] != [NSNull null] && [[attributes objectForKey:@"location"] objectForKey:@"address"] != nil) {
            self.street      = [[attributes objectForKey:@"location"] objectForKey:@"address"];
        } else {
            self.allInformation = NO;
        }
        
        if ([[attributes objectForKey:@"location"] objectForKey:@"city"] != [NSNull null] && [[attributes objectForKey:@"location"] objectForKey:@"city"] != nil) {
            self.city      = [[attributes objectForKey:@"location"] objectForKey:@"city"];
        } else {
            self.allInformation = NO;
        }
        
        if ([[attributes objectForKey:@"location"] objectForKey:@"postalCode"] != [NSNull null] && [[attributes objectForKey:@"location"] objectForKey:@"postalCode"] != nil) {
            self.zip       = [[attributes objectForKey:@"location"] objectForKey:@"postalCode"];
        } else {
            self.allInformation = NO;
        }
        
        if ([[attributes objectForKey:@"location"] objectForKey:@"country"] != [NSNull null] && [[attributes objectForKey:@"location"] objectForKey:@"country"] != nil) {
            self.country       = [[attributes objectForKey:@"location"] objectForKey:@"country"];
        } else {
            self.allInformation = NO;
        }
        
        if ([[attributes objectForKey:@"location"] objectForKey:@"lat"] != [NSNull null] && [[attributes objectForKey:@"location"] objectForKey:@"lat"] != nil) {
            self.latitude  = [[[attributes objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        } else {
            self.allInformation = NO;
        }
        
        if ([[attributes objectForKey:@"location"] objectForKey:@"lat"] != [NSNull null] && [[attributes objectForKey:@"location"] objectForKey:@"lng"] != nil) {
            self.longitude  = [[[attributes objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        } else {
            self.allInformation = NO;
        }
        
        if (_allInformation) {
            self.displayAdresse = [NSString stringWithFormat:@"%@, %@",self.street,self.city];
        }
        
    }
    return self;
}

#pragma mark - Public

+ (void)searchLocation:(MKMapItem *)currentLocation SearchWords:(NSString *)searchWords Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block{
    
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *url;
    
    if (!searchWords || [searchWords mk_isEmpty]) {
        url = @"https://api.foursquare.com/v2/venues/search?ll=59.292874,17.993225&query=&limit=10&intent=browse&radius=800&oauth_token=01SK0VSRTMIFZUMB0DWDJRZBE00S2FNSKX0SFK3ZXBJDR5IA&v=20140217";
    } else {
        url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&limit=10&oauth_token=01SK0VSRTMIFZUMB0DWDJRZBE00S2FNSKX0SFK3ZXBJDR5IA&v=20140214",appDelegate.currentLocation.latitude,appDelegate.currentLocation.longitude,[searchWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
        
        if (!searchWords || [searchWords mk_isEmpty]) {
            if (currentLocation) {
                
                Location *location = [[Location alloc]initCurrentLocation:currentLocation];
                location.name = NSLocalizedString(@"Current Location", nil);
                [arrayLocation addObject:location];
                
            }
        }
        
        NSArray *arrayJson = [[JSON objectForKey:@"response"] objectForKey:@"venues"];
        
        for (int i = 0; i < [arrayJson count]; i++) {
            
            NSDictionary *dic = [arrayJson objectAtIndex:i];
            
            Location *location = [[Location alloc]initSearchLocationWithAttributes:dic];
            if (location.allInformation) {
                [arrayLocation addObject:location];
            }
            
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
        
//        [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
//            
//            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
//            
//            if (block) {
//                block([NSArray alloc],customError);
//            }
//            
//            if (canuError == CANUErrorServerDown) {
//                [[ErrorManager sharedErrorManager] serverIsDown];
//            } else if (canuError == CANUErrorUnknown) {
//                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"User" function:@"userActivitiesWithBlock:"];
//            }
//            
//        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

+ (void)searchLocationMap:(MKLocalSearchResponse *)arrayResponses Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block{
    
    NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [arrayResponses.mapItems count]; i++) {
        
        MKMapItem *item = arrayResponses.mapItems[i];
        
        Location *location = [[Location alloc]initCurrentLocation:item];
        [arrayLocation addObject:location];
        
    }
    
    if (block) {
        block(arrayLocation,nil);
    }
    
}

@end
