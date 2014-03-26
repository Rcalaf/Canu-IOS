//
//  CreateEditActivityViewController.h
//  CANU
//
//  Created by Vivien Cormier on 06/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AnimationCreateActivity.h"

@class Activity;

@interface CreateEditActivityViewController : UIViewController

@property (retain) id delegate;

/**
 *  Create activity (local or tribe)
 *
 *  @return
 */
- (id)initForCreate;

/**
 *  Edit a activity
 *
 *  @param activity
 *
 *  @return
 */
- (id)initForEdit:(Activity *)activity;

@end

@protocol CreateEditActivityViewControllerDelegate <NSObject>

@required

- (void)currentActivityWasDeleted;

@end
