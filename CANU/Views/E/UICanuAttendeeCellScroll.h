//
//  UICanuAttendeeCellScroll.h
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User,Contact;

@interface UICanuAttendeeCellScroll : UIView

@property (nonatomic) id delegate;

- (id)initWithFrame:(CGRect)frame andUser:(User *)user orContact:(Contact *)contact;

@end

@protocol UICanuAttendeeCellScrollDelegate <NSObject>

@end