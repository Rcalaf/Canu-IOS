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

@property (nonatomic) LoaderAnimation *loaderAnimation;
@property (nonatomic) NSMutableArray *arrayCell;

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity andMaxHeight:(int)maxHeight andMinHeight:(int)minHeight;

- (void)load;

- (void)scrollToBottom;

-(void)scrollToLastMessage;

- (void)scrollAnimationFolderFor:(int)contentOffset;

- (void)killScroll;

@end
