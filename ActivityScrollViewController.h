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

- (void)reload;

- (id)initFor:(FeedTypes)feedType andUser:(User *)user andFrame:(CGRect)frame;

- (void)removeAfterlogOut;

@end
