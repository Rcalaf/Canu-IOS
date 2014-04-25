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
#import "ErrorManager.h"

@class UICanuNavigationController;


@class ActivitiesFeedViewController;


extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *oldScreenName;

/**
 *  Gestion Error ( UIAlert, Messages )
 */
@property (strong, nonatomic) ErrorManager *errorManager;

@property (strong, nonatomic) ActivitiesFeedViewController *feedViewController;
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
- (void)logOut;

@end
