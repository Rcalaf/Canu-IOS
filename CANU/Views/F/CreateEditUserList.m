//
//  CreateEditUserList.m
//  CANU
//
//  Created by Vivien Cormier on 11/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "CreateEditUserList.h"
#import "PhoneBook.h"
#import "Contact.h"
#import "UICanuContactCell.h"
#import "User.h"
#import "UserManager.h"
#import "AppDelegate.h"

@interface CreateEditUserList () <UICanuContactCellDelegate, UIScrollViewDelegate>

@property (nonatomic) BOOL loadMore;
@property (nonatomic) BOOL stopLoadMore;
@property (nonatomic) NSInteger numberCell;
@property (strong, nonatomic) Contact *contactLocal;
@property (strong, nonatomic) NSMutableArray *arrayContact;
@property (strong, nonatomic) NSMutableArray *arrayCanuUser;
@property (strong, nonatomic) NSMutableArray *arrayCellCanuUser;

@end

@implementation CreateEditUserList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.loadMore = NO;
        self.stopLoadMore = NO;
        self.forceLocalCell = NO;
        self.isSearchMode = NO;
        
        self.numberCell = 10;
        
        self.maxHeight = 10;
        self.minHeigt = [[UIScreen mainScreen] bounds].size.height - 10 - 45;
        
        self.contactLocal = [[Contact alloc]initForLocal];
        
        self.clipsToBounds = YES;
        
        self.arrayCellCanuUser = [[NSMutableArray alloc]init];
        self.arrayAllUserSelected = [[NSMutableArray alloc]init];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, _maxHeight)];
        self.scrollView.scrollEnabled = NO;
        self.scrollView.delegate = self;
        
        self.active = NO;
        
        [self addSubview:_scrollView];
        
        self.alpha = 0;
        
        NSError *error = [PhoneBook checkPhoneBookAccess];
        
        if (error) {
            self.canuError = error.code;
        }
        
    }
    return self;
}

- (void)forceDealloc{
    
    if (self.scrollView) {
        if ([self.scrollView superview]) {
            [self.scrollView removeFromSuperview];
        }
    }
    
    [self.arrayContact removeAllObjects];
    [self.arrayCanuUser removeAllObjects];
    [self.arrayCellCanuUser removeAllObjects];
    [self.arrayAllUserSelected removeAllObjects];
    
    _scrollView = nil;
    _arrayContact = nil;
    _arrayCanuUser = nil;
    _arrayCellCanuUser = nil;
    _arrayAllUserSelected = nil;
    
}

- (void)dealloc{
    NSLog(@"CreateEditUserList dealloc");
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.delegate hiddenKeyboardUserList];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self manageLoadCell:scrollView.contentOffset.y];
}

#pragma mark - Public

- (void)lauchView{
    
    if (!_canuError) {
        [NSThread detachNewThreadSelector:@selector(checkPhoneBook) toTarget:self withObject:nil];
    }
    
}

/**
 *  Phone book is now available
 */
- (void)phoneBookIsAvailable{
    
    self.canuError = CANUErrorNoError;
    
    [NSThread detachNewThreadSelector:@selector(checkPhoneBook) toTarget:self withObject:nil];
}

- (void)animateToMaxHeight{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _maxHeight);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.frame = CGRectMake(0, 0, 320, _maxHeight);
}

- (void)animateToMinHeight{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _minHeigt);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.frame = CGRectMake(0, 10, 320, _minHeigt - 10);
}

- (void)updateAndDeleteUser:(User *)user{
    
    for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
        
        if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[User class]]) {
            User *userData = [_arrayAllUserSelected objectAtIndex:i];
            if (userData == user) {
                [_arrayAllUserSelected removeObjectAtIndex:i];
            }
        }
        
    }
    
    for (int i = 0; i < [_arrayCellCanuUser count]; i++) {
        
        UICanuContactCell *cell = [_arrayCellCanuUser objectAtIndex:i];
        
        if (cell.user == user) {
            cell.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location"];
        }
        
    }
    
    [self.delegate changeUserSelected:_arrayAllUserSelected];
    
}

- (void)updateAndDeleteContact:(Contact *)contact{
    
    for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
        
        if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
            Contact *contactData = [_arrayAllUserSelected objectAtIndex:i];
            if (contactData == contact) {
                [_arrayAllUserSelected removeObjectAtIndex:i];
            }
        }
        
    }
    
    for (int i = 0; i < [_arrayCellCanuUser count]; i++) {
        
        UICanuContactCell *cell = [_arrayCellCanuUser objectAtIndex:i];
        
        if (cell.contact == contact) {
            cell.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location"];
        }
        
    }
    
    [self.delegate changeUserSelected:_arrayAllUserSelected];
    
}

- (void)scrollContentOffsetY:(float)y{
    
    [self manageLoadCell:y];
    
}

#pragma mark - Private

- (void)checkPhoneBook{
    
    [PhoneBook contactPhoneBookWithBlock:^(NSMutableArray *arrayContact, NSError *error) {
        
        if (error) {
            
        } else {
            
            self.arrayContact = arrayContact;
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            
            if (!appDelegate.arrayContactCanuUser) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                                       self.numberCell = 10;
                                       self.stopLoadMore = NO;
                                       self.loadMore = NO;
                                       [self showUser];
                                   });
                });
            }
            
            if ([arrayContact count] != 0) {
                
                [[[UserManager sharedUserManager] currentUser] checkPhoneBook:arrayContact WithBlock:^(NSMutableArray *arrayCANUUser, NSError *error) {
                    
                    self.arrayCanuUser = arrayCANUUser;
                    
                    if (error) {
                        
                    } else {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            dispatch_async(dispatch_get_main_queue(),
                                           ^{
                                               self.numberCell = 10;
                                               self.stopLoadMore = NO;
                                               self.loadMore = NO;
                                               [self showUser];
                                           });
                        });
                    }
                    
                }];
                
            }
            
        }
        
    }];
    
}

- (void)showUser{
    
    if ([_arrayCellCanuUser count] != 0 ) {
        
        for (int i = 0; i < [_arrayCellCanuUser count]; i++) {
            
            UICanuContactCell *cell = [_arrayCellCanuUser objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayCellCanuUser removeAllObjects];
        
    }
    
    NSInteger maxCanuUser = _numberCell;
    
    if (maxCanuUser > [_arrayCanuUser count]) {
        maxCanuUser = [_arrayCanuUser count];
    }
    
    NSInteger maxContact = _numberCell - maxCanuUser;
    
    if (maxContact > [_arrayContact count]) {
        maxContact = [_arrayContact count];
        self.stopLoadMore = YES;
    }
    
    NSInteger marginTop = 10;
    
    if (_isSearchMode) {
        marginTop = 20;
    }
    
    int row = 0;
    
    // Local cell
    
    UICanuContactCell *celllocal = [[UICanuContactCell alloc]initWithFrame:CGRectMake(10, marginTop + row * (55 + 5), 300, 55) WithContact:_contactLocal AndUser:nil];
    celllocal.delegate = self;
    if (_forceLocalCell) {
        celllocal.isDisable = YES;
        celllocal.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
    }
    [self.scrollView addSubview:celllocal];
    [self.arrayCellCanuUser addObject:celllocal];
    
    for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
        
        if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
            Contact *contactData = [_arrayAllUserSelected objectAtIndex:i];
            if (contactData.isLocal) {
                celllocal.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
            }
        }
        
    }
    
    row++;
    
    for (int i = 0; i < maxCanuUser; i++) {
        
        User *user = [_arrayCanuUser objectAtIndex:i];
        
        Contact *contact = nil;
        
        for (int y = 0; y < [_arrayContact count]; y ++) {
            
            Contact *contactData = [_arrayContact objectAtIndex:y];
            
            if ([contactData.convertNumber isEqualToString:user.phoneNumber]) {
                contact = contactData;
            }
            
        }
        
        BOOL alreadySelected = NO;
        
        for (int y = 0; y < [self.peoplesAlreadySelected count]; y++) {
            
            NSString *phoneNumber = [self.peoplesAlreadySelected objectAtIndex:y];
            
            if ([phoneNumber isEqualToString:user.phoneNumber]) {
                alreadySelected = YES;
            }
            
        }
        
        UICanuContactCell *cellContact = [[UICanuContactCell alloc]initWithFrame:CGRectMake(10, marginTop + row * (55 + 5), 300, 55) WithContact:contact AndUser:user];
        cellContact.delegate = self;
        cellContact.isDisable = alreadySelected;
        [self.scrollView addSubview:cellContact];
        [self.arrayCellCanuUser addObject:cellContact];
        
        for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
            
            if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[User class]]) {
                User *userData = [_arrayAllUserSelected objectAtIndex:i];
                if (userData == cellContact.user) {
                    cellContact.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
                }
            }
            
        }
        
        row++;
        
    }
    
    for (int i = 0; i < maxContact; i++) {
        
        Contact *contact = [_arrayContact objectAtIndex:i];
        
        User *user = nil;
        
        for (int y = 0; y < [_arrayCanuUser count]; y ++) {
            
            User *userData = [_arrayCanuUser objectAtIndex:y];
            
            if ([userData.phoneNumber isEqualToString:contact.convertNumber]) {
                user = userData;
            }
            
        }
        
        if (!user) {
            
            BOOL alreadySelected = NO;
            
            for (int y = 0; y < [self.peoplesAlreadySelected count]; y++) {
                
                NSString *phoneNumber = [self.peoplesAlreadySelected objectAtIndex:y];
                
                if ([phoneNumber isEqualToString:contact.convertNumber]) {
                    alreadySelected = YES;
                }
                
            }
            
            UICanuContactCell *cellContact = [[UICanuContactCell alloc]initWithFrame:CGRectMake(10, marginTop + row * (55 + 5), 300, 55) WithContact:contact AndUser:nil];
            cellContact.delegate = self;
            cellContact.isDisable = alreadySelected;
            [self.scrollView addSubview:cellContact];
            [self.arrayCellCanuUser addObject:cellContact];
            
            for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
                
                if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
                    Contact *contactData = [_arrayAllUserSelected objectAtIndex:i];
                    if (contactData == cellContact.contact) {
                        cellContact.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
                    }
                }
                
            }
            
            row++;
        }
        
    }
    
    NSInteger marginForLoadMore = 100;
    
    if (_stopLoadMore) {
        marginForLoadMore = 0;
    }
    
    self.loadMore = NO;
    
    self.scrollView.contentSize = CGSizeMake(320, row * ( 55 + 5) + marginTop + 5 + marginForLoadMore);
    
    self.maxHeight = row * ( 55 + 5) + marginTop + 5 + marginForLoadMore;
    
    if (_isSearchMode) {
        self.scrollView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _minHeigt);
    } else {
        self.scrollView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _maxHeight);
    }
    
    self.active = YES;
    
    if (!_isSearchMode) {
        [self.delegate phoneBookIsLoad];
    }
    
}

- (void)manageLoadCell:(float)value{
    
    if (value + _minHeigt > _scrollView.contentSize.height - 100) {
        if (!self.loadMore && !self.stopLoadMore) {
            self.loadMore = YES;
            self.numberCell += 100;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(),
                               ^{
                                   [self showUser];
                               });
            });
        }
    }
    
}

#pragma mark - UICanuContactCellDelegate

- (void)cellLocationIsTouched:(UICanuContactCell *)cell{
    
    BOOL isAlreadySelected = NO;
    
    for (int i = 0; i < [_arrayAllUserSelected count]; i++) {
        
        if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
            Contact *contactData = [_arrayAllUserSelected objectAtIndex:i];
            if (contactData == cell.contact) {
                isAlreadySelected = YES;
            }
        } else if ([[_arrayAllUserSelected objectAtIndex:i] isKindOfClass:[User class]]) {
            User *userData = [_arrayAllUserSelected objectAtIndex:i];
            if (userData == cell.user) {
                isAlreadySelected = YES;
            }
        }
        
    }
    
    if (isAlreadySelected) {
        
        if (cell.user) {
            [_arrayAllUserSelected removeObject:cell.user];
        } else {
            [_arrayAllUserSelected removeObject:cell.contact];
        }
    
        cell.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location"];
        
    } else {
        
        if (cell.user) {
            [_arrayAllUserSelected addObject:cell.user];
        } else {
            [_arrayAllUserSelected addObject:cell.contact];
        }
        
        cell.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
        
    }
    
    [self.delegate changeUserSelected:_arrayAllUserSelected];
    
    [self searchPhoneBook:@""];
    
}

- (void)searchPhoneBook:(NSString *)searchWords{
    
    searchWords = [searchWords stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.numberCell = 10;
    self.stopLoadMore = NO;
    self.loadMore = NO;
    
    [self.arrayContact  removeAllObjects];
    [self.arrayCanuUser  removeAllObjects];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    
    NSMutableArray *arrayAllContactCanuUser = [[NSMutableArray alloc] initWithArray:appdelegate.arrayContactCanuUser];
    NSMutableArray *arrayAllContact = [[NSMutableArray alloc] initWithArray:appdelegate.arrayContact];
    
    if ([searchWords mk_isEmpty] || !searchWords) {
        
        self.arrayCanuUser = arrayAllContactCanuUser;
        self.arrayContact = arrayAllContact;
        
    } else {
        
        for (int i = 0; i < [arrayAllContact count]; i++) {
            Contact *contact = [arrayAllContact objectAtIndex:i];
            
            if ([contact.fullName rangeOfString:[searchWords lowercaseString]].location != NSNotFound) {
                [self.arrayContact addObject:contact];
            }
            
        }
        
        for (int i = 0; i < [arrayAllContactCanuUser count]; i++) {
            
            User *user = [arrayAllContactCanuUser objectAtIndex:i];
            
            NSString *name = [NSString stringWithFormat:@"%@%@%@",[user.firstName lowercaseString], [user.lastName lowercaseString],[user.userName lowercaseString]];
            
            if ([name rangeOfString:[searchWords lowercaseString]].location != NSNotFound) {
                [self.arrayCanuUser addObject:user];
            }
            
        }
        
    }
    
    [self showUser];
    
}

@end
