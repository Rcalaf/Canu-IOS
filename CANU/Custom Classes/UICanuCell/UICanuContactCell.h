//
//  UICanuContactCell.h
//  CANU
//
//  Created by Vivien Cormier on 20/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact,User;

@interface UICanuContactCell : UIView

@property (retain) id delegate;
@property (strong, nonatomic) UIImageView *square;
@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) User *user;

- (id)initWithFrame:(CGRect)frame WithContact:(Contact *)contact AndUser:(User *)user;

@end

@protocol UICanuContactCellDelegate <NSObject>

@required

- (void)cellLocationIsTouched:(UICanuContactCell *)cell;

@end
