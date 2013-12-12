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

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *settingsButton;
@property (strong, nonatomic) UIView *mask;
@property (strong, nonatomic) UIImageView *hideArrow;
@property (readwrite, nonatomic) BOOL profileHidden;


- (id)initWithUser:(User *)user andFrame:(CGRect)frame;
- (void)hideComponents:(BOOL)hide;
@end
