//
//  UICanuActivityCellScroll.h
//  CANU
//
//  Created by Vivien Cormier on 11/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface UICanuActivityCellScroll : UIView

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UIImageView *animationButtonGo;
@property (strong, nonatomic) UIImageView *animationButtonToGo;
@property (strong, nonatomic) Activity *activity;
@property (retain) id delegate;

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity;

@end

@protocol UICanuActivityCellScrollDelegate <NSObject>

@required
- (void)cellEventActionButton:(UICanuActivityCellScroll *)cell;
@end