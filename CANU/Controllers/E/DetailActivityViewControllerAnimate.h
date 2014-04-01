//
//  DetailActivityViewControllerAnimate.h
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CANUOpenDetailsActivityAfter) {
    CANUOpenDetailsActivityAfterPush = 1,          // Open DetailsActivity After push notification
    CANUOpenDetailsActivityAfterFeedView = 2,      // Open DetailsActivity After click in the feed view
    CANUOpenDetailsActivityAfterCreateEdit = 3     // Open DetailsActivity After Create or Edit a Acitvity
};

@class Activity;

@interface DetailActivityViewControllerAnimate : UIViewController

@property (retain) id delegate;
@property (nonatomic) BOOL closeAfterDelete;
@property (nonatomic) Activity *activity;

- (id)initFrame:(CGRect)frame andActivity:(Activity *)activity For:(CANUOpenDetailsActivityAfter)canuOpenDetailsActivityAfter andPosition:(int)positionY;

@end

@protocol DetailActivityViewControllerAnimateDelegate <NSObject>

@required
- (void)closeDetailActivity:(DetailActivityViewControllerAnimate *)viewController;
@end
