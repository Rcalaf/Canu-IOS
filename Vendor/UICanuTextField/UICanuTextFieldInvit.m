//
//  UICanuTextFieldInvit.m
//  CANU
//
//  Created by Vivien Cormier on 20/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextFieldInvit.h"
#import "UICanuUserInputCell.h"
#import "Contact.h"
#import "User.h"

@interface UICanuTextFieldInvit ()

@property (strong, nonatomic) UIView *wrapperLeft;
@property (strong, nonatomic) UIButton *resetSearch;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *arrayAllUserSelected;
@property (strong, nonatomic) NSMutableArray *arrayUserCell;

@end

@implementation UICanuTextFieldInvit

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activeReset = NO;
        
        self.arrayUserCell = [[NSMutableArray alloc]init];
        
        UIImageView *imgClose = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 47, 47)];
        imgClose.image = [UIImage imageNamed:@"F1_input_Location_reset"];
        
        self.resetSearch = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 47, 47)];
        [self.resetSearch addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchDown];
        self.resetSearch.backgroundColor = [UIColor whiteColor];
        self.resetSearch.clipsToBounds = YES;
        [self.resetSearch addSubview:imgClose];
        
        self.wrapperLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 47)];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 47)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.wrapperLeft addSubview:_scrollView];
        
        self.leftView = _wrapperLeft;
        
    }
    return self;
}

#pragma mark - Private

- (void)updateScrollView{
    
    self.text = @"";
    self.activeReset = NO;
    
    if ([_arrayUserCell count] != 0 ) {
        
        for (int i = 0; i < [_arrayUserCell count]; i++) {
            
            UICanuUserInputCell *cell = [_arrayUserCell objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayUserCell removeAllObjects];
        
    }
    
    self.scrollView.frame = CGRectMake(0, 0, 48 * [_arrayAllUserSelected count], 47);
    self.scrollView.contentSize = CGSizeMake(48 * [_arrayAllUserSelected count], 47);
    
    if ([_arrayAllUserSelected count] >= 3) {
        self.scrollView.frame = CGRectMake(0, 0, 48 * 3 - 24, 47);
    } else if ([_arrayAllUserSelected count] == 0) {
        self.scrollView.frame = CGRectMake(0, 0, 10, 47);
        self.scrollView.contentSize = CGSizeMake(10, 47);
    }
    
    for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
        
        Contact *contactData;
        User *userData;
        
        if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
            contactData = [_arrayAllUserSelected objectAtIndex:i];
        } else if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[User class]]) {
            userData = [_arrayAllUserSelected objectAtIndex:i];
        }
        
        UICanuUserInputCell *cell = [[UICanuUserInputCell alloc]initWithFrame:CGRectMake(i * 48, 0, 47, 47) WithContact:contactData AndUser:userData];
        [self.scrollView addSubview:cell];
        [self.arrayUserCell addObject:cell];
        
    }
    
    self.scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0);
    self.wrapperLeft.frame = CGRectMake(0, 0, _scrollView.frame.size.width + 10, 47);
    
}

- (void)setActiveReset:(BOOL)activeReset{
    
    _activeReset = activeReset;
    
    if (activeReset) {
        self.rightView = _resetSearch;
    } else {
        self.rightView = nil;
    }
    
}

- (void)reset{
    self.text = @"";
    self.activeReset = NO;
}

#pragma mark - Public

- (void)updateUserSelected:(NSMutableArray *)arrayAllUserSelected{
    
    self.arrayAllUserSelected = arrayAllUserSelected;
    
    [self updateScrollView];
    
}

- (BOOL)becomeFirstResponder{
    
    BOOL returnValue = [super becomeFirstResponder];
    if (returnValue){
        if (![self.text isEqualToString:@""]) {
            self.activeReset = YES;
        }
    }
    return returnValue;
}

- (BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        self.activeReset = NO;
    }
    return returnValue;
}

@end
