//
//  AppDelegate.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AFCanuAPIClient.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ActivitiesFeedViewController.h"
#import "UICanuNavigationController.h"
#import "TutorialViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "AFCanuAPIClient.h"
#import "ErrorManager.h"
#import <Instabug/Instabug.h>

NSString *const FBSessionStateChangedNotification =
@"se.canu.canu:FBSessionStateChangedNotification";


@implementation AppDelegate{
    MainViewController *loginViewController;
}

@synthesize errorManager = _errorManager;
@synthesize user = _user;
@synthesize device_token = _device_token;
@synthesize feedViewController = _feedViewController;
@synthesize currentLocation = _currentLocation;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (ActivitiesFeedViewController *)feedViewController
{
    if (!_feedViewController) {
        _feedViewController = [[ActivitiesFeedViewController alloc] init];
    } 
    return _feedViewController;
}

- (User *)user
{
    if (!_user) {
        NSDictionary *savedUserAttributes = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        if (savedUserAttributes) {
            _user = [[User alloc] initWithAttributes:savedUserAttributes];
        }
    }
    return _user;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    id<GAITracker> tracker;
    
    if ([AFCanuAPIClient sharedClient].distributionMode) {
        // Google Analytics //
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        [GAI sharedInstance].dispatchInterval = 20;
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
        id<GAITracker> tracker;
        tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-46900796-1"];
        NSLog(@"//////// WARNING ////////");
        NSLog(@"DISTRIBUTION MODE ENABLE");
        NSLog(@"//////// WARNING ////////");
        NSLog(@"DISTRIBUTION MODE ENABLE");
        NSLog(@"//////// WARNING ////////");
    }

    [Instabug KickOffWithToken:@"c44d12a703b04a0a5e797bba7452c9d5" CaptureSource:InstabugCaptureSourceUIKit FeedbackEvent:InstabugFeedbackEventShake IsTrackingLocation:YES];
    if (self.user) {
        [Instabug setEmail:self.user.email];
    }
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone){
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Push" action:@"Subscribtion" label:@"NO" value:nil] build]];
    } else {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Push" action:@"Subscribtion" label:@"YES" value:nil] build]];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (self.user) {
        if (self.user.phoneIsVerified) {
            NSLog(@"User Active");
            self.canuViewController = [[UICanuNavigationController alloc] initWithActivityFeed:self.feedViewController];
            [self.canuViewController pushViewController:self.feedViewController animated:NO];
            self.window.rootViewController = _canuViewController;
        }else{
            NSLog(@"User Not Active");
            loginViewController = [[MainViewController alloc] init];
            loginViewController.isPhoneCheck = YES;
            self.window.rootViewController = loginViewController;
        }
    } else {
        loginViewController = [[MainViewController alloc] init];
        loginViewController.isPhoneCheck = NO;
        self.window.rootViewController = loginViewController;
        NSLog(@"No User");
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    _device_token = token;
    
    if (self.user) {
        [self.user updateDeviceToken:_device_token Block:nil];
    }
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"%@",userInfo);
   // application.applicationIconBadgeNumber =application.applicationIconBadgeNumber + 1 ;
    
NSLog(@"didReceiveRemoteNotification");
    if ( application.applicationState == UIApplicationStateActive ){
        
        [self.user updateDevice:_device_token Badge:application.applicationIconBadgeNumber WithBlock:nil];
    
//        if ([[(UICanuNavigationController *)self.window.rootViewController visibleViewController] isKindOfClass:[ChatViewController class]]) {
//            ChatViewController *currentChat = (ChatViewController *)[(UICanuNavigationController *)self.window.rootViewController visibleViewController];
//            if (currentChat.activity.activityId == [[[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"id"] integerValue]){
//              [currentChat reload];
//            }
//        }
        /*else {
           UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            if (localNotif == nil)
                return;
            localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:4];
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            
            localNotif.alertBody = [[userInfo valueForKeyPath:@"aps"] valueForKeyPath:@"alert"];
            localNotif.alertAction = NSLocalizedString(@"View Details", nil);
            
            localNotif.soundName = UILocalNotificationDefaultSoundName;
           // localNotif.applicationIconBadgeNumber = 0;
            [application scheduleLocalNotification:localNotif];
        }*/
    } else {
       // NSLog(@"Controller: %@", [[(UINavigationController *)self.window.rootViewController visibleViewController] class]);
       // NSLog(@"number of staged controllers: %d",[[(UINavigationController *)self.window.rootViewController viewControllers] count]);
       
        //Clean the max top three levels
//        [[(UINavigationController *)self.window.rootViewController visibleViewController] dismissViewControllerAnimated:NO completion:nil];
//        [[(UINavigationController *)self.window.rootViewController visibleViewController] dismissViewControllerAnimated:NO completion:nil];
//        [[(UINavigationController *)self.window.rootViewController visibleViewController] dismissViewControllerAnimated:NO completion:nil];
        
        // move to the main activity feed
//        [(UICanuNavigationController *)self.window.rootViewController goActivities:nil];
        
//        if (![[[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"type"] isEqualToString:@"delete activity"]) {
//            NSLog(@"we are in, value: %d",![[[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"type"] isEqualToString:@"delete activity"]);
//            [Activity activityWithId:[[[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"id"] unsignedIntegerValue] andBlock:^(Activity *activity, NSError *error){
//                if (activity) {
//                    DetailActivityViewController *davc = [[DetailActivityViewController alloc] init];
//                    davc.activity = activity;
//                    [(UICanuNavigationController *)self.window.rootViewController pushViewController:davc animated:YES];
//                    if ([[[userInfo valueForKeyPath:@"info"] valueForKeyPath:@"type"] isEqualToString:@"chat"]) {
//                        [davc presentViewController:[[ChatViewController alloc] initWithActivity:activity] animated:YES completion:nil];
//                    }
//                }
//            }];
//        }
    }
        
}

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

- (void)applicationDidBecomeActive:(UIApplication *)application{

    [FBSession.activeSession handleDidBecomeActive];
    application.applicationIconBadgeNumber = 0;
    if (_device_token) {
        [self.user updateDevice:_device_token Badge:0 WithBlock:nil];
    }
   
}

- (void)applicationWillTerminate:(UIApplication *)application{
    [FBSession.activeSession close];
    [self saveContext];
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
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

#pragma mark - User gestion

- (void)logOut{
    NSLog(@"AppDelegate logOut");
    [self.feedViewController removeAfterlogOut];
    [self.canuViewController popViewControllerAnimated:NO];
    [self.canuViewController popToViewController:_feedViewController animated:NO];
    [self.feedViewController.view removeFromSuperview];
    [self.feedViewController removeFromParentViewController];
    self.feedViewController = nil;
    self.window.rootViewController = nil;
    self.canuViewController = nil;
    
    loginViewController = [[MainViewController alloc] init];
    self.window.rootViewController = loginViewController;
    
}

@end
