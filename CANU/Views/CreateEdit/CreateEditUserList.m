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
#import "AppDelegate.h"
#import "UICanuContactCell.h"

@interface CreateEditUserList () <UICanuContactCellDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *arrayContact;
@property (strong, nonatomic) NSMutableArray *arrayCanuUser;
@property (strong, nonatomic) NSMutableArray *arrayCellCanuUser;

@end

@implementation CreateEditUserList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.maxHeight = [[UIScreen mainScreen] bounds].size.height - 216 - 5 - 47 - 5;
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = UIColorFromRGB(0xe9eeee);
        
        self.arrayCellCanuUser = [[NSMutableArray alloc]init];
        self.arrayAllUserSelected = [[NSMutableArray alloc]init];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, _maxHeight)];
        [self addSubview:_scrollView];
        
        UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 6)];
        shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        [self addSubview:shadowDescription];
        
        UIImageView *shadowDescriptionReverse = [[UIImageView alloc]initWithFrame:CGRectMake(0, _maxHeight - 6, 320, 6)];
        shadowDescriptionReverse.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        shadowDescriptionReverse.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:shadowDescriptionReverse];
        
        NSError *error = [PhoneBook checkPhoneBookAccess];
        
        if (!error) {
            [NSThread detachNewThreadSelector:@selector(checkPhoneBook) toTarget:self withObject:nil];
        } else {
            
            self.canuError = error.code;
            
            if (error.code == CANUErrorPhoneBookRestricted) {
                self.maxHeight = 10;
                self.alpha = 0;
            }
        }
        
    }
    return self;
}

#pragma mark - Public

/**
 *  Phone book is now available
 */
-(void)phoneBookIsAvailable{
    
    self.canuError = CANUErrorNoError;
    
    self.maxHeight = [[UIScreen mainScreen] bounds].size.height - 216 - 5 - 47 - 5;
    
    [NSThread detachNewThreadSelector:@selector(checkPhoneBook) toTarget:self withObject:nil];
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
    
//    [self searchPhoneBook:@""];
    
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
    
//    [self searchPhoneBook:@""];
    
}

#pragma mark - Private

- (void)checkPhoneBook{
    
    [PhoneBook contactPhoneBookWithBlock:^(NSMutableArray *arrayContact, NSError *error) {
        
        if (error) {
            
        } else {
            
            self.arrayContact = arrayContact;
            
            NSMutableArray *phoneNumberClean = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < [arrayContact count]; i++) {
                
                Contact *contact = [arrayContact objectAtIndex:i];
                [phoneNumberClean addObject:contact.convertNumber];
                
            }
            
            if ([phoneNumberClean count] != 0) {
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                
                [appDelegate.user checkPhoneBook:phoneNumberClean WithBlock:^(NSMutableArray *arrayCANUUser, NSError *error) {
                    
                    self.arrayCanuUser = arrayCANUUser;
                    
                    if (error) {
                        
                    } else {
                        [self showUser];
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
    
    int row = 0;
    
    for (int i = 0; i < [_arrayCanuUser count]; i++) {
        
        User *user = [_arrayCanuUser objectAtIndex:i];
        
        Contact *contact = nil;
        
        for (int y = 0; y < [_arrayContact count]; y ++) {
            
            Contact *contactData = [_arrayContact objectAtIndex:y];
            
            if ([contactData.convertNumber isEqualToString:user.phoneNumber]) {
                contact = contactData;
            }
            
        }
        
        UICanuContactCell *cellContact = [[UICanuContactCell alloc]initWithFrame:CGRectMake(10, 10 + row * (47 + 10), 300, 47) WithContact:contact AndUser:user];
        cellContact.delegate = self;
        [self.scrollView addSubview:cellContact];
        [self.arrayCellCanuUser addObject:cellContact];
        
        row++;
        
    }
    
    
    
    for (int i = 0; i < [_arrayContact count]; i++) {
        
        Contact *contact = [_arrayContact objectAtIndex:i];
        
        User *user = nil;
        
        for (int y = 0; y < [_arrayCanuUser count]; y ++) {
            
            User *userData = [_arrayCanuUser objectAtIndex:y];
            
            if ([userData.phoneNumber isEqualToString:contact.convertNumber]) {
                user = userData;
            }
            
        }
        
        if (!user) {
            UICanuContactCell *cellContact = [[UICanuContactCell alloc]initWithFrame:CGRectMake(10, 10 + row * (47 + 10), 300, 47) WithContact:contact AndUser:nil];
            cellContact.delegate = self;
            [self.scrollView addSubview:cellContact];
            [self.arrayCellCanuUser addObject:cellContact];
            row++;
        }
        
    }
    
    self.scrollView.contentSize = CGSizeMake(320, row * ( 47 + 10) + 10);
    
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
    
    for (int i = 0; i < [_arrayCellCanuUser count]; i++) {
        
        UICanuContactCell *cell = [_arrayCellCanuUser objectAtIndex:i];
        [cell removeFromSuperview];
    }
    
    if ([searchWords mk_isEmpty] || !searchWords) {
        
        int i = 0;
        
        for (i = 0; i < [_arrayCellCanuUser count]; i++) {
            
            UICanuContactCell *cell = [_arrayCellCanuUser objectAtIndex:i];
            cell.frame = CGRectMake(10, 10 + i * (47 + 10), 300, 47);
            [self.scrollView addSubview:cell];
            
        }
        
        self.scrollView.contentSize = CGSizeMake(320, i * ( 47 + 10) + 10);
        
    } else {
        
        int row = 0;
        
        for (int i = 0; i < [_arrayCellCanuUser count]; i++) {
            
            UICanuContactCell *cell = [_arrayCellCanuUser objectAtIndex:i];
            
            NSString *name;
            
            if (cell.user) {
                name = [NSString stringWithFormat:@"%@ %@ %@",[cell.user.firstName lowercaseString], [cell.user.lastName lowercaseString],[cell.user.userName lowercaseString]];
            } else {
                name = [cell.contact.fullName lowercaseString];
            }
            
            if ([name rangeOfString:[searchWords lowercaseString]].location != NSNotFound) {
                cell.frame = CGRectMake(10, 10 + row * (47 + 10), 300, 47);
                [self.scrollView addSubview:cell];
                row++;
            }
            
        }
        
        self.scrollView.contentSize = CGSizeMake(320, row * ( 47 + 10) + 10);
        
    }
    
}

@end
