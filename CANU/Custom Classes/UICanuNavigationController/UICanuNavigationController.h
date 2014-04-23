//
//  UICanuNavigationController.h
//  CANU
//
//  Created by Roger Calaf on 30/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivitiesFeedViewController;

@interface UICanuNavigationController : UINavigationController

@property (strong, nonatomic) UIView *control;
@property (nonatomic) ActivitiesFeedViewController *activityFeed;

- (id)initWithActivityFeed:(ActivitiesFeedViewController *)activityFeed;
- (void)changePosition:(float)position;
- (void)changePage:(float)position;

@end
