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

@property (nonatomic) UIView *line;

- (id)initWithFrame:(CGRect)frame andMessage:(Message *)message;

- (float)heightContent;

@end
