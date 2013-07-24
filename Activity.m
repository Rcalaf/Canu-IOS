//
//  Activity.m
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Activity.h"
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"
#import "AFNetworking.h"
#import "UICanuActivityCell.h"

@interface Activity ()
- (NSDictionary *)serialize;
@end

@implementation Activity

@synthesize activityId = _activityId;
@synthesize ownerId = _ownerId;
@synthesize title = _title;
@synthesize description = _description;
@synthesize start = _start;
@synthesize length = _length;
@synthesize street = _street;
@synthesize city =_city;
@synthesize zip = _zip;
@synthesize country = _country;
@synthesize pictureUrl = _picture;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize user = _user;
@synthesize location = _location;


- (MKMapItem *)location {
    NSArray *objectsArray = [NSArray arrayWithObjects:self.street,self.city,self.zip,self.country,nil];
   
    NSArray *keysArray = [NSArray arrayWithObjects:@"Street",@"City",@"ZIP",@"Country",nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
 
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) addressDictionary:parameters];

    _location = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    return _location;
}

- (void)populateLocationDataWith:(MKMapItem *)mapItem
{
    _street = mapItem.placemark.addressDictionary[@"Street"];
    _city = mapItem.placemark.addressDictionary[@"City"];
    _zip = mapItem.placemark.addressDictionary[@"ZIP"];
    _country = mapItem.placemark.addressDictionary[@"Country"];
    _longitude = mapItem.placemark.coordinate.latitude;
    _latitude = mapItem.placemark.coordinate.longitude;

}

- (NSInteger)status
{
    NSInteger status;
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
   // NSLog(@"%d user:%d owner: %d",appDelegate.user.userId == self.ownerId,appDelegate.user.userId,self.ownerId);
    if (self.ownerId == appDelegate.user.userId) {
        status = UICanuActivityCellEditable;
    }else{
        status = UICanuActivityCellToGo;
    }
    return status;
}

- (NSDate *)startDate
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSArray *dateParts = [self.start componentsSeparatedByString:@"T"];
    NSArray *dayParts = [[dateParts objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *timeParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@":"];
    [comps setYear:[[dayParts objectAtIndex:0] integerValue]];
    [comps setMonth:[[dayParts objectAtIndex:1] integerValue]];
    [comps setDay:[[dayParts objectAtIndex:2] integerValue]];

    [comps setHour:[[timeParts objectAtIndex:0] integerValue]];
    [comps setMinute:[[timeParts objectAtIndex:1] integerValue]];
    [comps setSecond:[[timeParts objectAtIndex:2] integerValue]];

    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return date;
}

- (NSDate *)endDate
{
    NSDate *date;
    return date;
}

- (NSString *)locationDescription
{
    return [NSString stringWithFormat:@"%@, %@, %@",self.street,self.city,self.zip];
}


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _activityId = [[attributes valueForKeyPath:@"id"] integerValue];
    _title = [attributes valueForKeyPath:@"title"];
    _ownerId = [[[attributes valueForKeyPath:@"user"] valueForKeyPath:@"id"] integerValue];
    _user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    //NSLog(@"%@",[attributes valueForKeyPath:@"user"]);
    _description = [attributes valueForKeyPath:@"description"];
    _city = [attributes valueForKeyPath:@"city"];
    _country = [attributes valueForKeyPath:@"country"];
    _street = [attributes valueForKeyPath:@"street"];
    _start = [attributes valueForKeyPath:@"start"];
    _length = [attributes valueForKeyPath:@"length"];
    _longitude = [[attributes valueForKeyPath:@"longitude"] floatValue];
    _latitude = [[attributes valueForKeyPath:@"latitude"] floatValue];
    //_pictureUrl = [attributes valueForKeyPath:@"activity_picture"];
    
        
    return self;
}

- (NSDictionary *)serialize
{
    return [[NSDictionary alloc] init];
}

+ (void)publicFeedWithBlock:(void (^)(NSArray *activities, NSError *error))block {

    [[AFCanuAPIClient sharedClient] getPath:@"activities/" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        //NSLog(@"%@",JSON);
        //NSLog(@"%lu",(unsigned long)[[JSON objectForKey:@"activities"] count]);
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        //NSLog(@"%lu",(unsigned long)[mutableActivities count]);
        for (NSDictionary *attributes in JSON) {
             //NSLog(@"%@",attributes);
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            //NSLog(@"%@",[activity startDate]);
            [mutableActivities addObject:activity];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
    
}




- (void)removeActivityFromUserWithBlock:(void (^)(NSError *error))block {
    
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];

    NSString *path = [NSString stringWithFormat:@"/users/%lu/activities/%lu",(unsigned long)appDelegate.user.userId,(unsigned long)self.activityId];
    [[AFCanuAPIClient sharedClient] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        if (block) {
            block(nil);
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

+ (void)createActivityForUserWithTitle:(NSString *)title
                           Description:(NSString *)description
                             StartDate:(NSString *)startDate
                                Length:(NSString *)length
                                Street:(NSString *)street
                                  City:(NSString *)city
                                   Zip:(NSString *)zip
                               Country:(NSString *)country
                              Latitude:(NSString *)latitude
                             Longitude:(NSString *)longitude
                                 Image:(UIImage *)activityImage
                                 Block:(void (^)(NSError *error))block
{

    if (!description) { description = @""; }
    
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    
    
    NSArray *objectsArray = [NSArray arrayWithObjects:
                             title,
                             description,
                             startDate,
                             length,
                             street,
                             city,
                             zip,
                             country,
                             latitude,
                             longitude,
                             nil];
    
    NSArray *keysArray = [NSArray arrayWithObjects:
                          @"title",
                          @"description",
                          @"start",
                          @"length",
                          @"street",
                          @"city",
                          @"zip",
                          @"country",
                          @"latitude",
                          @"longitude",
                          nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSData *imageData = UIImageJPEGRepresentation(activityImage, 1.0);
    
    NSMutableURLRequest *request = [[AFCanuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"users/%lu/activities",(unsigned long)appDelegate.user.userId] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"activity.jpg" mimeType:@"image/jpeg"];
    }];
    
    /*[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];*/
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                             NSLog(@" sorry: %@",JSON);
                                                                                            if (block) {
                                                                                                block(nil);
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                                                                                            if (block) {
                                                                                                NSLog(@"%@",error);
                                                                                                NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                                                                                                block(error);
                                                                                            }                                                
                                                                                        }];
    [operation start];

}




@end
