//
//  UICanuNavigationController.h
//  CANU
//
//  Created by Roger Calaf on 30/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuNavigationController : UINavigationController

@property (strong, nonatomic) UIView *control;

- (void)changePosition:(float)position;
- (void)goProfile:(UISwipeGestureRecognizer *)gesture;
- (void)goActivities:(UISwipeGestureRecognizer *)gesture;

@end
