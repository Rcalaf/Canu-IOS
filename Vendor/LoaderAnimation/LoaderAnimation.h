//
//  LoaderAnimation.h
//  CANU
//
//  Created by Vivien Cormier on 18/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderAnimation : UIView

- (id)initWithFrame:(CGRect)frame withStart:(int)start andEnd:(int)end;

- (void)contentOffset:(float)contentOffset;

- (void)startAnimation;

- (void)stopAnimation;

@end
