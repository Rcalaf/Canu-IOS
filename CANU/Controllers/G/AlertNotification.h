//
//  AlertNotification.h
//  CANU
//
//  Created by Vivien Cormier on 15/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity, PushRemote;

@interface AlertNotification : UIView

@property (nonatomic) BOOL enable;

- (id)initWithPush:(PushRemote *)push;

- (void)show;

@end
