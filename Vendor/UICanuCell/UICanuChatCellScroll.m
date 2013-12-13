//
//  UICanuChatCellScroll.m
//  CANU
//
//  Created by Vivien Cormier on 13/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuChatCellScroll.h"

#import "Message.h"

@implementation UICanuChatCellScroll

- (id)initWithFrame:(CGRect)frame andMessage:(Message *)message
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 280, 1)];
        line.backgroundColor = UIColorFromRGB(0xe1e1e3);
        [self addSubview:line];
        
    }
    return self;
}

@end
