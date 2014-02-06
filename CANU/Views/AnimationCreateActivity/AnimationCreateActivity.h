//
//  AnimationCreateActivity.h
//  CANU
//
//  Created by Vivien Cormier on 05/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CANUCreateActivity) {
    CANUCreateActivityNone = 0,     // Action abort
    CANUCreateActivityLocal = 1,    // Local activity
    CANUCreateActivityTribes = 2    // Tribes Activity
};

@interface AnimationCreateActivity : UIView

/**
 *  If the view is active for the animation
 */
@property (nonatomic) BOOL active;

/**
 *  Active the view and the animation
 */
- (void)startView;

/**
 *  Animate the view with value
 *
 *  @param position
 */
- (void)animateWithPosition:(float)position;

/**
 *  Stop the view and prepare the transition for New Activity Controller
 *
 *  @param canuCreateActivity
 */
- (void)stopViewFor:(CANUCreateActivity)canuCreateActivity;

@end
