//
//  AppDelegate.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AFCanuAPIClient.h"
#import <Mixpanel/Mixpanel.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ActivitiesFeedViewController.h" 
#import "UserProfileViewController.h"
#import "UICanuNavigationController.h"
#import "TutorialViewController.h"
#import "ChatViewController.h"



NSString *const FBSessionStateChangedNotification =
@"se.canu.canu:FBSessionStateChangedNotification";


@implementation AppDelegate{
    UICanuNavigationController *canuViewController;
    MainViewController *loginViewController;
    
}

@synthesize user = _user;
@synthesize device_token = _device_token;
@synthesize publicFeedViewController = _publicFeedViewController;
@synthesize profileViewController = _profileViewController;
@synthesize currentLocation = _currentLocation;


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (ActivitiesFeedViewController *)publicFeedViewController
{
    if (!_publicFeedViewController) {
        _publicFeedViewController = [[ActivitiesFeedViewController alloc] init];
        //NSLog(@"Creating public feed");
    } 
    return _publicFeedViewController;
}

- (UserProfileViewController *)profileViewController
{
    if (!_profileViewController) {
        _profileViewController = [[UserProfileViewController alloc] init];
       // NSLog(@"Creating User profile");
    }
    _profileViewController.user = self.user;
    // NSLog(@"user id: %lu",(unsigned long)_profileViewController.user.userId);

    return _profileViewController;
}

- (User *)user
{
    if (!_user) {
        NSDictionary *savedUserAttributes = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        if (savedUserAttributes) {
            _user = [[User alloc] initWithAttributes:savedUserAttributes];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,_user.profileImageUrl]];
            NSLog(@"appDel: user profile pic url: %@",url);
            
            _user.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (_user.profileImage == nil) _user.profileImage = [UIImage imageNamed:@"icon_userpic.png"];
        }
    }
    return _user;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    // Later, you can get your instance with
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
   /* if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:@"no location service enabled" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
    }*/
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (self.user) {
        
        canuViewController = [[UICanuNavigationController alloc] init];
       // _publicFeedViewController = [[ActivitiesFeedViewController alloc] init];
       // _profileViewController = [[UserProfileViewController alloc] init];
        [canuViewController pushViewController:self.publicFeedViewController animated:NO];
        self.window.rootViewController = canuViewController;
        
        
    } else {
        loginViewController = [[MainViewController alloc] init];
        //[nvc addChildViewController:mvc];
        self.window.rootViewController = loginViewController;
        
    }
    
    [self.window makeKeyAndVisible];
    
   // application.applicationIconBadgeNumber = 0;
    
    // Handle launching from a notification
    /*UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification oppening%@",localNotif);
    }*/
    // [self.locationManager stopUpdatingLocation];
    

    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	//NSLog(@"My token is hex: %@", deviceToken);
    
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    _device_token = token;
    
    if (self.user) {
        [self.user updateDeviceToken:_device_token Block:^(NSError *error){
            if (error) {
                NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            }
        }];

    }
    
  //  NSLog(@"My token in string: %@", _device_token);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"%@",userInfo);
   // application.applicationIconBadgeNumber =application.applicationIconBadgeNumber + 1 ;
    
    [self.user updateDevice:_device_token Badge:application.applicationIconBadgeNumber WithBlock:^(NSError *error){
        if (error) {
            NSLog(@"hello");
            NSLog(@"Request Failed with Error notification: %@", error);
        }
    }];
    if ( application.applicationState == UIApplicationStateActive ){
        if ([[(UINavigationController *)self.window.rootViewController visibleViewController] isKindOfClass:[ChatViewController class]]) {
            ChatViewController *currentChat = (ChatViewController *)[(UINavigationController *)self.window.rootViewController visibleViewController];
            if (currentChat.activity.activityId == [[userInfo valueForKeyPath:@"activity_id"] integerValue]){
              [currentChat reload];
            }
        } else {
            
        }
    } else {
         NSLog(@"Controller: %@", [[(UINavigationController *)self.window.rootViewController visibleViewController] class]);
      
    }
        
}

/*
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    // app.applicationIconBadgeNumber = app.applicationIconBadgeNumber + 1;
    NSLog(@"Recieved Notification from background%@",notif);
}*/

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"Setting and notifying the new state...");
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        {
            NSLog(@"Session Closed");
        }
            break;
            
        case FBSessionStateClosedLoginFailed:
        {
            NSLog(@"Session Failed and Closed");
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
        default:
            NSLog(@"Default scape...");
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:NSLocalizedString(@"The operation couldn't be completed or was cancelled", nil)//error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    application.applicationIconBadgeNumber = 0;
    if (_device_token) {
        [self.user updateDevice:_device_token Badge:0 WithBlock:^(NSError *error){
            if (error) {
                NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
            }
        }];
    }

     //NSLog(@"%@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
   
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [FBSession.activeSession close];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CANU" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CANU.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
