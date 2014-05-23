//
//  InvitListViewController.m
//  CANU
//
//  Created by Vivien Cormier on 21/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "InvitListViewController.h"
#import "User.h"
#import "UserManager.h"
#import "UICanuBottomBar.h"
#import "UICanuButton.h"
#import "LoaderAnimation.h"
#import "UIScrollViewReverse.h"
#import "UICanuAttendeeCellScroll.h"

@interface InvitListViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UICanuBottomBar *bottomBar;
@property (strong, nonatomic) NSMutableArray *arrayCell;
@property (strong, nonatomic) LoaderAnimation *loaderAnimation;
@property (strong, nonatomic) UIScrollViewReverse *scrollview;
@property (strong, nonatomic) NSArray *users;
@property (nonatomic) BOOL isReload;
@property (nonatomic) BOOL isFirstTime;

@end

@implementation InvitListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.bottomBar = [[UICanuBottomBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 45)];
        [self.view addSubview:_bottomBar];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
        [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
        [self.bottomBar addSubview:backButton];
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 30) / 2, self.view.frame.size.height - 45 - 45, 30, 30) withStart:-20 andEnd:-100];
        [self.view addSubview:_loaderAnimation];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 1 - 45)];
        self.scrollview.delegate = self;
        [self.view addSubview:_scrollview];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload{
    
    self.isReload = YES;
    
    [self.loaderAnimation startAnimation];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollview.frame = CGRectMake(0, - 48, _scrollview.frame.size.width, _scrollview.frame.size.height);
    } completion:^(BOOL finished) {
        [self load];
    }];
    
}

- (void)load{
    
    [[[UserManager sharedUserManager] currentUser] tribes:^(NSArray *users, NSError *error) {
        
        self.users = users;
        
        [self showCell];
        
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

- (void)start{
    
    self.isFirstTime = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45);
    }];
    
    [self load];
    
}

- (void)close{
    
    
    
}

- (void)showCell{
    
    int row = 0;
    
    float heightContentScrollView = [self.users count] * (55 + 5) + 5;
    
    if (heightContentScrollView <= _scrollview.frame.size.height) {
        heightContentScrollView = _scrollview.frame.size.height + 1;
    }
    
    self.scrollview.contentSize = CGSizeMake(320, heightContentScrollView);
    
    for (int i = 0; i < [self.users count]; i++) {
        
        User *user = [self.users objectAtIndex:i];
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( row * (55 + 5) + 5 ) - 55, 300, 55) andUser:user orContact:nil];
        cell.delegate = self;
        cell.tribeMode = YES;
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        row ++;
        
    }
    
}

- (void)backAction{
    
    NSLog(@"Back");
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newY;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    // Reload Animation
    [self.loaderAnimation contentOffset:newY];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= -100.0f ){
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
    }
    
}

@end
