//
//  Activity.m
//  CANU
//
//  Created by Roger Calaf on 02/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Activity.h"
#import "AppDelegate.h"
#import "ErrorManager.h"
#import "AFCanuAPIClient.h"
#import "AFNetworking.h"
#import "UICanuActivityCellScroll.h"
#import "UserManager.h"
#import "Contact.h"

@interface Activity () <MKAnnotation>



@end

@implementation Activity

@synthesize location = _location;

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
        _end = [[NSCalendar currentCalendar] dateFromComponents:comps];
    }
}

- (void)addNotification
{
    UIApplication *app = [UIApplication sharedApplication];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.fireDate = [self.start dateByAddingTimeInterval:-(5*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ in %i minutes.", nil),self.title, 5];
    
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
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
   
    if (!_location) {
        if (!self.street) _street   = @"";
        if (!self.city) _city       = @"";
        if (!self.zip) _zip         = @"";
        if (!self.country) _country = @"";
        
    
        NSArray *objectsArray = [NSArray arrayWithObjects:self.street,self.city,self.zip,self.country,nil];
   
        NSArray *keysArray = [NSArray arrayWithObjects:@"Street",@"City",@"ZIP",@"Country",nil];
    
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:parameters];

        _location = [[MKMapItem alloc] initWithPlacemark:placemark];
    }
    return _location;
}

- (NSInteger)status{
    
    NSInteger status;
    
    if (self.ownerId == [[UserManager sharedUserManager] currentUser].userId) {
        status = UICanuActivityCellEditable;
    } else if ([self.attendeeIds containsObject:[NSNumber numberWithUnsignedInteger:[[UserManager sharedUserManager] currentUser].userId]]){
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
    
    _activityId          = [[attributes valueForKeyPath:@"id"] unsignedIntegerValue];
    _title               = [attributes valueForKeyPath:@"title"];
    _ownerId             = [[[attributes valueForKeyPath:@"user"] valueForKeyPath:@"id"] unsignedIntegerValue];
    _user                = [[User alloc] initWithAttributes:[attributes valueForKeyPath:@"user"]];

    _description         = [attributes valueForKeyPath:@"description"];

    _city                = [attributes valueForKeyPath:@"city"];
    _country             = [attributes valueForKeyPath:@"country"];
    _street              = [attributes valueForKeyPath:@"street"];
    _zip                 = [attributes valueForKeyPath:@"zip_code"];
    
    _privacyLocation     = NO;
    
    if ([attributes objectForKey:@"private_location"] != [NSNull null] && [attributes objectForKey:@"private_location"] != nil) {
        
        _privacyLocation     = [[attributes valueForKeyPath:@"private_location"] boolValue];
        
    }

    self.start           = [attributes valueForKeyPath:@"start"];
    self.end             = [attributes valueForKeyPath:@"end_date"];

    _length              = [attributes valueForKeyPath:@"length"];

    _coordinate.latitude = [[attributes valueForKeyPath:@"latitude"] floatValue];
    _coordinate.longitude =[[attributes valueForKeyPath:@"longitude"] floatValue];
    
    NSMutableArray *mutableAssistents = [NSMutableArray arrayWithCapacity:[[attributes valueForKeyPath:@"attendee_ids"] count]];
    for (NSNumber *assistentId in [attributes valueForKeyPath:@"attendee_ids"]) {
        [mutableAssistents addObject:assistentId];
    }
    _attendeeIds = mutableAssistents;
    
    _invitationToken = [attributes valueForKeyPath:@"invitation_token"];
    
    return self;
}

/**
 *  All activities around the user
 *
 *  @param coordinate
 *  @param block
 */
+ (void)publicFeedWithCoorindate:(CLLocationCoordinate2D)coordinate WithBlock:(void (^)(NSArray *activities, NSError *error))block {
    
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
            Activity *activity = [[Activity alloc] initWithAttributes:attributes];
            [mutableActivities addObject:activity];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableActivities], nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block([NSArray alloc],customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"Activity" function:@"publicFeedWithCoorindate:WithBlock:"];
            }
            
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}


+ (void)activityWithId:(NSUInteger)activityId andBlock:(void (^)(Activity *activity, NSError *error))block{
    NSString *path = [NSString stringWithFormat:@"activities/%lu",(unsigned long)activityId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        Activity *activity = [[Activity alloc] initWithAttributes:JSON];
        if (block) {
            block(activity, nil);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


- (void)attendWithBlock:(void (^)(NSArray *activities, NSError *error))block
{
    NSLog(@"attendWithBlock");
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:appDelegate.currentLocation.latitude ],@"latitude",[NSNumber numberWithDouble:appDelegate.currentLocation.longitude],@"longitude", nil];
    
    NSString *path = [NSString stringWithFormat:@"activities/%lu/users/%lu/attend",(unsigned long)self.activityId,(unsigned long)[[UserManager sharedUserManager] currentUser].userId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:[[UserManager sharedUserManager] currentUser].token];
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
    NSLog(@"dontAttendWithBlock");
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:appDelegate.currentLocation.latitude ],@"latitude",[NSNumber numberWithDouble:appDelegate.currentLocation.longitude],@"longitude", nil];
    
    NSString *path = [NSString stringWithFormat:@"activities/%lu/users/%lu/attend",(unsigned long)self.activityId,(unsigned long)[[UserManager sharedUserManager] currentUser].userId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:[[UserManager sharedUserManager] currentUser].token];
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

    NSString *path = [NSString stringWithFormat:@"/users/%lu/activities/%lu",(unsigned long)[[UserManager sharedUserManager] currentUser].userId,(unsigned long)self.activityId];
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

- (void)attendees:(void (^)(NSArray *attendees, NSArray *invitationUser, NSArray *invitationGhostuser, NSError *error))block{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[[UserManager sharedUserManager] currentUser].userId],@"user_id", nil];
    
    NSString *path = [NSString stringWithFormat:@"/activities/%lu/attendees",(unsigned long)self.activityId];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:[[UserManager sharedUserManager] currentUser].token];
    [[AFCanuAPIClient sharedClient] getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSMutableDictionary *mutableResponse = [NSMutableDictionary dictionaryWithDictionary:JSON];
        
        NSMutableArray *responseAttendees = [mutableResponse objectForKey:@"attendees"];
        NSMutableArray *allAttendees = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [responseAttendees count]; i++) {
            
            User *user = [[User alloc] initWithAttributes:[responseAttendees objectAtIndex:i]];
            [allAttendees addObject:user];
            
        }
        
        NSMutableArray *responseInvitationUser = [[mutableResponse objectForKey:@"invitation"] objectForKey:@"users"];
        NSMutableArray *allInvitationUser = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [responseInvitationUser count]; i++) {
            
            User *user = [[User alloc] initWithAttributes:[responseInvitationUser objectAtIndex:i]];
            [allInvitationUser addObject:user];
            
        }
        
        NSMutableArray *responseInvitationGhostuser = [[mutableResponse objectForKey:@"invitation"] objectForKey:@"ghostuser"];
        NSMutableArray *allInvitationGhostuser = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [responseInvitationGhostuser count]; i++) {
            
            [allInvitationGhostuser addObject:[[responseInvitationGhostuser objectAtIndex:i]objectForKey:@"phone_number"]];
            
        }
        
        if (block) {
            block([NSArray arrayWithArray:allAttendees],[NSArray arrayWithArray:allInvitationUser],[NSArray arrayWithArray:allInvitationGhostuser],nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ErrorManager sharedErrorManager] detectError:error Block:^(CANUError canuError) {
            
            NSError *customError = [NSError errorWithDomain:@"CANUError" code:canuError userInfo:nil];
            
            if (block) {
                block([NSArray alloc],[NSArray alloc],[NSArray alloc],customError);
            }
            
            if (canuError == CANUErrorServerDown) {
                [[ErrorManager sharedErrorManager] serverIsDown];
            } else if (canuError == CANUErrorUnknown) {
                [[ErrorManager sharedErrorManager] unknownErrorDetected:error ForFile:@"Activity" function:@"attendees:"];
            }
            
        }];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
                                Guests:(NSMutableArray *)arrayGuests
                       PrivateLocation:(BOOL)privatelocation
                                 Block:(void (^)(Activity *activity,NSError *error))block{
    

    if (!title) title = @"";
    if (!description) description = @""; 
    if (!street) street = @"";
    if (!city) city = @"";
    if (!zip) zip = @"";
    if (!country) country = @"";
    
    NSArray *objectsArray = [NSArray arrayWithObjects: title, description, startDate, length, street, city, zip, country, latitude, longitude,arrayGuests,[NSNumber numberWithBool:privatelocation], nil];
    NSArray *keysArray = [NSArray arrayWithObjects: @"title", @"description", @"start", @"length", @"street", @"city", @"zip", @"country", @"latitude", @"longitude",@"guests",@"private_location", nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [NSString stringWithFormat:@"users/%i/activities",[[UserManager sharedUserManager] currentUser].userId];
    
    [[AFCanuAPIClient sharedClient] postPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        Activity *activity = [[Activity alloc]initWithAttributes:JSON];
        
        if (block) {
            block(activity,nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            
            // NSLog(@"%@",error);
            // NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(nil,error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];

}


- (void)editActivityForUserWithTitle:(NSString *)title
                         Description:(NSString *)description
                           StartDate:(NSString *)startDate
                              Length:(NSString *)length
                              Street:(NSString *)street
                                City:(NSString *)city
                                 Zip:(NSString *)zip
                             Country:(NSString *)country
                            Latitude:(NSString *)latitude
                           Longitude:(NSString *)longitude
                              Guests:(NSMutableArray *)arrayGuests
                     PrivateLocation:(BOOL)privatelocation
                               Block:(void (^)(NSError *error))block
{
    
    
    if (!title) title = @"";
    if (!description) description = @"";
    if (!street) street = @"";
    if (!city) city = @"";
    if (!zip) zip = @"";
    if (!country) country = @"";
    
    
    NSArray *objectsArray = [NSArray arrayWithObjects: title, description, startDate, length, street, city, zip, country, latitude, longitude, nil];
    NSArray *keysArray = [NSArray arrayWithObjects: @"title", @"description", @"start", @"length", @"street", @"city", @"zip", @"country", @"latitude", @"longitude", nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:[[UserManager sharedUserManager] currentUser].token];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *url = [NSString stringWithFormat:@"users/%i/activities/%i",[[UserManager sharedUserManager] currentUser].userId,self.activityId];
    
    [[AFCanuAPIClient sharedClient] putPath:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        if (block) {
            block(nil);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            
            NSLog(@"%@",error);
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            block(error);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }];
    
}


- (void)messagesWithBlock:(void (^)(NSArray *messages, NSError *error))block {
    
    NSString *path = [NSString stringWithFormat:@"activities/%lu/chat",(unsigned long)self.activityId];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:[[UserManager sharedUserManager] currentUser].token];
    [[AFCanuAPIClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableMessages = [NSMutableArray arrayWithCapacity:[JSON count]];
        for (NSDictionary *attributes in JSON) {
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
    
    NSArray *objectsArray;
    NSArray *keysArray;
  
    objectsArray = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedLong:self.activityId],message,[NSNumber numberWithUnsignedLong:[[UserManager sharedUserManager] currentUser].userId],nil];
    keysArray = [NSArray arrayWithObjects:@"activity_id",@"text",@"user_id",nil];
    
    NSDictionary *user = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObject:user] forKeys: [NSArray arrayWithObject:@"message"]];
    
    NSString *path = [NSString stringWithFormat:@"activities/%lu/chat",(unsigned long)self.activityId];
    
    [[AFCanuAPIClient sharedClient] setAuthorizationHeaderWithToken:[[UserManager sharedUserManager] currentUser].token];
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
