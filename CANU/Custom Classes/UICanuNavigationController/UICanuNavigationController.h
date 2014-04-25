//
//  UICanuNavigationController.h
//  CANU
//
//  Created by Roger Calaf on 30/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TutorialStep) {
    TutorialStepTribes = 1,
    TutorialStepLocal = 2,
    TutorialStepProfile = 3,
    TutorialStepFinish = 0
};

@class ActivitiesFeedViewController;

@interface UICanuNavigationController : UINavigationController

@property (nonatomic) BOOL userInteractionEnabled;
@property (strong, nonatomic) UIView *control;
@property (nonatomic) ActivitiesFeedViewController *activityFeed;

- (id)initWithActivityFeed:(ActivitiesFeedViewController *)activityFeed;
- (void)changePosition:(float)position;
- (void)changePage:(float)position;
- (void)blockForStep:(TutorialStep)step; // Tutorial

@end
