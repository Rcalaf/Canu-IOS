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

- (id)initWithFrame:(CGRect)frame User:(User *)user;

@end
