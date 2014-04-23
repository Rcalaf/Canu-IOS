//
//  InvitOthersViewController.h
//  CANU
//
//  Created by Vivien Cormier on 17/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface InvitOthersViewController : UIViewController

@property (retain) id delegate;

- (instancetype)initWithFrame:(CGRect)frame andActivity:(Activity *)activity andInvits:(NSMutableArray *)invits;

- (void)addPeoples;

@end

@protocol InvitOthersViewControllerDelegate <NSObject>

@required

- (void)isDone;

@end
