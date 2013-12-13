//
//  DetailActivityViewControllerAnimate.h
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface DetailActivityViewControllerAnimate : UIViewController

- (id)initFrame:(CGRect)frame andActivity:(Activity *)activity andPosition:(int)positionY;

@end
