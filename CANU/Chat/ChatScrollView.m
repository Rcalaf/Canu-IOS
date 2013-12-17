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

@interface ChatScrollView ()<UIScrollViewDelegate>

@property (nonatomic) Activity *activity;
@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSArray *messages;
@property (nonatomic) NSMutableArray *arrayCell;
@property (nonatomic) float yOriginLastMessage;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) UILabel *emptyChat;

@end

@implementation ChatScrollView

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity andMaxHeight:(int)maxHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        
        self.clipsToBounds = YES;
        
        self.isFirstTime = YES;
        
        self.activity = activity;
        
        self.arrayCell = [[NSMutableArray alloc]init];
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, -1, frame.size.width, maxHeight)];
        self.scrollview.alpha = 0;
        self.scrollview.delegate = self;
        [self addSubview:_scrollview];
        
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newX,newY;
    
    newX = scrollView.contentOffset.x;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    // Reload Animation
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newX,newY;
    
    newX = scrollView.contentOffset.x;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= - 80.0f ){
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
    }
    
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
        
        if (_emptyChat != nil) {
            
            [_emptyChat removeFromSuperview];
            _emptyChat = nil;
            
        }
        
        [_arrayCell removeAllObjects];
        
    }
    
    float heightTotalContent = 0;
    
    for (int i = 0; i < [_messages count]; i++) {
        
        self.yOriginLastMessage = heightTotalContent;
        
        Message *message = [_messages objectAtIndex:i];
        
        UICanuChatCellScroll *cell = [[UICanuChatCellScroll alloc]initWithFrame:CGRectMake(0, heightTotalContent, 300, 40) andMessage:message];
        heightTotalContent += [cell heightContent];
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
    }
    
    if ([_messages count] == 0) {
        
        self.emptyChat = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 60)];
        self.emptyChat.text = @"Touch and write the first message ...";
        self.emptyChat.font = [UIFont fontWithName:@"Lato-Regular" size:12.0];
        self.emptyChat.textColor = UIColorFromRGB(0x6d6e7a);
        [self.scrollview addSubview:_emptyChat];
        
    }
    
    self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, heightTotalContent);
    
    if (_scrollview.frame.size.height > heightTotalContent) {
        self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, _scrollview.frame.size.height);
    }
    
    if (_isFirstTime) {
        self.isFirstTime = !_isFirstTime;
        [self scrollToLastMessage];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollview.alpha = 1;
        }];
        
    }else{
        [self scrollToBottom];
    }
    
}

- (void)scrollToBottom{
    
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
}

-(void)scrollToLastMessage{
    
    self.scrollview.contentOffset = CGPointMake(0, _yOriginLastMessage);
    
}

- (void)scrollAnimationFolderFor:(int)contentOffset{
    
    self.scrollview.contentOffset = CGPointMake(0, _yOriginLastMessage - contentOffset);
    
}

- (void)killScroll{
    CGPoint offset = _scrollview.contentOffset;
    [_scrollview setContentOffset:offset animated:NO];
}

@end
