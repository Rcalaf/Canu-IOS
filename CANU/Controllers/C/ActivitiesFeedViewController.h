//
//  ActivitiesFeedViewController.h
//  CANU
//
//  Created by Roger Calaf on 17/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityScrollViewController.h"

#import "AnimationCreateActivity.h"

@interface ActivitiesFeedViewController : UIViewController

@property (strong, nonatomic) AnimationCreateActivity *animationCreateActivity;

- (void)changePosition:(float)position;

- (void)removeAfterlogOut;

- (BOOL)localFeedIsUnlock;

@end
