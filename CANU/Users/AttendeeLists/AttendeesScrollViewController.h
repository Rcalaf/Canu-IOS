//
//  AttendeesScrollViewController.h
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface AttendeesScrollViewController : UIViewController

@property (strong, nonatomic) Activity *activity;
@property (strong, nonatomic) NSArray *attendees;

- (id)initWithFrame:(CGRect)frame;

@end
