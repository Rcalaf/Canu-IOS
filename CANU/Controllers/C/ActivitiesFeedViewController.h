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

@property (strong, nonatomic) ActivityScrollViewController *localFeed;
@property (strong, nonatomic) ActivityScrollViewController *tribeFeed;
@property (strong, nonatomic) ActivityScrollViewController *profilFeed;

@property (nonatomic) BOOL activeTutorial;

- (void)changePosition:(float)position;

- (void)removeAfterlogOut;

- (BOOL)localFeedIsUnlock;

- (BOOL)pushChatIsCurrentDetailsViewOpen:(NSInteger)activityId;

- (void)killCurrentDetailsViewController;

- (void)stopTutorial;

- (void)tutorialStopMiddelLocalStep;

@end
