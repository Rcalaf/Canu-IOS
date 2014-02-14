//
//  UICANULocationCell.h
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;

@interface UICANULocationCell : UIView

@property (retain) id delegate;

- (id)initWithFrame:(CGRect)frame WithLocation:(Location *)location;

@end

@protocol UICANULocationCellDelegate <NSObject>

@required

- (void)cellLocationIsTouched:(UICANULocationCell *)cell;

@end