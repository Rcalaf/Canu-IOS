//
//  MessageGhostUser.h
//  CANU
//
//  Created by Vivien Cormier on 21/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface MessageGhostUser : UIView

@property (retain) id delegate;

@property (nonatomic) BOOL forCreateActivity;

- (id)initWithFrame:(CGRect)frame andArray:(NSMutableArray *)usersSelected andParentViewcontroller:(UIViewController *)viewController withActivity:(Activity *)activity;

@end

@protocol MessageGhostUserDelegate <NSObject>

@optional

- (void)messageGhostUserWillDisappearForDeleteActivity;

@required

- (void)messageGhostUserWillDisappearAfterSucess;
- (void)messageGhostUserWillDisappearAfterFail;

@end
