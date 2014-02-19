//
//  Location.h
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface Location : NSObject

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) BOOL allInformation;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *displayAdresse;
@property (strong, nonatomic) MKMapItem *locationMap;

- (id)initCurrentLocation:(MKMapItem *)currentLocation;

- (id)initSearchLocationWithAttributes:(NSDictionary *)attributes;

+ (void)searchLocation:(MKMapItem *)currentLocation SearchWords:(NSString *)searchWords Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block;

+ (void)searchLocationMap:(MKLocalSearchResponse *)arrayResponses Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block;

@end
