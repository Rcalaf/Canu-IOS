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
#import "LoaderAnimation.h"

@interface ChatScrollView ()<UIScrollViewDelegate>

@property (nonatomic) Activity *activity;
@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSArray *messages;
@property (nonatomic) int smallSize;
@property (nonatomic) float yOriginLastMessage;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) UILabel *emptyChat;
@property (nonatomic) BOOL isReload;

@end

@implementation ChatScrollView

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity andMaxHeight:(int)maxHeight andMinHeight:(int)minHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.smallSize = minHeight;
        
        self.backgroundColor = UIColorFromRGB(0xf8fafa);
        
        self.isFirstTime = YES;
        
        self.activity = activity;
        
        self.isReload = NO;
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, maxHeight + 57)];
        background.backgroundColor = UIColorFromRGB(0xf8fafa);
        [self addSubview:background];
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake((frame.size.width - 30) / 2, maxHeight - 40, 30, 30) withStart:-20 andEnd:-80];
        [self addSubview:_loaderAnimation];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, -2, frame.size.width, maxHeight)];
        self.scrollview.alpha = 0;
        self.scrollview.delegate = self;
        [self addSubview:_scrollview];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newY;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    // Reload Animation
    [self.loaderAnimation contentOffset:newY];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newX,newY;
    
    newX = scrollView.contentOffset.x;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= - 80.0f ){;
        [self performSelectorOnMainThread:@selector(reload) withObject:self waitUntilDone:NO];
    }
    
}

- (void)reload{
    
    self.isReload = YES;
    
    [self.loaderAnimation startAnimation];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollview.frame = CGRectMake(0, - 58, _scrollview.frame.size.width, _scrollview.frame.size.height);
    } completion:^(BOOL finished) {
        [self load];
    }];
    
}

- (void)load{
    
    [self.activity messagesWithBlock:^(NSArray *messages, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            
            _messages = messages;
            
            [self showMessages];
            
        }
        
        if (_isReload) {
            
            [UIView animateWithDuration:0.4 animations:^{
                self.scrollview.frame = CGRectMake( 0, -1, _scrollview.frame.size.width, _scrollview.frame.size.height);
            } completion:^(BOOL finished) {
                [self.loaderAnimation stopAnimation];
                
                self.isReload = NO;
                
            }];
        }
        
        [self.loaderAnimation stopAnimation];
        
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
    
    float heightTotalContent = 2;
    
    for (int i = 0; i < [_messages count]; i++) {
        
        self.yOriginLastMessage = heightTotalContent;
        
        Message *message = [_messages objectAtIndex:i];
        
        UICanuChatCellScroll *cell = [[UICanuChatCellScroll alloc]initWithFrame:CGRectMake(0, heightTotalContent, 300, 40) andMessage:message];
        heightTotalContent += [cell heightContent];
        [self.scrollview addSubview:cell];
        
        if (i == 0) {
            cell.line.alpha = 0;
        }
        
        [_arrayCell addObject:cell];
        
    }
    
    self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, heightTotalContent);
    
    if (_scrollview.frame.size.height > heightTotalContent) {
        
        for (int i = 0; i < [_arrayCell count]; i++) {
            
            UICanuChatCellScroll *cell = [_arrayCell objectAtIndex:i];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + (_scrollview.frame.size.height - heightTotalContent), cell.frame.size.width, cell.frame.size.height);
            
        }
        
        UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, (_scrollview.frame.size.height - heightTotalContent))];
        background.backgroundColor = UIColorFromRGB(0xf8fafa);
        [self.scrollview addSubview:background];
        
        self.yOriginLastMessage = _yOriginLastMessage + (_scrollview.frame.size.height - heightTotalContent);
        
        self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, _scrollview.frame.size.height + 1);
    }
    
    if ([_messages count] == 0) {
        
        self.yOriginLastMessage = _scrollview.frame.size.height - _smallSize;
        self.emptyChat = [[UILabel alloc]initWithFrame:CGRectMake(10, _scrollview.frame.size.height - _smallSize, 280, _smallSize)];
        self.emptyChat.text = @"Say something";
        self.emptyChat.font = [UIFont fontWithName:@"Lato-Regular" size:12.0];
        self.emptyChat.alpha = 0.5;
        self.emptyChat.textAlignment = NSTextAlignmentCenter;
        self.emptyChat.textColor = UIColorFromRGB(0x6d6e7a);
        [self.scrollview addSubview:_emptyChat];
        
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
