//
//  ActivityScrollViewController.h
//  CANU
//
//  Created by Vivien Cormier on 10/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UICanuActivityCellScroll.h"

@class User;

@interface ActivityScrollViewController : UIViewController<UICanuActivityCellScrollDelegate>

@property (strong, nonatomic) NSArray *activities;

- (id)initForUserProfile:(BOOL)isUserProfile andUser:(User *)user andFrame:(CGRect)frame;

@end
