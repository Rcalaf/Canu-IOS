//
//  UICanuChatCellScroll.h
//  CANU
//
//  Created by Vivien Cormier on 13/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;

@interface UICanuChatCellScroll : UIView

@property (nonatomic) BOOL isTheUser;

- (id)initWithFrame:(CGRect)frame andMessage:(Message *)message addTime:(BOOL)addTime isFirst:(BOOL)isFirst isLast:(BOOL)isLast isTheUser:(BOOL)isTheUser;

- (float)heightContent;

@end
