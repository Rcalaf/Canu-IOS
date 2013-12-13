//
//  AppDelegate.h
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@class UICanuNavigationController;


@class ActivitiesFeedViewController;
@class UserProfileViewController;


extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) ActivitiesFeedViewController *publicFeedViewController;
@property (strong, nonatomic) UserProfileViewController *profileViewController;

@property (strong, nonatomic) UICanuNavigationController *canuViewController;


//@property (readonly, strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//Facebook SDK login methods
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;


@end
