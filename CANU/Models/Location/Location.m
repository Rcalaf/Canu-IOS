//
//  Location.m
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "Location.h"

#import "AppDelegate.h"
#import "UserManager.h"

#import "AFCanuAPIClient.h"

@implementation Location

#pragma mark - Lifecycle

/**
 *  Parse MKMapItem
 *
 *  @param item
 *
 *  @return Location full ( if allInformation ==  true )
 */
- (id)initLocationWithMKMapItem:(MKMapItem *)item{
    
    self = [super init];
    if (self) {
        
        self.canuLocation = CANULocationMKMapItem;
        
        self.name      = @"";
        self.street    = @"";
        self.city      = @"";
        self.zip       = @"";
        self.country   = @"";
        
        self.locationMap = item;
        
        self.allInformation = YES;
    
        if (![item.placemark.addressDictionary[@"Street"] mk_isEmpty] && item.placemark.addressDictionary[@"Street"] != nil) {
            self.street = item.placemark.addressDictionary[@"Street"];
        } else {
            self.allInformation = NO;
        }
        
        if (![item.placemark.addressDictionary[@"City"] mk_isEmpty] && item.placemark.addressDictionary[@"City"] != nil) {
            self.city = item.placemark.addressDictionary[@"City"];
        } else {
            self.allInformation = NO;
        }
        
        if (![item.placemark.addressDictionary[@"ZIP"] mk_isEmpty] && item.placemark.addressDictionary[@"ZIP"] != nil) {
            self.zip = item.placemark.addressDictionary[@"ZIP"];
        } else {
            self.allInformation = NO;
        }
        
        if (![item.placemark.addressDictionary[@"Country"] mk_isEmpty] && item.placemark.addressDictionary[@"Country"] != nil) {
            self.country = item.placemark.addressDictionary[@"Country"];
        } else {
            self.allInformation = NO;
        }
        
        self.latitude  = item.placemark.location.coordinate.latitude;
        self.longitude = item.placemark.location.coordinate.longitude;
        
        if (self.allInformation) {
            self.displayAdresse = [NSString stringWithFormat:@"%@, %@",self.street,self.city];
        } else {
            self.displayAdresse = NSLocalizedString(@"Somewhere", nil);
        }
        
        if (item.placemark.addressDictionary[@"Name"] != [NSNull null] && ![item.placemark.addressDictionary[@"Name"] mk_isEmpty] && item.placemark.addressDictionary[@"Name"] != nil) {
            self.name = item.placemark.addressDictionary[@"Name"];
        } else if (self.allInformation) {
            if (self.allInformation) {
                self.name = [NSString stringWithFormat:@"%@, %@",self.street,self.city];
            } else {
                self.name = NSLocalizedString(@"Adress", nil);
            }
        }
        
    }
    return self;
}

/**
 *  Parse result of https://developers.google.com/places/documentation/autocomplete?hl=fr
 *
 *  @param attributes
 *
 *  @return Always Partial Location ( only : name and displayAdresse )
 */
- (id)initSearchLocationAutocompleteWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (self) {
        
        self.canuLocation = CANULocationAutocomplete;
        
        self.allInformation = NO;
        
        self.name      = @"";
        self.street    = @"";
        self.city      = @"";
        self.zip       = @"";
        self.country   = @"";
        self.displayAdresse = @"";
        
        if ([attributes objectForKey:@"terms"] != [NSNull null] && [attributes objectForKey:@"terms"] != nil) {
            
            for (int i = 0; i < [[attributes objectForKey:@"terms"] count]; i++) {
                
                if (i == 0) {
                    self.name = [[[attributes objectForKey:@"terms"] objectAtIndex:i] objectForKey:@"value"];
                } else if (i == 1) {
                    self.displayAdresse = [[[attributes objectForKey:@"terms"] objectAtIndex:i] objectForKey:@"value"];
                    self.allInformation = YES;
                } else {
                    self.displayAdresse = [NSString stringWithFormat:@"%@ %@",self.displayAdresse,[[[attributes objectForKey:@"terms"] objectAtIndex:i] objectForKey:@"value"]];
                }
                
            }
            
        }
        
        if ([attributes objectForKey:@"reference"] != [NSNull null] && [attributes objectForKey:@"reference"] != nil) {
            
            self.referencePlaceDetails = [attributes objectForKey:@"reference"];
            
        } else {
            self.allInformation = NO;
        }
        
    }
    return self;
}

/**
 *  Parse Information of  https://developer.foursquare.com/docs/venues/search
 *
 *  @param attributes
 *
 *  @return Location full ( if allInformation == true )
 */
- (id)initLocationPlaceSearchWithAttributes:(NSDictionary *)attributes{
    
    self = [super init];
    if (self) {
        
        self.canuLocation = CANULocationPlaceSearch;
        
        self.allInformation = YES;
        
        self.name      = @"";
        self.street    = @"";
        self.city      = @"";
        self.zip       = @"";
        self.country   = @"";
        self.displayAdresse = @"";
        
        if ([attributes objectForKey:@"name"] != [NSNull null] && [attributes objectForKey:@"name"] != nil) {
            self.name      = [attributes objectForKey:@"name"];
        } else {
            self.allInformation = NO;
        }
        
        if ([attributes objectForKey:@"vicinity"] != [NSNull null] && [attributes objectForKey:@"vicinity"] != nil) {
            self.displayAdresse      = [attributes objectForKey:@"vicinity"];
        } else {
            self.allInformation = NO;
        }

        if ([attributes objectForKey:@"reference"] != [NSNull null] && [attributes objectForKey:@"reference"] != nil) {
            
            self.referencePlaceDetails = [attributes objectForKey:@"reference"];
            
        } else {
            self.allInformation = NO;
        }
        
    }
    return self;
}

- (void)addMoreDataWithAttributes:(NSDictionary *)attributes{
    
    NSArray *addressComponents = [[attributes objectForKey:@"result"] objectForKey:@"address_components"];
    
    for (int i = 0; i < [addressComponents count]; i++) {
    
        if ([[addressComponents objectAtIndex:i] objectForKey:@"types"] != [NSNull null] && [[addressComponents objectAtIndex:i] objectForKey:@"types"] != nil) {
            
            NSArray *types = [[addressComponents objectAtIndex:i] objectForKey:@"types"];
            
            NSString *data = [[addressComponents objectAtIndex:i] objectForKey:@"long_name"];
            
            for (int y = 0; y < [types count]; y++) {
                
                if ([[types objectAtIndex:y] isEqualToString:@"route"]) {
                    self.street = data;
                }
                
                if ([[types objectAtIndex:y] isEqualToString:@"locality"]) {
                    self.city = data;
                }
                
                if ([[types objectAtIndex:y] isEqualToString:@"country"]) {
                    self.country = data;
                }
                
                if ([[types objectAtIndex:y] isEqualToString:@"postal_code"]) {
                    self.zip = data;
                }
                
            }
            
        }
    
    }
    
    NSDictionary *coord = [[[attributes objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
    
    if ([coord objectForKey:@"lat"] != [NSNull null] && [coord objectForKey:@"lat"] != nil) {
        self.latitude = [[coord objectForKey:@"lat"] floatValue];
    }
    
    if ([coord objectForKey:@"lng"] != [NSNull null] && [coord objectForKey:@"lng"] != nil) {
        self.longitude = [[coord objectForKey:@"lng"] floatValue];
    }
    
}

#pragma mark - Public

/**
 *  Use Place Details API https://developers.google.com/places/documentation/details to grab more information
 *
 *  @param block    Location Full
 */
- (void)addFullDataLocationBlock:(void (^)(Location *locationFull, NSError *error))block{
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyAG-D8gSvKf5rUZtEklnWFXCK2ZgGpj7PM",self.referencePlaceDetails];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[AFCanuAPIClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self addMoreDataWithAttributes:responseObject];
        
        if (block) {
            block(self, nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@",error);
        if (block) {
            
            NSError *error = [NSError errorWithDomain:@"CANUError" code:12 userInfo:nil];
            
            block(nil,error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

/**
 *  Search Location with currentLocation and Search words
 *  If @param searchWords is empty => Foursquare
 *  Else => Place Autocomplete
 *
 *  @param currentLocation Could be empty
 *  @param searchWords     Courld be empty
 *  @param block           
 */
+ (void)searchLocation:(MKMapItem *)currentLocation SearchWords:(NSString *)searchWords Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block{
    
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *url;
    
    if (!searchWords || [searchWords mk_isEmpty]) {
//        url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=&limit=10&intent=browse&radius=800&oauth_token=01SK0VSRTMIFZUMB0DWDJRZBE00S2FNSKX0SFK3ZXBJDR5IA&v=20140217",appDelegate.currentLocation.latitude,appDelegate.currentLocation.longitude];
        url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAG-D8gSvKf5rUZtEklnWFXCK2ZgGpj7PM&location=%f,%f&radius=800&sensor=true&types=amusement_park%%7Caquarium%%7Cart_gallery%%7Cbar%%7Cbowling_alley%%7Ccafe%%7Ccampground%%7Ccasino%%7Cchurch%%7Ccourthouse%%7Cestablishment%%7Cfood%%7Cgrocery_or_supermarket%%7Cgym%%7Chair_care%%7Chealth%%7Chindu_temple%%7Cjewelry_store%%7Claundry%%7Clibrary%%7Clocksmith%%7Clodging%%7Cmovie_theater%%7Cmoving_company%%7Cmuseum%%7Cnight_club%%7Cpark%%7Cplace_of_worship%%7Crestaurant%%7Crv_par%%7C%%7Cschool%%7Cshopping_mall%%7Cspa%%7Cstadium%%7Cstore%%7Csynagogue%%7Cuniversity%%7Czoo",appDelegate.currentLocation.latitude,appDelegate.currentLocation.longitude];
        [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else {
        
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%f,%f&input=%@&sensor=true&language=%@&key=AIzaSyAG-D8gSvKf5rUZtEklnWFXCK2ZgGpj7PM",appDelegate.currentLocation.latitude,appDelegate.currentLocation.longitude,[searchWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],language];
        
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    [[AFCanuAPIClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arrayLocation = [[NSMutableArray alloc]init];
        NSArray *arrayJson;
        
        if (!searchWords || [searchWords mk_isEmpty]) {
            if (currentLocation) {
                
                Location *location = [[Location alloc]initLocationWithMKMapItem:currentLocation];
                location.name = NSLocalizedString(@"Current Location", nil);
                [arrayLocation addObject:location];
                
            }
            
            arrayJson = [responseObject objectForKey:@"results"];
            
        } else {
            arrayJson = [responseObject objectForKey:@"predictions"];
        }
        
        
        for (int i = 0; i < [arrayJson count]; i++) {
            
            NSDictionary *dic = [arrayJson objectAtIndex:i];
            
            Location *location;
            
            if (!searchWords || [searchWords mk_isEmpty]) {
                location = [[Location alloc]initLocationPlaceSearchWithAttributes:dic];
                if (location.allInformation) {
                    [arrayLocation addObject:location];
                }
            } else {
                location = [[Location alloc]initSearchLocationAutocompleteWithAttributes:dic];
                if (location.allInformation) {
                    [arrayLocation addObject:location];
                }
            }
            
        }
        
        if (block) {
            block(arrayLocation, nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error : %@",error);
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
        
        Location *location = [[Location alloc]initLocationWithMKMapItem:item];
        [arrayLocation addObject:location];
        
    }
    
    if (block) {
        block(arrayLocation,nil);
    }
    
}

@end
