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
#import "UserManager.h"

@interface ChatScrollView ()<UIScrollViewDelegate>

@property (nonatomic) Activity *activity;
@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSArray *messages;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) UILabel *emptyChat;
@property (nonatomic) BOOL isReload;

@end

@implementation ChatScrollView

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.isFirstTime = YES;
        
        self.activity = activity;
        
        self.isReload = NO;
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake((frame.size.width - 30) / 2, frame.size.height - 40, 30, 30) withStart:-20 andEnd:-80];
        [self addSubview:_loaderAnimation];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, -2, frame.size.width, frame.size.height)];
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
    
    if (newY <= 0) {
        [self.delegate openDesciption];
    }
    
    if (newY >= 20) {
        [self.delegate closeDescription];
    }
    
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
    
    NSInteger previousSpeaker;
    
    float heightTotalContent = 2;
    
    for (int i = 0; i < [_messages count]; i++) {
        
        Message *message = [_messages objectAtIndex:i];
        
        BOOL isFirst = NO,isLast = NO, isTheUser = NO,addTime = NO;
        
        if (i == 0) {
            isLast = YES;
        }
        
        if (message.user.userId != previousSpeaker) {
            isLast = YES;
        }
        
        if (i + 1 < [_messages count]) {
            
            Message *messageNext = [_messages objectAtIndex:i+1];
            
            if (message.user.userId != messageNext.user.userId) {
                isFirst = YES;
            }
            
        } else {
            isFirst = YES;
        }
        
        previousSpeaker = message.user.userId;
        
        if (message.user.userId == [[UserManager sharedUserManager] currentUser].userId) {
            isTheUser = YES;
        }
        
        if (!isLast) {
            if (i - 1 >= 0) {
                
                NSDate *dateLimit = [message.date mk_dateByAddingMinutes:-5];
                
                Message *messageNext = [_messages objectAtIndex:i-1];
                
                if ([messageNext.date mk_isEarlierThanDate:dateLimit]) {
                    addTime = YES;
                }
                
            }
        }
        
        UICanuChatCellScroll *cell = [[UICanuChatCellScroll alloc]initWithFrame:CGRectMake(0, heightTotalContent, 300, 40) andMessage:message addTime:addTime isFirst:isFirst isLast:isLast isTheUser:isTheUser];
        heightTotalContent += [cell heightContent];
        if (i + 1 == [_messages count]) {
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + 10);
            heightTotalContent += 10;
        }
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
    }
    
    self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, heightTotalContent);
    
    if (_scrollview.frame.size.height > heightTotalContent) {
        
        for (int i = 0; i < [_arrayCell count]; i++) {
            
            UICanuChatCellScroll *cell = [_arrayCell objectAtIndex:i];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + (_scrollview.frame.size.height - heightTotalContent), cell.frame.size.width, cell.frame.size.height);
            
        }
        
        self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width, _scrollview.frame.size.height + 1);
        
    }
    
    if ([_messages count] == 0) {
        
        self.emptyChat.text = @"Say something";
        self.emptyChat.font = [UIFont fontWithName:@"Lato-Regular" size:12.0];
        self.emptyChat.alpha = 0.5;
        self.emptyChat.textAlignment = NSTextAlignmentCenter;
        self.emptyChat.textColor = UIColorFromRGB(0x6d6e7a);
        [self.scrollview addSubview:_emptyChat];
        
    }
    
    if (_isFirstTime) {
        self.isFirstTime = !_isFirstTime;
        [self scrollToBottom];
        
        // Animation
        
        NSInteger final = [_arrayCell count] - 6;
        float correction = 0;
        
        if (final < 0) {
            final = 0;
            correction = 0.3f;
        }
        
        for (NSInteger i = [_arrayCell count] - 1; i >= final; i--) {
            
            float delay = (([_arrayCell count] - 1) - i) * 0.1 + correction;
            
            int gap = 20;
            
            UICanuChatCellScroll *cell = [_arrayCell objectAtIndex:i];
            
            if (!cell.isTheUser) {
                gap = -20;
            }
            
            cell.frame = CGRectMake(cell.frame.origin.x + gap, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
            cell.alpha = 0;
            
            [UIView animateWithDuration:0.2 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.frame = CGRectMake(cell.frame.origin.x - gap, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                cell.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }else{
        [self scrollToBottom];
    }
    
}

- (void)scrollToBottom{
    
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
}

- (void)addSendMessage:(NSString *)text{
    
    Message *message = [[Message alloc]init];
    message.text = text;
    [message addDate:[NSDate date]];
    message.user = [[UserManager sharedUserManager]currentUser];
    NSLog(@"%@",message.date);
    
    NSMutableArray *arrayMessage = [[NSMutableArray alloc]initWithArray:_messages];
    [arrayMessage addObject:message];
    
    NSArray *array = [[NSArray alloc]initWithArray:arrayMessage];
    
    _messages = array;
    
    [self showMessages];
    
}

@end
