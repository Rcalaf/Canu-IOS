//
//  MessageGhostUser.h
//  CANU
//
//  Created by Vivien Cormier on 21/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageGhostUser : UIView

@property (retain) id delegate;

- (id)initWithFrame:(CGRect)frame andArray:(NSMutableArray *)usersSelected andParentViewcontroller:(UIViewController *)viewController;

@end

@protocol MessageGhostUserDelegate <NSObject>

@required

- (void)messageGhostUserWillDisappear;

- (void)messageGhostUserWillDisappearForDeleteActivity;

@end
