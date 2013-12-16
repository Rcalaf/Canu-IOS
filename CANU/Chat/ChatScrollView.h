//
//  ChatScrollView.h
//  CANU
//
//  Created by Vivien Cormier on 13/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface ChatScrollView : UIView

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity andMaxHeight:(int)maxHeight;

- (void)reload;

- (void)scrollToBottom;

-(void)scrollToLastMessage;

@end
