//
//  UserProfileViewController.h
//  CANU
//
//  Created by Roger Calaf on 23/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) User *user;

//-(IBAction)performLogout:(id)sender;
//-(IBAction)showActivities:(id)sender;
//-(IBAction)createActivity:(id)sender;
@end
