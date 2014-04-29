//
//  ActivityScrollViewController.h
//  CANU
//
//  Created by Vivien Cormier on 10/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UICanuActivityCellScroll.h"

typedef enum {
    FeedLocalType = 0,
    FeedTribeType = 1,
    FeedProfileType = 2,
} FeedTypes;

@class User;

@interface ActivityScrollViewController : UIViewController<UICanuActivityCellScrollDelegate>

@property (strong, nonatomic) NSArray *activities;
@property (nonatomic) BOOL isEmpty;
@property (nonatomic) BOOL isUnlock; // Counter
@property (retain) id delegate;

- (id)initFor:(FeedTypes)feedType andUser:(User *)user andFrame:(CGRect)frame;

/**
 *  Reload the feed view
 */
- (void)reload;

/**
 *  Reload the feed view without animation
 */
- (void)load;

/**
 *  Remove the view after logout / and children
 */
- (void)removeAfterlogOut;

- (void)openActivityAfterPush:(NSInteger)activityId;

- (BOOL)pushChatIsCurrentDetailsViewOpen:(NSInteger)activityId;

- (void)killCurrentDetailsViewController;

@end

@protocol ActivityScrollViewControllerDelegate <NSObject>

@required
- (void)hiddenProfileView:(BOOL)hidden Animated:(BOOL)animated;
- (void)moveProfileView:(float)offset;
- (void)activityScrollViewControllerStartWithEmptyFeed;
- (void)activityScrollViewControllerChangementFeed;
@end