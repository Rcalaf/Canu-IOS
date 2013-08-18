//
//  DetailActivityViewController.h
//  CANU
//
//  Created by Roger Calaf on 18/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"


@interface DetailActivityViewController : UIViewController

//@property (strong, nonatomic) UIButton *backButton;
//@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UILabel *numberOfAssistents;
@property (strong, nonatomic) Activity *activity;


@end
