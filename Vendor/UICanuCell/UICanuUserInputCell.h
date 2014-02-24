//
//  UICanuUserInputCell.h
//  CANU
//
//  Created by Vivien Cormier on 20/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact,User;

@interface UICanuUserInputCell : UIView

- (id)initWithFrame:(CGRect)frame WithContact:(Contact *)contact AndUser:(User *)user;

@end
