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

@interface Activity () <MKAnnotation>
- (NSDictionary *)serialize;
@end

@implementation Activity

@synthesize activityId = _activityId;
@synthesize ownerId = _ownerId;
@synthesize title = _title;
@synthesize description = _description;
@synthesize start = _start;
@synthesize end = _end;
@synthesize length = _length;
@synthesize street = _street;
@synthesize city =_city;
@synthesize zip = _zip;
@synthesize country = _country;
@synthesize pictureUrl = _picture;
//@synthesize latitude = _latitude;
//@synthesize longitude = _longitude;
@synthesize user = _user;
@synthesize location = _location;
@synthesize coordinate = _coordinate;
@synthesize attendeeIds = _attendeeIds;

/*

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}*/




- (void)setStart:(id)start
{
    if ([[start class] isKindOfClass:[NSDate class]] ) {
        _start = start;
    } else {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSArray *dateParts = [start componentsSeparatedByString:@"T"];
        NSArray *dayParts = [[dateParts objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSArray *timeParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@":"];
        [comps setYear:[[dayParts objectAtIndex:0] integerValue]];
        [comps setMonth:[[dayParts objectAtIndex:1] integerValue]];
        [comps setDay:[[dayParts objectAtIndex:2] integerValue]];
        
        [comps setHour:[[timeParts objectAtIndex:0] integerValue]];
        [comps setMinute:[[timeParts objectAtIndex:1] integerValue]];
        [comps setSecond:[[timeParts objectAtIndex:2] integerValue]];
        _start = [[NSCalendar currentCalendar] dateFromComponents:comps];
        /*NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy"];
        _start = [df dateFromString: start];*/
        //NSLog(@"%@",_start);
    }
    
}

- (void)setEnd:(id)end
{
    if ([[end class] isKindOfClass:[NSDate class]] ) {
        _end = end;
    }else {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSArray *dateParts = [end componentsSeparatedByString:@"T"];
        NSArray *dayParts = [[dateParts objectAtIndex:0] componentsSeparatedByString:@"-"];
        NSArray *timeParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@":"];
        [comps setYear:[[dayParts objectAtIndex:0] integerValue]];
        [comps setMonth:[[dayParts objectAtIndex:1] integerValue]];
        [comps setDay:[[dayParts objectAtIndex:2] integerValue]];
        
        [comps setHour:[[timeParts objectAtIndex:0] integerValue]];
        [comps setMinute:[[timeParts objectAtIndex:1] integerValue]];
        [comps setSecond:[[timeParts objectAtIndex:2] integerValue]];
        /*NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];*/
        _end = [[NSCalendar currentCalendar] dateFromComponents:comps];
    }
}

- (void)addNotification
{
    UIApplication *app = [UIApplication sharedApplication];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.fireDate = [self.start dateByAddingTimeInterval:-(5*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil),
                            self.title, 5];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
   // localNotif.applicationIconBadgeNumber = 0;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:self.activityId]  forKey:@"id"];
    localNotif.userInfo = infoDict;
    
    [app scheduleLocalNotification:localNotif];

}

-(void)removeNotification
{
    UIApplication *app = [UIApplication sharedApplication];
    for(UILocalNotification *notification in [app scheduledLocalNotifications]) {
        if ([[notification.userInfo objectForKey:@"id"] integerValue] == self.activityId) {
            [app cancelLocalNotification: notification];
        }
    }
}

- (NSDictionary *)serialize
{
    return [[NSDictionary alloc] init];
}


- (MKMapItem *)location {
   // NSLog(@"location");
    if (!_location) {
        if (!self.street) _street = @"";
        if (!self.city) _city = @"";
        if (!self.zip) _zip = @"";
        if (!self.country) _country = @"";
        
    
        NSArray *objectsArray = [NSArray arrayWithObjects:self.street,self.city,self.zip,self.country,nil];
   
        NSArray *keysArray = [NSArray arrayWithObjects:@"Street",@"City",@"ZIP",@"Country",nil];
    
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
 
        //MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) addressDictionary:parameters];
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:parameters];

        _location = [[MKMapItem alloc] initWithPlacemark:placemark];
    }
    return _location;
}

/*
- (void)populateLocationDataWith:(MKMapItem *)mapItem
{
    _street = mapItem.placemark.addressDictionary[@"Street"];
    _city = mapItem.placemark.addressDictionary[@"City"];
    _zip = mapItem.placemark.addressDictionary[@"ZIP"];
    _country = mapItem.placemark.addressDictionary[@"Country"];
    _longitude = mapItem.placemark.coordinate.latitude;
    _latitude = mapItem.placemark.coordinate.longitude;

}*/

- (NSInteger)status
{
    NSInteger status;
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.ownerId == appDelegate.user.userId) {
        status = UICanuActivityCellEditable;
    } else if ([self.attendeeIds containsObject:[NSNumber numberWithUnsignedInteger:appDelegate.user.userId]]){
        status = UICanuActivityCellGo;
    }else{
        status = UICanuActivityCellToGo;
    }
    return status;
}

+ (NSString *)lengthToString:(NSInteger)length
{
    NSInteger hours = length/60;
    NSInteger minuts = length%60;
    return [NSString stringWithFormat:@"%.2d:%.2d", hours,minuts];
    
}

- (NSInteger)lengthToInteger
{
    NSArray *dateParts = [_length componentsSeparatedByString:@"T"];
    NSArray *timeParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@":"];
    NSInteger hours = [[timeParts objectAtIndex:0] integerValue];
    NSInteger minutes = [[timeParts objectAtIndex:1] integerValue];
    
    return hours*60+minutes;
}

- (NSString *)locationDescription
{
    NSString *description = @"";
    if (self.street) description = [description stringByAppendingString:self.street];
    if (self.city) description = [description stringByAppendingFormat:@", %@",self.city];
    if (self.zip) description = [description stringByAppendingFormat:@", %@",self.zip];
    return description;
}


- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
   //NSLog(@"%@",attributes);
    _activityId = [[attributes valueForKeyPath:@"id"] integerValue];
    _title = [attributes valueForKeyPath:@"title"];
    _ownerId = [[[attributes valueForKeyPath:@"user"] valueForKeyPath:@"id"] integerValue];
    _user = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];
    
    //NSLog(@"%@",[attributes valueForKeyPath:@"user"]);
    _description = [attributes valueForKeyPath:@"description"];
    
    _city = [attributes valueForKeyPath:@"city"];
    _country = [attributes valueForKeyPath:@"country"];
    _street = [attributes valueForKeyPath:@"street"];
    _zip = [attributes valueForKeyPath:@"zip_code"];
    
    self.start = [attributes valueForKeyPath:@"start"];
    self.end = [attributes valueForKeyPath:@"end_date"];
    
    _length = [attributes valueForKeyPath:@"length"];
    
    //_longitude = [[attributes valueForKeyPath:@"longitude"] floatValue];
    //_latitude = [[attributes valueForKeyPath:@"latitude"] floatValue];
    
    _coordinate.latitude = [[attributes valueForKeyPath:@"latitude"] floatValue];
    _coordinate.longitude =[[attributes valueForKeyPath:@"longitude"] floatValue];
    
    //_pictureUrl = [attributes valueForKeyPath:@"activity_picture"];
    
    NSMutableArray *mutableAssistents = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"attendee_ids"] count]];
    for (NSNumber *assistentId in [attributes valueForKeyPath:@"attendee_ids"]) {
        [mutableAssistents addObject:assistentId];
    }
    _attendeeIds = mutableAssistents;
    
    
    return self;
}



+ (void)publicFeedWithCoorindate:(CLLocationCoordinate2D)coordinate WithBlock:(void (^)(NSArray *activities, NSError *error))block {
    //AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameters;
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:coordinate.latitude ],@"latitude",[NSNumber numberWithDouble:coordinate.longitude],@"longitude", nil];
    } else {
        parameters = nil;
    }
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] getPath:@"activities" parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            // NSLog(@"%@",attributes);
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            [mutableActivities addObject:activity];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


- (void)attendWithBlock:(void (^)(NSArray *activities, NSError *error))block
{
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:appDelegate.currentLocation.latitude ],@"latitude",[NSNumber numberWithDouble:appDelegate.currentLocation.longitude],@"longitude", nil];
    
    NSString *path = [NSString stringWithFormat:@"activities/%lu/users/%lu/attend",(unsigned long)self.activityId,(unsigned long)appDelegate.user.userId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:appDelegate.user.token];
    [[AFCanuAPIClient sharedClient] postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            if (activity.activityId == self.activityId) _attendeeIds = activity.attendeeIds;
            //NSLog(@"%@",activity.attendeeIds);
            [mutableActivities addObject:activity];
        }
        //[self addNotification];
        
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array],error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];

}

- (void)dontAttendWithBlock:(void (^)(NSArray *activities, NSError *error))block
{
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:appDelegate.currentLocation.latitude ],@"latitude",[NSNumber numberWithDouble:appDelegate.currentLocation.longitude],@"longitude", nil];
    
    NSString *path = [NSString stringWithFormat:@"activities/%lu/users/%lu/attend",(unsigned long)self.activityId,(unsigned long)appDelegate.user.userId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:appDelegate.user.token];
    [[AFCanuAPIClient sharedClient] deletePath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {

       // [self removeNotification];
        
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            //NSLog(@"%@",attributes);
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            if (activity.activityId == self.activityId) _attendeeIds = activity.attendeeIds;
            [mutableActivities addObject:activity];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
       
       
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array],error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


- (void)removeActivityWithBlock:(void (^)(NSError *error))block{
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *path = [NSString stringWithFormat:@"/users/%lu/activities/%lu",(unsigned long)appDelegate.user.userId,(unsigned long)self.activityId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        if (block) {
            block(nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)attendees:(void (^)(NSArray *attendees, NSError *error))block{
    //NSLog(@"Attendees called");
    NSString *path = [NSString stringWithFormat:@"/activities/%lu/attendees",(unsigned long)self.activityId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableActivities = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            User *user = [[User alloc] initWithAttributes:attributes];
            [mutableActivities addObject:user];
        }
      //  NSLog(@"%@",JSON);
        
        if (block) {
            block([NSArray arrayWithArray:mutableActivities],nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array],error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)createActivityForUserWithTitle:(NSString *)title
                           Description:(NSString *)description
                             StartDate:(NSString *)startDate
                                Length:(NSString *)length
                               EndDate:(NSString *)endDate
                                Street:(NSString *)street
                                  City:(NSString *)city
                                   Zip:(NSString *)zip
                               Country:(NSString *)country
                              Latitude:(NSString *)latitude
                             Longitude:(NSString *)longitude
                                 Image:(UIImage *)activityImage
                                 Block:(void (^)(NSError *error))block
{

    //NSLog(@"end: %@",endDate);
    if (!title) title = @"";
    if (!description) description = @""; 
    if (!street) street = @"";
    if (!city) city = @"";
    if (!zip) zip = @"";
    if (!country) country = @"";
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *objectsArray = [NSArray arrayWithObjects:
                             title,
                             description,
                             startDate,
                             length,
                             endDate,
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
                          @"end",
                          @"street",
                          @"city",
                          @"zip",
                          @"country",
                          @"latitude",
                          @"longitude",
                          nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSData *imageData = UIImageJPEGRepresentation(activityImage, 1.0);
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:appDelegate.user.token];
    
    NSMutableURLRequest *request = [[AFCanuAPIClient sharedClient] multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"users/%lu/activities",(unsigned long)appDelegate.user.userId] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"activity.jpg" mimeType:@"image/jpeg"];
    }];
    
    /*[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];*/
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //Activity *newActivity = [[Activity alloc] initWithAttributes:JSON];

                                                                                            //[newActivity addNotification];
                                                                                             //NSLog(@" sorry: %@",JSON);
                                                                                            if (block) {
                                                                                                block(nil);
                                                                                            }
                Mixpanel *mixpanel = [Mixpanel sharedInstance];
                [mixpanel track:@"Activity Created" properties:@{@"Title": title,
                                                              @"Country": country}];
                                                                        
                                                                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                                                                                            
                                                                                            if (block) {
                                                                                                
                                                                                               // NSLog(@"%@",error);
                                                                                               // NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                                                                                                block(error);
                                                                                            }
                                                                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                                                        }];
    [operation start];

}


- (void)editActivityForUserWithTitle:(NSString *)title 
                         Description:(NSString *)description
                           StartDate:(NSString *)startDate
                              Length:(NSString *)length
                             EndDate:(NSString *)endDate
                              Street:(NSString *)street
                                City:(NSString *)city
                                 Zip:(NSString *)zip
                             Country:(NSString *)country
                            Latitude:(NSString *)latitude
                           Longitude:(NSString *)longitude
                               Image:(UIImage *)activityImage
                               Block:(void (^)(NSError *error))block
{
    
    //NSLog(@"end: %@",endDate);
    if (!title) title = @"";
    if (!description) description = @"";
    if (!street) street = @"";
    if (!city) city = @"";
    if (!zip) zip = @"";
    if (!country) country = @"";
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSArray *objectsArray = [NSArray arrayWithObjects:
                             //self.user.userId,
                             title,
                             description,
                             startDate,
                             length,
                             endDate,
                             street,
                             city,
                             zip,
                             country,
                             latitude,
                             longitude,
                             nil];
    
    NSArray *keysArray = [NSArray arrayWithObjects:
                         // @"user_id",
                          @"title",
                          @"description",
                          @"start",
                          @"length",
                          @"end",
                          @"street",
                          @"city",
                          @"zip",
                          @"country",
                          @"latitude",
                          @"longitude",
                          nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSData *imageData = UIImageJPEGRepresentation(activityImage, 1.0);
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:appDelegate.user.token];
    
    NSMutableURLRequest *request = [[AFCanuAPIClient sharedClient] multipartFormRequestWithMethod:@"PUT" path:[NSString stringWithFormat:@"users/%lu/activities/%lu",(unsigned long)appDelegate.user.userId,(unsigned long)self.activityId] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"activity.jpg" mimeType:@"image/jpeg"];
    }];
    
    /*[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];*/
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //Activity *newActivity = [[Activity alloc] initWithAttributes:JSON];

                                                                                            //[newActivity addNotification];
                                                                                            //NSLog(@" sorry: %@",JSON);
                                                                                            if (block) {
                                                                                                block(nil);
                                                                                            }
                                                                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                                                                                            
                                                                                            if (block) {
                                                                                                
                                                                                                NSLog(@"%@",error);
                                                                                                NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                                                                                                block(error);
                                                                                            }
                                                                                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                                                        }];
    [operation start];
    
}


- (void)messagesWithBlock:(void (^)(NSArray *messages, NSError *error))block {
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *path = [NSString stringWithFormat:@"activities/%lu/chat",(unsigned long)self.activityId];
   // NSLog(@"url: %@",path);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:appDelegate.user.token];
    [[AFCanuAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableMessages = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
            //NSLog(@"%@",attributes);
            Message *message = [[Message alloc] initWithAttributes:attributes];
            [mutableMessages addObject:message];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableMessages], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)newMessage:(NSString *)message WithBlock:(void (^)(NSError *error))block{
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *objectsArray;
    NSArray *keysArray;
  
    objectsArray = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedLong:self.activityId],message,[NSNumber numberWithUnsignedLong:appDelegate.user.userId],nil];
    keysArray = [NSArray arrayWithObjects:@"activity_id",@"text",@"user_id",nil];
    
    
    NSDictionary *user = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:user] forKeys: [NSArray arrayWithObject:@"message"]];
    
    NSString *path = [NSString stringWithFormat:@"activities/%lu/chat",(unsigned long)self.activityId];
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:appDelegate.user.token];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        // NSLog(@"%@",JSON);
        if (block) {
            block(nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}




@end
