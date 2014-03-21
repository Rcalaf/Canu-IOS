//
//  CreateEditActivityViewController.m
//  CANU
//
//  Created by Vivien Cormier on 06/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "CreateEditActivityViewController.h"

#import "Activity.h"

#import "UICanuTextField.h"
#import "UICanuTextFieldLocation.h"
#import "UICanuTextFieldInvit.h"
#import "UICanuTextFieldReset.h"
#import "UICanuButtonSelect.h"
#import "UICanuTimePicker.h"
#import "UICanuLenghtPicker.h"
#import "CreateEditUserList.h"
#import "UICanuCalendarPicker.h"
#import "UICanuSearchLocation.h"
#import "AppDelegate.h"
#import "Location.h"
#import "SearchLocationMapViewController.h"
#import "UICanuButtonCancel.h"
#import "UICanuButtonSignBottomBar.h" // TO Delete
#import "UICanuButton.h"
#import "UICanuBottomBar.h"
#import "Contact.h"
#import "User.h"
#import "MessageGhostUser.h"
#import "AlertViewController.h"
#import "PhoneBook.h"
#import "UserManager.h"
#import "UIImageView+AFNetworking.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface CreateEditActivityViewController () <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,UICanuCalendarPickerDelegate,UICanuSearchLocationDelegate,SearchLocationMapViewControllerDelegate,CreateEditUserListDelegate,MessageGhostUserDelegate,UICanuTextFieldInvitDelegate>

@property (nonatomic) BOOL descriptionIsOpen;
@property (nonatomic) BOOL activityIsOpen;
@property (nonatomic) BOOL calendarIsOpen;
@property (nonatomic) BOOL searchLocationIsOpen;
@property (nonatomic) BOOL userListIsOpen;
@property (nonatomic) BOOL mapLocationIsOpen;
@property (nonatomic) BOOL invitInputIsStick;
@property (nonatomic) BOOL isNewActivity;
@property (nonatomic) BOOL ghostUser;
@property (nonatomic) int previousScrollOffsetWrapper;
@property (strong, nonatomic) NSTimer *timerSearch;
@property (strong, nonatomic) MKMapItem *currentLocation;
@property (strong, nonatomic) UIImageView *imgOpenCalendar;
@property (strong, nonatomic) UIImageView *wrapperDescription;
@property (strong, nonatomic) UIImageView *locationBackground;
@property (strong, nonatomic) UIImageView *locationBackgroundSelected;
@property (strong, nonatomic) UIView *wrapperInvitInput;
@property (strong, nonatomic) UIView *wrapperActivity;
@property (strong, nonatomic) UIView *wrapperButtonDaySelected;
@property (strong, nonatomic) UIView *wrapperTimeLengthPicker;
@property (strong, nonatomic) UIView *wrapperLocation;
@property (strong, nonatomic) UIView *backgroundDark;
@property (strong, nonatomic) UILabel *titleInvit;
@property (strong, nonatomic) UILabel *labelSyncContact;
@property (strong, nonatomic) UIButton *openMap;
@property (strong, nonatomic) UIButton *openCalendar;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *synContact;
@property (strong, nonatomic) UIScrollView *wrapper;
@property (strong, nonatomic) UITextView *descriptionInput;
@property (strong, nonatomic) UILabel *counterLength;
@property (strong, nonatomic) UICanuBottomBar *bottomBar;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (strong, nonatomic) Activity *createActivity;
@property (strong, nonatomic) Activity *editActivity;
@property (strong, nonatomic) Location *locationSelected;
@property (nonatomic) CANUCreateActivity canuCreateActivity;
@property (strong, nonatomic) CreateEditUserList *userList;
@property (strong, nonatomic) UICanuTextFieldReset *titleInput;
@property (strong, nonatomic) UICanuTextFieldInvit *invitInput;
@property (strong, nonatomic) UICanuTextFieldLocation *locationInput;
@property (strong, nonatomic) UICanuButtonSelect *todayBtnSelect;
@property (strong, nonatomic) UICanuButtonSelect *tomorrowBtnSelect;
@property (strong, nonatomic) UICanuButtonCancel *cancelLocation;
@property (strong, nonatomic) UICanuButtonCancel *cancelInvit;
@property (strong, nonatomic) UICanuTimePicker *timePicker;
@property (strong, nonatomic) UICanuLenghtPicker *lenghtPicker;
@property (strong, nonatomic) UICanuCalendarPicker *calendar;
@property (strong, nonatomic) UICanuSearchLocation *searchLocation;
@property (strong, nonatomic) SearchLocationMapViewController *mapLocation;
@property (strong, nonatomic) MessageGhostUser *messageGhostUser;
@property (strong, nonatomic) UICanuButton *buttonAction;

@end

@implementation CreateEditActivityViewController

@synthesize locationManager = _locationManager;

#pragma mark - Lifecycle

- (void)loadView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    view.backgroundColor = backgroundColorView;
    self.view = view;
    
}

/**
 *  Create activity (local or tribe)
 *
 *  @param activity
 *
 *  @return
 */
- (id)initForCreate:(CANUCreateActivity)canuCreateActivity{
    
    self = [super init];
    if (self) {
        
        self.canuCreateActivity = canuCreateActivity;
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity New"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Create" label:@"Open" value:nil] build]];
        
    }
    return self;
}

/**
 *  Edit a activity
 *
 *  @param activity
 *
 *  @return
 */
- (id)initForEdit:(Activity *)activity{
    
    self = [super init];
    if (self) {
        
        self.editActivity = activity;
        
        if (self.editActivity.privacyLocation) {
            self.canuCreateActivity = CANUCreateActivityTribes;
        } else {
            self.canuCreateActivity = CANUCreateActivityLocal;
        }
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Edit"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];;
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Edit" label:@"Open" value:nil] build]];
        
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
	
    // Init
    
    self.descriptionIsOpen = NO;
    self.calendarIsOpen = NO;
    self.searchLocationIsOpen = NO;
    self.userListIsOpen = NO;
    self.mapLocationIsOpen = NO;
    self.ghostUser = NO;
    self.invitInputIsStick = NO;
    self.activityIsOpen = NO;
    
    self.wrapper = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, 320, self.view.frame.size.height - 57)];
    self.wrapper.alpha = 0;
    self.wrapper.delegate = self;
    [self.view addSubview:_wrapper];
    
    // Wrapper Activity
    
    self.wrapperActivity = [self initializationWrapperActivity];
    [self.wrapper addSubview:_wrapperActivity];
    
    // Date
    
    self.wrapperButtonDaySelected = [self initializationWrapperButtonDaySelected];
    [self.wrapper addSubview:_wrapperButtonDaySelected];
    
    // Time
    
    self.wrapperTimeLengthPicker = [self initializationWrapperTimeLengthPicker];
    [self.wrapper addSubview:_wrapperTimeLengthPicker];
    
    // Location
    
    self.wrapperLocation = [self initializationWrapperLocation];
    [self.wrapper addSubview:_wrapperLocation];
    
    // Invit
    
    if (!_editActivity) {
        self.titleInvit = [[UILabel alloc]initWithFrame:CGRectMake(10, _wrapperLocation.frame.origin.y + _wrapperLocation.frame.size.height + 51, 300, 18)];
        self.titleInvit.backgroundColor = backgroundColorView;
        self.titleInvit.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        self.titleInvit.text = NSLocalizedString(@"Who is invited?", nil);
        self.titleInvit.textColor = UIColorFromRGB(0x2b4b58);
        self.titleInvit.textAlignment = NSTextAlignmentCenter;
        [self.wrapper addSubview:_titleInvit];
        
        self.userList = [[CreateEditUserList alloc]initWithFrame:CGRectMake(0, _titleInvit.frame.origin.y + _titleInvit.frame.size.height + 57, 320, 10)];
        self.userList.delegate = self;
        [self.wrapper addSubview:_userList];
        
        self.wrapperInvitInput = [[UIView alloc]initWithFrame:CGRectMake(0, _titleInvit.frame.origin.y + _titleInvit.frame.size.height, 320, 47 + 10)];
        self.wrapperInvitInput.backgroundColor = backgroundColorView;
        [self.wrapper addSubview:_wrapperInvitInput];
        
        self.invitInput = [[UICanuTextFieldInvit alloc]initWithFrame:CGRectMake(10, 5, 300, 47)];
        self.invitInput.placeholder = NSLocalizedString(@"Who is invited?", nil);
        self.invitInput.delegate = self;
        self.invitInput.delegateFieldInvit = self;
        self.invitInput.returnKeyType = UIReturnKeySearch;
        [self.wrapperInvitInput addSubview:_invitInput];
        
        self.cancelInvit = [[UICanuButtonCancel alloc]initWithFrame:CGRectMake(320 - 10, 5, 0, 47)];
        [self.cancelInvit setTitle:NSLocalizedString(@"Ok", nil) forState:UIControlStateNormal];
        [self.cancelInvit addTarget:self action:@selector(cancelInvitUser) forControlEvents:UIControlEventTouchDown];
        [self.cancelInvit detectSize];
        self.cancelInvit.titleLabel.alpha = 0;
        [self.wrapperInvitInput addSubview:_cancelInvit];
        
        // If Phone Book isn't allowed or not determined
        if (self.userList.canuError == CANUErrorPhoneBookNotDetermined || self.userList.canuError == CANUErrorPhoneBookRestricted) {
            
            self.invitInput.alpha = 0;
            self.invitInput.userInteractionEnabled = NO;
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Sync contacts", nil)];
            [attributeString addAttribute:NSUnderlineStyleAttributeName
                                    value:[NSNumber numberWithInt:1]
                                    range:(NSRange){0,[attributeString length]}];
            
            self.labelSyncContact = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 37)];
            self.labelSyncContact.attributedText = attributeString;
            self.labelSyncContact.textAlignment = NSTextAlignmentCenter;
            self.labelSyncContact.textColor = UIColorFromRGB(0x2b4b58);
            self.labelSyncContact.font = [UIFont fontWithName:@"Lato-Bold" size:14];
            
            self.synContact = [[UIButton alloc]initWithFrame:CGRectMake(30, _wrapperInvitInput.frame.origin.y + 15, 260, 37)];
            [self.synContact addSubview:_labelSyncContact];
            [self.synContact addTarget:self action:@selector(syncUserContact) forControlEvents:UIControlEventTouchDown];
            [self.wrapper addSubview:_synContact];
            
        } else {
            UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, _wrapperInvitInput.frame.size.height, 320, 6)];
            shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
            [self.wrapperInvitInput addSubview:shadowDescription];
        }
        
    }
    
    // Bottom bar
    
    self.bottomBar = [[UICanuBottomBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 57)];
    [self.view addSubview:_bottomBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [_bottomBar addSubview:backButton];
    
    self.buttonAction = [[UICanuButton alloc]initWithFrame:CGRectMake(57 + 10, 10.0, (self.view.frame.size.width - (57 + 10)*2), 37.0) forStyle:UICanuButtonStyleNormal];
    if (!_editActivity) {
        [self.buttonAction setTitle:NSLocalizedString(@"Send activity", nil) forState:UIControlStateNormal];
    } else {
        [self.buttonAction setTitle:NSLocalizedString(@"SAVE", nil) forState:UIControlStateNormal];
        self.buttonAction.frame = CGRectMake(194.0f, 10.0f, 116.0f, 37);
    }
    [self.buttonAction addTarget:self action:@selector(createEditForm) forControlEvents:UIControlEventTouchDown];
    [self.bottomBar addSubview:_buttonAction];
    
    if (_editActivity) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(67.0f, 10.0f, 116.0f, 36.0f);
        [self.deleteButton setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteActivity) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:_deleteButton];
    }
    
    // Wrapper
    if (!_editActivity) {
        self.wrapper.contentSize = CGSizeMake(320, _userList.frame.origin.y + _userList.frame.size.height);
    } else {
        self.wrapper.contentSize = CGSizeMake(320, _cancelLocation.frame.origin.y + _cancelLocation.frame.size.height + 10);
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.alpha = 1;
        self.wrapper.frame = CGRectMake(0, 0, 320, _wrapper.frame.size.height);
        self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 57, self.view.frame.size.width, 57);
    }];
    
    // Description
    
    // Calendar
    
    // Search Location
    
    self.searchLocation = [[UICanuSearchLocation alloc]initWithFrame:CGRectMake(0, _wrapperLocation.frame.origin.y + _wrapperLocation.frame.size.height + 20, 320, 0)];
    self.searchLocation.delegate = self;
    [self.wrapper addSubview:_searchLocation];
    
    // Current Location
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.currentLocation.latitude == 0 && appDelegate.currentLocation.longitude == 0 ) {
        [self.locationManager startUpdatingLocation];
    } else {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation: [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.latitude  longitude:appDelegate.currentLocation.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Provide Directions",nil)
                                            message:@"The map server is not available."
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                
                self.searchLocation.searchLocation = @"";
                
            } else {
                
                self.currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]]];
                
                self.searchLocation.currentLocation = _currentLocation;
                
                if (_editActivity) {
                    [self.searchLocation forceLocationTo:[[Location alloc]initLocationWithMKMapItem:_editActivity.location]];
                }
                
            }
            
            // Active Map or not
            
        }];
    }
    
    if (self.editActivity) {
        
        self.titleInput.text = _editActivity.title;
        
        self.descriptionInput.text = _editActivity.description;
        
        [self.timePicker isToday:NO];
        
        [self.timePicker changeTo:_editActivity.start];
        
        if ([_editActivity.start mk_isToday]) {
            [self buttonSelectManager:_todayBtnSelect];
        } else if ([_editActivity.start mk_isTomorrow]) {
            [self buttonSelectManager:_tomorrowBtnSelect];
        } else {
            [self buttonSelectManager:_openCalendar];
            [self.calendar changeTo:_editActivity.start];
        }
        
        [self.lenghtPicker changeTo:_editActivity.length];
        
    }
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= _titleInvit.frame.origin.y + _titleInvit.frame.size.height) {
        self.wrapperInvitInput.frame = CGRectMake(0, scrollView.contentOffset.y, _wrapperInvitInput.frame.size.width, _wrapperInvitInput.frame.size.height);
    }else {
        self.wrapperInvitInput.frame = CGRectMake(0, _titleInvit.frame.origin.y + _titleInvit.frame.size.height, _wrapperInvitInput.frame.size.width, _wrapperInvitInput.frame.size.height);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _titleInput) {
        [self.titleInput resignFirstResponder];
        [self openActivity];
    }else if (textField == _locationInput && [_locationInput.text isEqualToString:@""]) {
        [self.locationInput resignFirstResponder];
    }else if (textField == _invitInput && ([_invitInput.text isEqualToString:@""] || [_invitInput.text isEqualToString:@" "])) {
        [self.invitInput resignFirstResponder];
    }
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSNumber *position = [NSNumber numberWithInt:textField.frame.origin.y - 5];
    
    if (textField == _locationInput) {
        if (!_searchLocationIsOpen) {
            
            if (!self.locationInput.activeSearch) {
                self.locationInput.text = @"";
                self.locationInput.activeSearch = YES;
            }
            
            [self openSearchLocationView];
        }
    }
    
    if (textField == _invitInput) {
        
        position = [NSNumber numberWithInt:_titleInvit.frame.origin.y + _titleInvit.frame.size.height];
        
        [self openUserListView];
    }
    
    if (textField != _titleInput) {
        if (textField != _locationInput) {
            [self performSelector:@selector(changePositionWrapper:) withObject:position afterDelay:0.4];
        }
    } else {
        if (!_activityIsOpen) {
            [self openActivity];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _locationInput) {
        
        if (self.locationInput.activeSearch) {
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if (newString.length != 0) {
                self.locationInput.activeReset = YES;
            } else {
                self.locationInput.activeReset = NO;
            }
            
        }
        
        self.locationInput.activeSearch = YES;
        
        [self.timerSearch invalidate];
        self.timerSearch = nil;
        
        self.timerSearch = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector:@selector(startSearchLocation) userInfo: nil repeats:NO];
        
    } else if (textField == _invitInput) {
        
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
        
    } else if (textField == _titleInput) {
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (newString.length > 20) {
            return NO;
        }
        
        if (newString.length != 0) {
            self.titleInput.activeReset = YES;
        } else {
            self.titleInput.activeReset = NO;
        }
        
    }
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _locationInput) {
        if (_searchLocationIsOpen) {
            [self openSearchLocationView];
            if (self.locationSelected != nil) {
                self.locationInput.activeSearch = NO;
                self.locationInput.text = self.locationSelected.name;
            }
            
        }
    }
    
    if (textField == _invitInput) {
        if (_userListIsOpen) {
            [self openUserListView];
        }
        self.invitInput.activeDeleteUser = NO;
    }
    
}

#pragma mark - UICanuTextFieldInvitDelegate

- (void)inputFieldInvitIsEmpty{
    [self.userList searchPhoneBook:@""];
}

- (void)deleteLastUser:(User *)user{
    [self.userList updateAndDeleteUser:user];
}

- (void)deleteLastContact:(Contact *)contact{
    [self.userList updateAndDeleteContact:contact];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"textViewDidBeginEditing");
    if ([textView.text isEqualToString:NSLocalizedString(@"Add details (Optional)", nil)]) {
        textView.text = @"";
        textView.textColor = UIColorFromRGB(0x2b4b58);
        self.counterLength.text = @"140";
    }
    [textView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"Add details (Optional)", nil);
        textView.textColor = UIColorFromRGB(0xabb3b7);
        self.counterLength.text = @"";
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"shouldChangeTextInRange");
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self openActivity];
    }
    
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    int numberOfLine = (int)textView.contentSize.height / textView.font.lineHeight;
    
    if (_activityIsOpen) {
        self.wrapperDescription.frame = CGRectMake(-2, 99, 304, 23 + 16 * numberOfLine);
        self.wrapperActivity.frame = CGRectMake(_wrapperActivity.frame.origin.x, _wrapperActivity.frame.origin.y, _wrapperActivity.frame.size.width, 100 + 23 + 16 * numberOfLine);
        self.counterLength.frame = CGRectMake(302 - 30, _wrapperDescription.frame.size.height - 2 - 20, 20, 10);
        self.descriptionInput.frame = CGRectMake(10, 10, 280, 16 * numberOfLine);
    }
    
    if (newString.length > 140) {
        return NO;
    }
    
    self.counterLength.text = [NSString stringWithFormat:@"%i",140 - newString.length];
    
    return YES;
}

#pragma mark - UICanuCalendarPickerDelegate

-(void)calendarTouchTodayOrTomorrowDay:(NSDate *)date{
    
    if ([date mk_isToday]) {
        self.todayBtnSelect.selected = YES;
        self.tomorrowBtnSelect.selected = NO;
    } else if ([date mk_isTomorrow]) {
        self.todayBtnSelect.selected = NO;
        self.tomorrowBtnSelect.selected = YES;
    }
    
}

- (void)calendarTouchAnotherDay{
    self.todayBtnSelect.selected = NO;
    self.tomorrowBtnSelect.selected = NO;
}

#pragma mark - UICanuSearchLocationDelegate

- (void)locationIsSelected:(Location *)location{
    
    if (_mapLocation) {
        [self.mapLocation willMoveToParentViewController:nil];
        [self.mapLocation.view removeFromSuperview];
        [self.mapLocation removeFromParentViewController];
        self.mapLocation = nil;
    }
    
    self.locationSelected = location;
    
    if (_searchLocationIsOpen) {
        [self openSearchLocationView];
    }
    
    [self.locationInput resignFirstResponder];
    
    self.locationInput.activeSearch = NO;
    self.locationInput.text = location.name;
    
}

#pragma mark - SearchLocationMapViewControllerDelegate

- (void)locationIsSelectedByMap:(Location *)location{
    
    [self.searchLocation reset];
    
    self.locationSelected = location;
    
    if (_searchLocationIsOpen) {
        [self openSearchLocationView];
    }
    
    [self.locationInput resignFirstResponder];
    
    self.locationInput.activeSearch = NO;
    self.locationInput.text = location.name;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.mapLocation.view.frame = CGRectMake(320, 0, 320, _mapLocation.view.frame.size.height);
        self.wrapper.frame = CGRectMake(0, _wrapper.frame.origin.y, _wrapper.frame.size.width, _wrapper.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)closeTheMap{
    [UIView animateWithDuration:0.4 animations:^{
        self.mapLocation.view.frame = CGRectMake(320, 0, 320, _mapLocation.view.frame.size.height);
        self.wrapper.frame = CGRectMake(0, _wrapper.frame.origin.y, _wrapper.frame.size.width, _wrapper.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - CreateEditUserListDelegate

- (void)changeUserSelected:(NSMutableArray *)arrayAllUserSelected{
    
    [self.invitInput updateUserSelected:arrayAllUserSelected];
    
}

- (void)phoneBookIsLoad{
    
    self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y, _userList.frame.size.width, self.userList.maxHeight);
    
    self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + self.userList.maxHeight - 10);
    
}

#pragma mark - MessageGhostUserDelegate

- (void)messageGhostUserWillDisappear{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.alpha = 0;
        self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, self.view.frame.size.height, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
}

- (void)messageGhostUserWillDisappearForDeleteActivity{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.alpha = 0;
        self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, self.view.frame.size.height, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self.createActivity removeActivityWithBlock:^(NSError *error) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
    }];
    
}

#pragma mark - 


- (CLLocationManager *)locationManager{
    
    if (_locationManager) {
        return _locationManager;
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 200;
    
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BOOL isFirstTime = YES;
    
    if (appDelegate.currentLocation.latitude != 0 && appDelegate.currentLocation.longitude != 0 ) {
        isFirstTime = NO;
    }
    
    CLLocationCoordinate2D location = [[manager location] coordinate];
    
    appDelegate.currentLocation = location;
    [[[UserManager sharedUserManager] currentUser] editLatitude:location.latitude Longitude:location.longitude];
    
    [self.locationManager stopUpdatingLocation];
    
    if (isFirstTime) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation: [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.latitude  longitude:appDelegate.currentLocation.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Provide Directions",nil)
                                            message:@"The map server is not available."
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                
                self.searchLocation.searchLocation = @"";
                
            } else {
                
                self.currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]]];
                
                self.searchLocation.currentLocation = _currentLocation;
                
                if (_editActivity) {
                    [self.searchLocation forceLocationTo:[[Location alloc]initLocationWithMKMapItem:_editActivity.location]];
                }
                
            }
            
            // Active Map or not
            
        }];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    self.searchLocation.searchLocation = @"";
    
}

#pragma mark - Private

#pragma mark -- Init View

- (UIView *)initializationWrapperActivity{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 100)];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 105)];
    background.image = [UIImage imageNamed:@"F_activity_background"];
    [view addSubview:background];
    
    // Profile picture
    UIImageView *profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
    [profilePicture setImageWithURL:[[UserManager sharedUserManager] currentUser].profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    [view addSubview:profilePicture];
    
    // Stroke profile picture
    UIImageView *strokePicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    strokePicture.image = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
    [profilePicture addSubview:strokePicture];
    
    // Name
    UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(55, 18, 200, 17)];
    username.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    username.text = [[UserManager sharedUserManager] currentUser].firstName;
    username.textColor = UIColorFromRGB(0x2b4b58);
    [view addSubview:username];
    
    self.titleInput = [[UICanuTextFieldReset alloc]initWithFrame:CGRectMake(10, 57, 280, 25)];
    self.titleInput.font = [UIFont fontWithName:@"Lato-Bold" size:23];
    self.titleInput.textColor = UIColorFromRGB(0x2b4b58);
    self.titleInput.placeholder = NSLocalizedString(@"What do you want to do?", nil);
    self.titleInput.returnKeyType = UIReturnKeyDone;
    self.titleInput.leftView = nil;
    self.titleInput.delegate = self;
    [view addSubview:_titleInput];
    
    self.wrapperDescription = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 99, 304, 0)];
    self.wrapperDescription.image = [[UIImage imageNamed:@"F_activity_description"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0f];
    self.wrapperDescription.clipsToBounds = YES;
    self.wrapperDescription.userInteractionEnabled = YES;
    [view addSubview:_wrapperDescription];
    
    self.descriptionInput = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 280, 32)];
    self.descriptionInput.textColor = UIColorFromRGB(0xabb3b7);
    [self.descriptionInput setTintColor:UIColorFromRGB(0x2b4b58)];
    self.descriptionInput.text = NSLocalizedString(@"Add details (Optional)", nil);
    self.descriptionInput.backgroundColor = [UIColor clearColor];
    self.descriptionInput.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    self.descriptionInput.returnKeyType = UIReturnKeyDone;
    self.descriptionInput.delegate = self;
    [self.wrapperDescription addSubview:_descriptionInput];

    self.counterLength = [[UILabel alloc]initWithFrame:CGRectMake(302 - 30, 55 - 2 - 20, 20, 10)];
    self.counterLength.textColor = UIColorFromRGB(0xbfc9cd);
    self.counterLength.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    self.counterLength.textAlignment = NSTextAlignmentRight;
    [self.wrapperDescription addSubview:_counterLength];
    
    return view;
}

- (UIView *)initializationWrapperButtonDaySelected{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, _wrapperActivity.frame.origin.y + _wrapperActivity.frame.size.height + 5, 300, 45)];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 47)];
    background.image = [UIImage imageNamed:@"F_Button_Day_Selected"];
    [view addSubview:background];
    
    self.todayBtnSelect = [[UICanuButtonSelect alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.todayBtnSelect.textButton = NSLocalizedString(@"Today", nil);
    self.todayBtnSelect.selected = YES;
    [self.todayBtnSelect addTarget:self action:@selector(buttonSelectManager:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_todayBtnSelect];
    
    self.tomorrowBtnSelect = [[UICanuButtonSelect alloc]initWithFrame:CGRectMake(100, 0, 100, 44)];
    self.tomorrowBtnSelect.textButton = NSLocalizedString(@"Tomorrow", nil);
    [self.tomorrowBtnSelect addTarget:self action:@selector(buttonSelectManager:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:_tomorrowBtnSelect];
    
    self.imgOpenCalendar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar"];
    
    self.openCalendar = [[UIButton alloc]initWithFrame:CGRectMake(200, 0, 100, 44)];
    self.openCalendar.backgroundColor = [UIColor clearColor];
    [self.openCalendar addTarget:self action:@selector(buttonSelectManager:) forControlEvents:UIControlEventTouchDown];
    [self.openCalendar addSubview:_imgOpenCalendar];
    [view addSubview:_openCalendar];
    
    self.calendar = [[UICanuCalendarPicker alloc]initWithFrame:CGRectMake(-10, 39, 320, 0)];
    self.calendar.delegate = self;
    [view addSubview:_calendar];
    
    return view;
    
}

- (UIView *)initializationWrapperTimeLengthPicker{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, _wrapperButtonDaySelected.frame.origin.y + _wrapperButtonDaySelected.frame.size.height, 300, 114)];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, 304, 114)];
    background.image = [[UIImage imageNamed:@"F_calendar_background"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0f];
    [view addSubview:background];
    
    self.timePicker = [[UICanuTimePicker alloc]initWithFrame:CGRectMake(1, 0, 149, 114)];
    [self.timePicker isToday:YES];
    [view addSubview:_timePicker];
    
    self.lenghtPicker = [[UICanuLenghtPicker alloc]initWithFrame:CGRectMake(150, 0, 149, 114)];
    [view addSubview:_lenghtPicker];
    
    UIImageView *shadowTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 6)];
    shadowTop.image = [UIImage imageNamed:@"F_time_length_shadow"];
    [view addSubview:shadowTop];
    
    UIImageView *shadowBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 114 - 6, 300, 6)];
    shadowBottom.image = [UIImage imageNamed:@"F_time_length_shadow"];
    shadowBottom.transform = CGAffineTransformMakeRotation(M_PI);
    [view addSubview:shadowBottom];
    
    return view;
    
}

- (UIView *)initializationWrapperLocation{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, _wrapperTimeLengthPicker.frame.origin.y + _wrapperTimeLengthPicker.frame.size.height, 300, 45)];
    
    self.locationBackground = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 0, 304, 48)];
    self.locationBackground.image = [UIImage imageNamed:@"F_location_background"];
    [view addSubview:_locationBackground];
    
    self.locationBackgroundSelected = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 49)];
    self.locationBackgroundSelected.image = [UIImage imageNamed:@"F_location_background_selected"];
    self.locationBackgroundSelected.alpha = 0;
    [view addSubview:_locationBackgroundSelected];
    
    self.locationInput = [[UICanuTextFieldLocation alloc]initWithFrame:CGRectMake(1, 1, 250, 43)];
    self.locationInput.placeholder = NSLocalizedString(@"Find a place", nil);
    self.locationInput.delegate = self;
    self.locationInput.returnKeyType = UIReturnKeySearch;
    [view addSubview:_locationInput];
    
    UIImageView *imgOpenMap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 43)];
    imgOpenMap.image = [UIImage imageNamed:@"F1_open_map"];
    
    self.openMap = [[UIButton alloc]initWithFrame:CGRectMake(250, 1, 49, 43)];
    [self.openMap addTarget:self action:@selector(btnSearchWithTheMap) forControlEvents:UIControlEventTouchDown];
    self.openMap.backgroundColor = [UIColor whiteColor];
    [self.openMap addSubview:imgOpenMap];
    [view addSubview:_openMap];
    
    self.cancelLocation = [[UICanuButtonCancel alloc]initWithFrame:CGRectMake(300, 5, 0, 33)];
    [self.cancelLocation addTarget:self action:@selector(cancelSearchLocation) forControlEvents:UIControlEventTouchDown];
    [self.cancelLocation detectSize];
    self.cancelLocation.alpha = 0;
    [view addSubview:_cancelLocation];
    
    return view;
    
}

#pragma mark -- Position Wrapper

- (void)changePositionWrapper:(NSNumber *)position{
    
    [self.wrapper setContentOffset:CGPointMake(0, [position intValue]) animated:YES];
    
}

#pragma mark -- Sync Contact

- (void)syncUserContact{
    
    if (self.userList.canuError == CANUErrorPhoneBookRestricted) {
        [[ErrorManager sharedErrorManager] visualAlertFor:CANUErrorPhoneBookRestricted];
    } else if (self.userList.canuError == CANUErrorPhoneBookNotDetermined) {
        [PhoneBook  requestPhoneBookAccessBlock:^(NSError *error) {
            if (!error) {
                self.invitInput.userInteractionEnabled = YES;
                [self.synContact removeFromSuperview];
                
                UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, _wrapperInvitInput.frame.size.height, 320, 6)];
                shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
                shadowDescription.alpha = 0;
                [self.wrapperInvitInput addSubview:shadowDescription];
                
                [UIView animateWithDuration:0.4 animations:^{
                    self.invitInput.alpha = 1;
                    self.userList.alpha = 1;
                    shadowDescription.alpha = 1;
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

- (void)cancelSearchLocation{
    
    [self.locationInput resignFirstResponder];
    
}

- (void)cancelInvitUser{
    
    self.invitInput.text = @"";
    [self.userList searchPhoneBook:@""];
    [self.invitInput resignFirstResponder];
    
}

- (void)btnSearchWithTheMap{
    
    if (!_mapLocation) {
        self.mapLocation = [[SearchLocationMapViewController alloc]initWithLocation:self.locationSelected];
        self.mapLocation.delegate = self;
        [self addChildViewController:self.mapLocation];
        [self.view addSubview:self.mapLocation.view];
    }
    
    if (self.locationSelected && !self.locationInput.activeSearch) {
        [self.mapLocation searchAnnotionWithLocation:self.locationSelected];
    }
    
    [self.locationInput resignFirstResponder];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.mapLocation.view.frame = CGRectMake(0, 0, 320, _mapLocation.view.frame.size.height);
        self.wrapper.frame = CGRectMake(-320, _wrapper.frame.origin.y, _wrapper.frame.size.width, _wrapper.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)openActivity:(UIGestureRecognizer *)sender{
    UIView* view = sender.view;
    CGPoint loc = [sender locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    
    if (subview == _backgroundDark) {
        
        [self openActivity];
        
    }
    
}

- (void)openActivity{
    
    self.activityIsOpen = !_activityIsOpen;
    
    if (!_activityIsOpen) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundDark.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:75.0f/255.0f blue:88.0f/255.0f alpha:0.0f];
            self.wrapperDescription.frame = CGRectMake(-2, 99, 304, 0);
        } completion:^(BOOL finished) {
            [self.wrapperActivity removeFromSuperview];
            [self.backgroundDark removeFromSuperview];
            self.backgroundDark = nil;
            [self.wrapper addSubview:_wrapperActivity];
            self.wrapperActivity.frame = CGRectMake(_wrapperActivity.frame.origin.x, _wrapperActivity.frame.origin.y, _wrapperActivity.frame.size.width, 100);
        }];
        
    } else {
        
        self.backgroundDark = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        self.backgroundDark.backgroundColor = [UIColor colorWithRed:43/255 green:75/255 blue:88/255 alpha:0];
        [self.view addSubview:_backgroundDark];
        
        UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openActivity:)];
        [self.backgroundDark addGestureRecognizer:tapBackground];
        
        [self.wrapperActivity removeFromSuperview];
        
        [self.backgroundDark addSubview:_wrapperActivity];
        
        [self.titleInput becomeFirstResponder];
        
        int numberOfLine = (int)_descriptionInput.contentSize.height / _descriptionInput.font.lineHeight;
        self.wrapperActivity.frame = CGRectMake(_wrapperActivity.frame.origin.x, _wrapperActivity.frame.origin.y, _wrapperActivity.frame.size.width, 100 + 23 + 16 * numberOfLine);
        
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundDark.backgroundColor = [UIColor colorWithRed:43.0f/255.0f green:75.0f/255.0f blue:88.0f/255.0f alpha:0.5f];
            self.wrapperDescription.frame = CGRectMake(-2, 99, 304, 23 + 16 * numberOfLine);
        }];
    }
    
    
    
}

- (void)openCalendarViewWithReset:(BOOL)reset{
    
    self.calendarIsOpen = !_calendarIsOpen;
    
    int heightCalendar,realSize;
    
    if (_calendarIsOpen) {
        heightCalendar = 120;
        realSize = 126;
    } else {
        heightCalendar = - 120;
        realSize = - 126;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + heightCalendar);
        self.wrapperButtonDaySelected.frame = CGRectMake(_wrapperButtonDaySelected.frame.origin.x, _wrapperButtonDaySelected.frame.origin.y, _wrapperButtonDaySelected.frame.size.width, _wrapperButtonDaySelected.frame.size.height + heightCalendar);
        self.calendar.frame = CGRectMake(_calendar.frame.origin.x, _calendar.frame.origin.y, _calendar.frame.size.width, _calendar.frame.size.height + realSize);
        self.wrapperTimeLengthPicker.frame = CGRectMake(_wrapperTimeLengthPicker.frame.origin.x, _wrapperTimeLengthPicker.frame.origin.y + heightCalendar, _wrapperTimeLengthPicker.frame.size.width, _wrapperTimeLengthPicker.frame.size.height);
        self.wrapperLocation.frame = CGRectMake(_wrapperLocation.frame.origin.x, _wrapperLocation.frame.origin.y + heightCalendar, _wrapperLocation.frame.size.width, _wrapperLocation.frame.size.height);
        self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y + heightCalendar, _searchLocation.frame.size.width, _searchLocation.frame.size.height);
        self.titleInvit.frame = CGRectMake(_titleInvit.frame.origin.x, _titleInvit.frame.origin.y + heightCalendar, _titleInvit.frame.size.width, _titleInvit.frame.size.height);
        self.wrapperInvitInput.frame = CGRectMake(_wrapperInvitInput.frame.origin.x, _wrapperInvitInput.frame.origin.y + heightCalendar, _wrapperInvitInput.frame.size.width, _wrapperInvitInput.frame.size.height);
        self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y + heightCalendar, _userList.frame.size.width, _userList.frame.size.height);
        self.synContact.frame = CGRectMake(_synContact.frame.origin.x, _synContact.frame.origin.y + heightCalendar, _synContact.frame.size.width, _synContact.frame.size.height);
    } completion:^(BOOL finished) {
        if (reset) {
            [self.calendar resetCalendar];
        }
    }];
    
}

- (void)openSearchLocationView{
    
    self.searchLocationIsOpen = !_searchLocationIsOpen;
    
    int heightSearchLocation,margin,positionWrapper;
    
    if (_searchLocationIsOpen) {
        heightSearchLocation = self.searchLocation.maxHeight;
        margin = 10;
        self.wrapper.scrollEnabled = NO;
        self.previousScrollOffsetWrapper = _wrapper.contentOffset.y;
        positionWrapper = _wrapperLocation.frame.origin.y;
    } else {
        heightSearchLocation = - self.searchLocation.maxHeight;
        margin = - 10;
        self.wrapper.scrollEnabled = YES;
        positionWrapper = _previousScrollOffsetWrapper;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        if (_searchLocationIsOpen) {
            self.locationInput.frame = CGRectMake(_locationInput.frame.origin.x, _locationInput.frame.origin.y, 250, _locationInput.frame.size.height);
            self.locationBackground.alpha = 0;
            self.locationBackgroundSelected.alpha = 1;
            self.openMap.alpha = 0;
        } else {
            self.locationInput.frame = CGRectMake(_locationInput.frame.origin.x, _locationInput.frame.origin.y, 250, _locationInput.frame.size.height);
            self.locationBackground.alpha = 1;
            self.locationBackgroundSelected.alpha = 0;
            self.cancelLocation.alpha = 0;
        }
        self.wrapper.contentOffset = CGPointMake(0, positionWrapper);
        self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + heightSearchLocation);
        self.wrapperLocation.frame = CGRectMake(_wrapperLocation.frame.origin.x, _wrapperLocation.frame.origin.y + margin, _wrapperLocation.frame.size.width, _wrapperLocation.frame.size.height);
        self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y, _searchLocation.frame.size.width, _searchLocation.frame.size.height + heightSearchLocation);
        self.titleInvit.frame = CGRectMake(_titleInvit.frame.origin.x, _titleInvit.frame.origin.y + heightSearchLocation, _titleInvit.frame.size.width, _titleInvit.frame.size.height);
        self.wrapperInvitInput.frame = CGRectMake(_wrapperInvitInput.frame.origin.x, _wrapperInvitInput.frame.origin.y + heightSearchLocation, _wrapperInvitInput.frame.size.width, _wrapperInvitInput.frame.size.height);
        self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y + heightSearchLocation, _userList.frame.size.width, _userList.frame.size.height);
        self.synContact.frame = CGRectMake(_synContact.frame.origin.x, _synContact.frame.origin.y + heightSearchLocation, _synContact.frame.size.width, _synContact.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            if (_searchLocationIsOpen) {
                self.cancelLocation.alpha = 1;
                self.locationInput.frame = CGRectMake(_locationInput.frame.origin.x, _locationInput.frame.origin.y, 300 - 1 - self.cancelLocation.maxWidth, _locationInput.frame.size.height);
            } else {
                self.openMap.alpha = 1;
            }
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

- (void)openUserListView{
    
    self.userListIsOpen = !_userListIsOpen;
    
    if (_userListIsOpen) {
        self.wrapper.scrollEnabled = NO;
        self.userList.scrollView.scrollEnabled = YES;
    } else {
        self.wrapper.scrollEnabled = YES;
        self.userList.scrollView.scrollEnabled = NO;
    }
    
    if (_userListIsOpen) {
        self.cancelInvit.frame = CGRectMake(320 - 10, _invitInput.frame.origin.y, 0, 47);
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        if (_userListIsOpen) {
            self.cancelInvit.frame = CGRectMake(320 - 10 - self.cancelInvit.maxWidth, _cancelInvit.frame.origin.y, self.cancelInvit.maxWidth, 47);
            self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y, 300 - 1 - self.cancelInvit.maxWidth, _invitInput.frame.size.height);
            self.cancelInvit.titleLabel.alpha = 1;
            self.wrapper.contentOffset = CGPointMake(0, _titleInvit.frame.origin.y + _titleInvit.frame.size.height);
            [self.userList animateToMinHeight];
        } else {
            self.cancelInvit.frame = CGRectMake(320 - 10, _cancelInvit.frame.origin.y, 0, 47);
            self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y, 300, _invitInput.frame.size.height);
            self.cancelInvit.titleLabel.alpha = 0;
            self.wrapper.contentOffset = CGPointMake(0, _titleInvit.frame.origin.y - 20);
            [self.userList animateToMaxHeight];
        }
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)buttonSelectManager:(UIButton *)sender{
    
    BOOL calendarGoOpen = NO;
    BOOL reset = NO;
    
    if (sender == _todayBtnSelect) {
        self.imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar"];
        self.todayBtnSelect.selected = YES;
        self.tomorrowBtnSelect.selected = NO;
        [self.timePicker isToday:YES];
    } else if (sender == _tomorrowBtnSelect){
        self.imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar"];
        self.todayBtnSelect.selected = NO;
        self.tomorrowBtnSelect.selected = YES;
        [self.timePicker isToday:NO];
    } else {
        
        if ((_todayBtnSelect.selected || _tomorrowBtnSelect.selected) && _imgOpenCalendar.image == [UIImage imageNamed:@"F1_calendar_selected"]) {
            calendarGoOpen = NO;
            reset = YES;
            self.imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar"];
        } else {
            calendarGoOpen = YES;
            self.imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar_selected"];
            self.todayBtnSelect.selected = NO;
            self.tomorrowBtnSelect.selected = NO;
        }
        
        [self.timePicker isToday:NO];
        
    }
    
    if (calendarGoOpen != _calendarIsOpen) {
        
        [self openCalendarViewWithReset:reset];
        
    }
    
}

- (void)startSearchLocation {
    self.searchLocation.searchLocation = _locationInput.text;
}

- (void)goBack{
    
    if (self.editActivity) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Edit" label:@"Dropout" value:nil] build]];
    }else{
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Create" label:@"Dropout" value:nil] build]];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.alpha = 0;
        self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, self.view.frame.size.height, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
}

#pragma mark -- Form

- (void)createEditForm{
    
    if ([self checkInputValid]) {
        
        self.buttonAction.hidden = YES;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"yyyy-M-dd HH:mm";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        // Day
        
        NSDate *date;
        
        if (self.todayBtnSelect.selected) {
            date = [NSDate date];
        } else if (self.tomorrowBtnSelect.selected) {
            date = [NSDate mk_dateTomorrow];
        } else {
            date = [self.calendar selectedDate];
        }
        
        // Time
        
        NSDate *time = [self.timePicker selectedTime];
        
        // Date + Time
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        
        [components setHour:[time mk_hour]];
        [components setMinute:[time mk_minutes]];
        
        NSDate *dateFull = [calendar dateFromComponents:components];
        
        // Privacy
        
        BOOL privateLocation = YES;
        
        if (_canuCreateActivity == CANUCreateActivityLocal) {
            privateLocation = NO;
        }
        
        // Description
        
        NSString *description = @"";
        
        if (![self.descriptionInput.text isEqualToString:NSLocalizedString(@"Add a description", nil)]) {
            description = self.descriptionInput.text;
        }
        
        if (_editActivity) {
            
            self.deleteButton.hidden = YES;
            
            [self.editActivity editActivityForUserWithTitle:self.titleInput.text
                                                Description:description
                                                  StartDate:[dateFormatter stringFromDate:dateFull]
                                                     Length:[self.lenghtPicker selectedLenght]
                                                     Street:self.locationSelected.street
                                                       City:self.locationSelected.city
                                                        Zip:self.locationSelected.zip
                                                    Country:self.locationSelected.country
                                                   Latitude:[NSString stringWithFormat:@"%f",self.locationSelected.latitude]
                                                  Longitude:[NSString stringWithFormat:@"%f",self.locationSelected.longitude]
                                                     Guests:nil
                                            PrivateLocation:self.editActivity.privacyLocation
                                                      Block:^(NSError *error) {
                                                          
                                                          if (error) {
                                                              NSLog(@"%@",error);
                                                          } else {
                                                              
                                                              id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                                                              [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Edit" label:@"Save" value:nil] build]];
                                                              
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
                                                              
                                                              [UIView animateWithDuration:0.4 animations:^{
                                                                  self.wrapper.alpha = 0;
                                                                  self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, self.view.frame.size.height, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
                                                              } completion:^(BOOL finished) {
                                                                  
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                                  
                                                              }];
                                                              
                                                          }
                                                          
                                                          self.buttonAction.hidden = NO;
                                                          self.deleteButton.hidden = NO;
                                                          
                                                      }];
            
        } else {
            
            [Activity createActivityForUserWithTitle:self.titleInput.text
                                         Description:description
                                           StartDate:[dateFormatter stringFromDate:dateFull]
                                              Length:[self.lenghtPicker selectedLenght]
                                              Street:self.locationSelected.street
                                                City:self.locationSelected.city
                                                 Zip:self.locationSelected.zip
                                             Country:self.locationSelected.country
                                            Latitude:[NSString stringWithFormat:@"%f",self.locationSelected.latitude]
                                           Longitude:[NSString stringWithFormat:@"%f",self.locationSelected.longitude]
                                              Guests:[self createArrayUserInvited]
                                     PrivateLocation:privateLocation
                                               Block:^(Activity *activity, NSError *error) {
                                                   
                                                   if (error) {
                                                       NSLog(@"%@",error);
                                                   } else {
                                                       
                                                       id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                                                       [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Create" label:@"Save" value:nil] build]];
                                                       
                                                       if (!_ghostUser) {
                                                           
                                                           [UIView animateWithDuration:0.4 animations:^{
                                                               self.wrapper.alpha = 0;
                                                               self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, self.view.frame.size.height, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
                                                           } completion:^(BOOL finished) {
                                                               
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                               
                                                           }];
                                                           
                                                       } else {
                                                           
                                                           self.createActivity = activity;
                                                           
                                                           self.messageGhostUser = [[MessageGhostUser alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) andArray:self.userList.arrayAllUserSelected andParentViewcontroller:self withActivity:activity];
                                                           self.messageGhostUser.delegate = self;
                                                           [self.view addSubview:_messageGhostUser];
                                                           
                                                       }
                                                       
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
                                                       
                                                   }
                                                   
                                                   self.buttonAction.hidden = NO;
                                                   
                                               }];
            
        }
    
    }
    
}

- (void)deleteActivity{
    
    [self.editActivity removeActivityWithBlock:^(NSError *error){
        if (!error) {
            
            if (self.delegate) {
                [self.delegate currentActivityWasDeleted];
            } else {
               [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
            }
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Activity" action:@"Edit" label:@"Delete" value:nil] build]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            //[error localizedDescription]
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:@"Couldn't delete the activity." delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        }
        
    }];
    
}

- (BOOL)checkInputValid{
    
    BOOL inputValid = YES;
    
    if ([_titleInput.text mk_isEmpty]) {
        self.titleInput.valueValide = NO;
        inputValid = NO;
    } else {
        self.titleInput.valueValide = YES;
    }
    
    if (self.locationSelected) {
        self.locationInput.valueValide = YES;
    } else {
        self.locationInput.valueValide = NO;
        inputValid = NO;
    }
    
    if (_canuCreateActivity == CANUCreateActivityTribes && !self.editActivity) {
        
        if ([self.userList.arrayAllUserSelected count] != 0) {
            self.invitInput.valueValide = YES;
        } else {
            self.invitInput.valueValide = NO;
            inputValid = NO;
            if (self.userList.canuError && self.userList.canuError != CANUErrorNoError) {
                self.labelSyncContact.textColor = UIColorFromRGB(0xec5f56);
            } else {
                self.labelSyncContact.textColor = UIColorFromRGB(0x2b4b58);
            }
        }
        
    }
    
    return inputValid;
    
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

@end
