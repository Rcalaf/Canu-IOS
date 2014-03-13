//
//  Location.h
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, CANULocation) {
    CANULocationMKMapItem = 0,      // MKMapItem
    CANULocationPlaceDetails = 1,   // Place Details API (Google)
    CANULocationFoursquare = 2,     // Place Foursquare Venues API
    CANULocationAutocomplete = 3    // Place for Search Place Autocomplete API (Google)
};

@interface Location : NSObject

@property (nonatomic) CANULocation canuLocation;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) BOOL allInformation;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *displayAdresse;

/**
 *  Reference used for https://developers.google.com/places/documentation/details
 */
@property (strong, nonatomic) NSString *referencePlaceDetails;

/**
 *  MKMapItem used for the Current Location and the custom pin on the map
 */
@property (strong, nonatomic) MKMapItem *locationMap;

/**
 *  Parse MKMapItem
 *
 *  @param item
 *
 *  @return Location full ( if allInformation ==  true )
 */
- (id)initLocationWithMKMapItem:(MKMapItem *)item;

/**
 *  Parse result of https://developers.google.com/places/documentation/autocomplete?hl=fr
 *
 *  @param attributes
 *
 *  @return Always Partial Location ( only : name and displayAdresse )
 */
- (id)initSearchLocationAutocompleteWithAttributes:(NSDictionary *)attributes;

/**
 *  Parse Information of  https://developer.foursquare.com/docs/venues/search
 *
 *  @param attributes
 *
 *  @return Location full ( if allInformation == true )
 */
- (id)initLocationFoursquareWithAttributes:(NSDictionary *)attributes;

/**
 *  Use Place Details API https://developers.google.com/places/documentation/details to grab more information
 *
 *  @param block    Location Full
 */
- (void)addDataLocationAutocompleteBlock:(void (^)(Location *locationFull, NSError *error))block;

/**
 *  Search Location with currentLocation and Search words
 *  If @param searchWords is empty => Foursquare
 *  Else => Place Autocomplete
 *
 *  @param currentLocation Could be empty
 *  @param searchWords     Courld be empty
 *  @param block           
 */
+ (void)searchLocation:(MKMapItem *)currentLocation SearchWords:(NSString *)searchWords Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block;

+ (void)searchLocationMap:(MKLocalSearchResponse *)arrayResponses Block:(void (^)(NSMutableArray *arrayLocation, NSError *error))block;

@end
