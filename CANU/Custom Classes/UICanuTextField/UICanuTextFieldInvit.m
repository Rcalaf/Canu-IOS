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

@property (nonatomic) CANUTextfieldInvitStep canuTextfieldInvitStep;
@property (strong, nonatomic) UIView *wrapperTouchResetDeleteUser;
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
        
        self.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        
        self.activeReset = NO;
        
        self.canuTextfieldInvitStep = CANUTextfieldInvitStep0;
        
        self.arrayUserCell = [[NSMutableArray alloc]init];
        
        UIImageView *imgClose = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 45, 45)];
        imgClose.image = [UIImage imageNamed:@"F1_input_Location_reset"];
        
        self.resetSearch = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 45, 45)];
        [self.resetSearch addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchDown];
        self.resetSearch.clipsToBounds = YES;
        [self.resetSearch addSubview:imgClose];
        
        self.wrapperLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 42)];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 35)];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.wrapperLeft addSubview:_scrollView];
        
        self.leftView = _wrapperLeft;
        
    }
    return self;
}

#pragma mark - Private

- (void)updateScrollView{
    
    if ([_arrayUserCell count] != 0 ) {
        
        for (int i = 0; i < [_arrayUserCell count]; i++) {
            
            UICanuUserInputCell *cell = [_arrayUserCell objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayUserCell removeAllObjects];
        
    }
    
    self.scrollView.frame = CGRectMake(0, 0, 40 * [_arrayAllUserSelected count], 42);
    self.scrollView.contentSize = CGSizeMake(40 * [_arrayAllUserSelected count], 42);
    
    if ([_arrayAllUserSelected count] >= 3) {
        self.scrollView.frame = CGRectMake(0, 0, 40 * 3 - 20, 42);
    } else if ([_arrayAllUserSelected count] == 0) {
        self.scrollView.frame = CGRectMake(0, 0, 0, 42);
        self.scrollView.contentSize = CGSizeMake(0, 42);
    }
    
    for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
        
        Contact *contactData;
        User *userData;
        
        if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
            contactData = [_arrayAllUserSelected objectAtIndex:i];
        } else if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[User class]]) {
            userData = [_arrayAllUserSelected objectAtIndex:i];
        }
        
        UICanuUserInputCell *cell = [[UICanuUserInputCell alloc]initWithFrame:CGRectMake(5 + i * 40, 3, 35, 35) WithContact:contactData AndUser:userData];
        [self.scrollView addSubview:cell];
        [self.arrayUserCell addObject:cell];
        
    }
    
    self.scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0);
    self.wrapperLeft.frame = CGRectMake(0, 0, _scrollView.frame.size.width + 10, 42);
    [self updateSizeWrapperTouchResetDeleteUser];
    
    self.activeDeleteUser = NO;
    ;
    [self reset];
    
}

- (void)setActiveReset:(BOOL)activeReset{
    
    _activeReset = activeReset;
    
    if (activeReset) {
        self.rightView = _resetSearch;
        [self updateSizeWrapperTouchResetDeleteUser];
    } else {
        if ([_arrayUserCell count] != 0 && self.isFirstResponder) {
            self.activeDeleteUser = YES;
        } else {
            self.activeDeleteUser = NO;
        }
        self.rightView = nil;
        [self updateSizeWrapperTouchResetDeleteUser];
    }
    
}

- (void)setActiveDeleteUser:(BOOL)activeDeleteUser{
    
    _activeDeleteUser = activeDeleteUser;
    
    if (activeDeleteUser) {
        
        if (_canuTextfieldInvitStep == CANUTextfieldInvitStep0) {
            self.canuTextfieldInvitStep = CANUTextfieldInvitStep1;
        }
        
        self.text = @" ";
        
    } else {
        
        if ([_arrayUserCell count] != 0) {
            UICanuUserInputCell *cell = [_arrayUserCell lastObject];
            cell.isSelected = NO;
        }
        
        self.canuTextfieldInvitStep = CANUTextfieldInvitStep0;
        
        [self.wrapperTouchResetDeleteUser removeFromSuperview];
        self.wrapperTouchResetDeleteUser = nil;
        
    }
    
}

- (void)reset{
    self.text = @"";
    self.activeReset = NO;
    [self.delegateFieldInvit inputFieldInvitIsEmpty];
}

- (void)updateSizeWrapperTouchResetDeleteUser{
    if (_wrapperTouchResetDeleteUser) {
        self.wrapperTouchResetDeleteUser.frame = CGRectMake(self.leftView.frame.size.width, 0, self.frame.size.width - self.leftView.frame.size.width - self.rightView.frame.size.width, self.frame.size.height);
    }
}

- (void)resetDeleteUser{
    
    self.activeDeleteUser = NO;
    
    self.activeDeleteUser = YES;
    
}

#pragma mark - Public

- (void)updateUserSelected:(NSMutableArray *)arrayAllUserSelected{
    
    self.arrayAllUserSelected = arrayAllUserSelected;
    
    [self updateScrollView];
    
}

- (void)touchDelete{
    
    if (_canuTextfieldInvitStep == CANUTextfieldInvitStep1) {
        self.canuTextfieldInvitStep = CANUTextfieldInvitStep2;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetDeleteUser)];
        
        self.wrapperTouchResetDeleteUser = [[UIView alloc]initWithFrame:CGRectMake(self.leftView.frame.size.width, 0, self.frame.size.width - self.leftView.frame.size.width - self.rightView.frame.size.width, self.frame.size.height)];
        self.wrapperTouchResetDeleteUser.backgroundColor = [UIColor whiteColor];
        [self.wrapperTouchResetDeleteUser addGestureRecognizer:tap];
        [self addSubview:_wrapperTouchResetDeleteUser];
        
        [self selectLastUser];
        
    } else if (_canuTextfieldInvitStep == CANUTextfieldInvitStep2) {
        
        [self deleteLastUser];
        
        [self.wrapperTouchResetDeleteUser removeFromSuperview];
        self.wrapperTouchResetDeleteUser = nil;
        
        self.canuTextfieldInvitStep = CANUTextfieldInvitStep1;
    }

}

- (void)selectLastUser{
    
    [self.scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0) animated:YES];
    
    UICanuUserInputCell *cell = [_arrayUserCell lastObject];
    cell.isSelected = YES;
    
}

- (void)deleteLastUser{
    
    UICanuUserInputCell *cell = [_arrayUserCell lastObject];
    
    if (cell.user) {
        [self.delegateFieldInvit deleteLastUser:cell.user];
    } else {
        [self.delegateFieldInvit deleteLastContact:cell.contact];
    }
    
}

- (BOOL)becomeFirstResponder{
    
    BOOL returnValue = [super becomeFirstResponder];
    if (returnValue){
        if (![self.text isEqualToString:@""]) {
            self.activeReset = YES;
        } else if ([_arrayUserCell count] != 0) {
            self.activeDeleteUser = YES;
        }
    }
    return returnValue;
}

- (BOOL)resignFirstResponder{
    BOOL returnValue = [super resignFirstResponder];
    if (returnValue){
        self.activeReset = NO;
        if ([self.text isEqualToString:@" "]) {
            self.text = @"";
        }
    }
    return returnValue;
}

@end
