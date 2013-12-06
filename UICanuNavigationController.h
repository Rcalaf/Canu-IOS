//
//  UICanuNavigationController.h
//  CANU
//
//  Created by Roger Calaf on 30/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuNavigationController : UINavigationController

@property (strong, nonatomic) IBOutlet UIView *control;

- (void)controlFadeShow;
- (IBAction)goProfile:(UISwipeGestureRecognizer *)gesture;
- (IBAction)goActivities:(UISwipeGestureRecognizer *)gesture;

@end
