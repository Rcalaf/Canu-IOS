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
@property (nonatomic) UIImageView *profileImage;
@property (nonatomic) UIImageView *settingsButton;
@property (nonatomic) UIView *mask;

- (id)initWithUser:(User *)user andFrame:(CGRect)frame;
- (void)hideComponents:(BOOL)hide;
@end
