//
//  ChatScrollView.h
//  CANU
//
//  Created by Vivien Cormier on 13/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity,LoaderAnimation;

@interface ChatScrollView : UIView

@property (nonatomic) id delegate;
@property (nonatomic) LoaderAnimation *loaderAnimation;
@property (nonatomic) NSMutableArray *arrayCell;

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity;

- (void)load;

- (void)addSendMessage:(NSString *)text;

@end

@protocol ChatScrollViewDelegate <NSObject>

@required
- (void)openDesciption;
- (void)closeDescription;
@end