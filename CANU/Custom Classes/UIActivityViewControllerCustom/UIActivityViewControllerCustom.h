//
//  UIActivityViewControllerCustom.h
//  CANU
//
//  Created by Vivien Cormier on 07/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActivityViewControllerCustom : UIView

@property (retain) id delegate;
@property (retain) id object;

- (instancetype)initWithUIImage:(UIImage *)image andButtons:(NSArray *)buttons;

- (void)show;

@end

@protocol UIActivityViewControllerCustomDelegate <NSObject>

@optional

- (void)ActivityAction:(NSString *)action;
- (void)ActivityAction:(NSString *)action WithObject:(id)object;

@end
