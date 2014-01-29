//
//  UIProfileView.h
//  CANU
//
//  Created by Roger Calaf on 16/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface UIProfileView : UIView

@property (readwrite, nonatomic) BOOL profileHidden;

- (id)initWithUser:(User *)user WithBottomBar:(BOOL)bottomBar AndNavigationchangement:(BOOL)navigationChangement OrTutorial:(BOOL)isTutorial;
- (void)hideComponents:(BOOL)hide;
@end
