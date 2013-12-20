//
//  ActivitiesFeedViewController.h
//  CANU
//
//  Created by Roger Calaf on 17/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityScrollViewController.h"


@interface ActivitiesFeedViewController : UIViewController

- (void)userInteractionFeedEnable:(BOOL)value;

- (void)changePosition:(float)position;

- (void)showHideProfile;

- (void)removeAfterlogOut;

@end
