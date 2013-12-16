//
//  ChatScrollView.m
//  CANU
//
//  Created by Vivien Cormier on 13/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "ChatScrollView.h"

#import "Activity.h"

#import "UICanuChatCellScroll.h"

#import "UIScrollViewReverse.h"

@interface ChatScrollView ()

@property (nonatomic) Activity *activity;
@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSArray *messages;
@property (nonatomic) NSMutableArray *arrayCell;

@end

@implementation ChatScrollView

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity andMaxHeight:(int)maxHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        
        self.clipsToBounds = YES;
        
        self.activity = activity;
        
        self.arrayCell = [[NSMutableArray alloc]init];
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, maxHeight)];
        [self addSubview:_scrollview];
        
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
        
    }
    return self;
}

- (void)reload{
    
    [self.activity messagesWithBlock:^(NSArray *messages, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            
            _messages = messages;
            
            [self showMessages];
            
        }
        
//        if (self.refreshControl.refreshing) {
//            [self.refreshControl endRefreshing];
//        }
        
    }];
    
}

- (void)showMessages{
    
    if ([_arrayCell count] != 0 ) {
        
        for (int i = 0; i < [_arrayCell count]; i++) {
            
            UICanuChatCellScroll *cell = [_arrayCell objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayCell removeAllObjects];
        
    }
    
    float heightTotalContent = 0;
    
    for (int i = 0; i < [_messages count]; i++) {
        
        Message *message = [_messages objectAtIndex:i];
        
        UICanuChatCellScroll *cell = [[UICanuChatCellScroll alloc]initWithFrame:CGRectMake(0, heightTotalContent, 300, 40) andMessage:message];
        heightTotalContent += [cell heightContent];
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
    }
    
    self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, heightTotalContent);
    
    if (_scrollview.frame.size.height > heightTotalContent) {
        self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, _scrollview.frame.size.height);
    }
    
}

@end
