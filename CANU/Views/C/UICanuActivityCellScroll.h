//
//  UICanuActivityCellScroll.h
//  CANU
//
//  Created by Vivien Cormier on 11/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UICanuActivityCellStatus) {
    UICanuActivityCellEditable  = 0,
    UICanuActivityCellGo        = 1,
    UICanuActivityCellToGo      = 2
};

@class Activity,User;

@interface UICanuActivityCellScroll : UIView

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) Activity *activity;
@property (retain) id delegate;

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity;

- (void)animateAfterDelay:(float)delay;

- (void)hiddenBottomBar:(BOOL)hidden;

- (void)updateWithActivity:(Activity *)activity;

- (void)forceDealloc;

@end

@protocol UICanuActivityCellScrollDelegate <NSObject>

@required
- (void)cellEventTouched:(UICanuActivityCellScroll *)cell;
- (void)cellEventActionButton:(UICanuActivityCellScroll *)cell;
- (void)cellEventAdresse:(UICanuActivityCellScroll *)cell;
@end