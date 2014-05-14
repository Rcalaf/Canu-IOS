//
//  InvitOthersViewController.m
//  CANU
//
//  Created by Vivien Cormier on 17/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "InvitOthersViewController.h"
#import "Activity.h"
#import "UICanuTextFieldInvit.h"
#import "CreateEditUserList.h"
#import "UICanuButtonCancel.h"
#import "Contact.h"
#import "MessageGhostUser.h"
#import "UICanuButton.h"
#import "ErrorManager.h"
#import "PhoneBook.h"
#import "UserManager.h"

@interface InvitOthersViewController () <UICanuTextFieldInvitDelegate,UITextFieldDelegate,CreateEditUserListDelegate,MessageGhostUserDelegate>

@property (strong, nonatomic) NSMutableArray *invits;
@property (strong, nonatomic) Activity *activity;
@property (strong, nonatomic) UICanuButtonCancel *cancelInvit;
@property (strong, nonatomic) UIView *backgroundUserList;
@property (strong, nonatomic) UICanuTextFieldInvit *invitInput;
@property (strong, nonatomic) CreateEditUserList *userList;
@property (strong, nonatomic) MessageGhostUser *messageGhostUser;
@property (strong, nonatomic) UICanuButton *synContact;
@property (nonatomic) BOOL ghostUser;

@end

@implementation InvitOthersViewController

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame andActivity:(Activity *)activity andInvits:(NSMutableArray *)invits{
    self = [super init];
    if (self) {
        self.invits = invits;
        self.activity = activity;
        self.view.frame = frame;
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userList = [[CreateEditUserList alloc]initWithFrame:CGRectMake(0, 10 + 45, 320, self.view.frame.size.height - 10 + 45 + 10)];
    self.userList.delegate = self;
    self.userList.minHeigt = [[UIScreen mainScreen] bounds].size.height - 10 - 45 - 45;
    self.userList.peoplesAlreadySelected = self.invits;
    self.userList.forceLocalCell = !self.activity.privacyLocation;
    self.userList.disableLocalCell = NO;
//    if (self.activity.user.userId != [UserManager sharedUserManager].currentUser.userId) {
//        self.userList.disableLocalCell = YES;
//    }
    [self.view addSubview:_userList];
    
    // If Phone Book isn't allowed or not determined
    if (self.userList.canuError == CANUErrorPhoneBookNotDetermined || self.userList.canuError == CANUErrorPhoneBookRestricted) {
        
        self.userList.alpha = 0;
        self.userList.userInteractionEnabled = NO;
        
        self.synContact = [[UICanuButton alloc]initWithFrame:CGRectMake(30, 10 + 45 + 20, 260, 37) forStyle:UICanuButtonStyleNormal];
        [self.synContact setTitle:NSLocalizedString(@"Sync contacts", nil) forState:UIControlStateNormal];
        [self.synContact addTarget:self action:@selector(syncUserContact) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_synContact];
        
    }
    
    UIView *wrapperInput = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 45)];
    [self.view addSubview:wrapperInput];
    
    self.backgroundUserList = [[UIView alloc]initWithFrame:CGRectMake(-10, -10, 320, 65)];
    self.backgroundUserList.backgroundColor = backgroundColorView;
    self.backgroundUserList.alpha = 1;
    [wrapperInput addSubview:_backgroundUserList];
    
    UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, _backgroundUserList.frame.size.height, 320, 6)];
    shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
    [self.backgroundUserList addSubview:shadowDescription];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 49)];
    background.image = [UIImage imageNamed:@"F_location_background_selected"];
    [wrapperInput addSubview:background];
    
    self.invitInput = [[UICanuTextFieldInvit alloc]initWithFrame:CGRectMake(1, 1, 240, 43)];
    self.invitInput.placeholder = NSLocalizedString(@"Search for a companion", nil);
    self.invitInput.delegate = self;
    self.invitInput.delegateFieldInvit = self;
    self.invitInput.returnKeyType = UIReturnKeySearch;
    [wrapperInput addSubview:_invitInput];
    
    self.cancelInvit = [[UICanuButtonCancel alloc]initWithFrame:CGRectMake(300, 5, 0, 47)];
    [self.cancelInvit setTitle:NSLocalizedString(@"Ok", nil) forState:UIControlStateNormal];
    [self.cancelInvit addTarget:self action:@selector(cancelInvitUser) forControlEvents:UIControlEventTouchDown];
    [self.cancelInvit detectSize];
    self.cancelInvit.alpha = 0;
    [wrapperInput addSubview:_cancelInvit];
    
    [self.userList lauchView];
    
}

#pragma mark Public

- (void)addPeoples{
    
    NSMutableArray *guests = [self createArrayUserInvited];
    
    if (self.ghostUser) {
        
        self.messageGhostUser = [[MessageGhostUser alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) andArray:self.userList.arrayAllUserSelected andParentViewcontroller:self.parentViewController withActivity:self.activity];
        self.messageGhostUser.delegate = self;
        self.messageGhostUser.forCreateActivity = NO;
        [self.parentViewController.view addSubview:self.messageGhostUser];
        
    } else {
        __weak typeof(self) weakSelf = self;
        
        [self.activity addPeopleActivityWithGuests:guests Block:^(NSError *error) {
            [weakSelf.delegate isDone];
        }];
        
    }
}

#pragma mark Private

- (void)cancelInvitUser{
    
    self.invitInput.text = @"";
    [self.userList searchPhoneBook:@""];
    [self.invitInput resignFirstResponder];
    self.invitInput.activeDeleteUser = NO;
    [UIView animateWithDuration:0.4 animations:^{
        self.cancelInvit.alpha = 0;
    } completion:nil];
    
}

- (NSMutableArray *)createArrayUserInvited{
    
    self.ghostUser = NO;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [self.userList.arrayAllUserSelected count]; i++) {
        
        if ([[self.userList.arrayAllUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
            Contact *contactData = [self.userList.arrayAllUserSelected objectAtIndex:i];
            [array addObject:contactData.convertNumber];
            self.ghostUser = YES;
        } else if ([[self.userList.arrayAllUserSelected objectAtIndex:i] isKindOfClass:[User class]]) {
            User *userData = [self.userList.arrayAllUserSelected objectAtIndex:i];
            [array addObject:userData.phoneNumber];
        }
        
    }
    
    return array;
    
}

- (void)syncUserContact{
    
    if (self.userList.canuError == CANUErrorPhoneBookRestricted) {
        [[ErrorManager sharedErrorManager] visualAlertFor:CANUErrorPhoneBookRestricted];
    } else if (self.userList.canuError == CANUErrorPhoneBookNotDetermined) {
        [PhoneBook  requestPhoneBookAccessBlock:^(NSError *error) {
            if (!error) {
                self.userList.userInteractionEnabled = YES;
                [self.synContact removeFromSuperview];
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.userList.alpha = 1;
                    self.userList.alpha = 1;
                } completion:^(BOOL finished) {
                    [self.userList phoneBookIsAvailable];
                }];
                
            } else {
                self.userList.canuError = error.code;
                
                if (_userList.canuError == CANUErrorPhoneBookRestricted) {
                    [[ErrorManager sharedErrorManager] visualAlertFor:CANUErrorPhoneBookRestricted];
                }
                
            }
        }];
    }
    
}

#pragma mark MessageGhostUserDelegate

- (void)messageGhostUserWillDisappearAfterSucess{
    
    __weak typeof(self) weakSelf = self;
    
    [self.activity addPeopleActivityWithGuests:[self createArrayUserInvited] Block:^(NSError *error) {
        [weakSelf.delegate isDone];
        [weakSelf.messageGhostUser removeFromSuperview];
        weakSelf.messageGhostUser = nil;
    }];
    
}

- (void)messageGhostUserWillDisappearAfterFail{
    [self.messageGhostUser removeFromSuperview];
    self.messageGhostUser = nil;
}

#pragma mark UICanuTextFieldInvitDelegate

- (void)inputFieldInvitIsEmpty{
    [self.userList searchPhoneBook:@""];
}

- (void)deleteLastUser:(User *)user{
    [self.userList updateAndDeleteUser:user];
}

- (void)deleteLastContact:(Contact *)contact{
    [self.userList updateAndDeleteContact:contact];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4 animations:^{
        self.cancelInvit.alpha = 1;
    } completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _invitInput && ([_invitInput.text isEqualToString:@""] || [_invitInput.text isEqualToString:@" "])) {
        [self.invitInput resignFirstResponder];
        self.invitInput.activeDeleteUser = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.cancelInvit.alpha = 0;
        } completion:nil];
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length != 0) {
        self.invitInput.activeReset = YES;
        if ([newString isEqualToString:@" "] && [self.userList.arrayAllUserSelected count] != 0) {
            [self.invitInput touchDelete];
            self.invitInput.activeDeleteUser = YES;
            [self.userList searchPhoneBook:@""];
            return NO;
        } else {
            self.invitInput.activeDeleteUser = NO;
        }
    } else {
        self.invitInput.activeReset = NO;
        if ([self.userList.arrayAllUserSelected count] != 0) {
            self.invitInput.activeDeleteUser = YES;
            [self.invitInput touchDelete];
            return NO;
        } else {
            self.invitInput.activeDeleteUser = NO;
        }
    }
    
    [self.userList searchPhoneBook:newString];
    
    return YES;
    
}

#pragma mark CreateEditUserListDelegate

-(void)phoneBookIsLoad{
    
    self.userList.scrollView.scrollEnabled = YES;
    
    [self.userList animateToMinHeight];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.userList.alpha = 1;
    } completion:^(BOOL finished) {}];
    
}

- (void)hiddenKeyboardUserList{
    [self.invitInput resignFirstResponder];
}

- (void)changeUserSelected:(NSMutableArray *)arrayAllUserSelected{
    [self.invitInput updateUserSelected:arrayAllUserSelected];
}

@end
