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
#import "UICanuButtonSignBottomBar.h"
#import "Contact.h"
#import "User.h"
#import "MessageGhostUser.h"

@interface CreateEditActivityViewController () <UITextFieldDelegate,UITextViewDelegate,UICanuCalendarPickerDelegate,UICanuSearchLocationDelegate,SearchLocationMapViewControllerDelegate,CreateEditUserListDelegate,MessageGhostUserDelegate>

@property (nonatomic) BOOL descriptionIsOpen;
@property (nonatomic) BOOL calendarIsOpen;
@property (nonatomic) BOOL searchLocationIsOpen;
@property (nonatomic) BOOL userListIsOpen;
@property (nonatomic) BOOL mapLocationIsOpen;
@property (nonatomic) BOOL isNewActivity;
@property (nonatomic) BOOL ghostUser;
@property (strong, nonatomic) NSTimer *timerSearch;
@property (strong, nonatomic) MKMapItem *currentLocation;
@property (strong, nonatomic) UIImageView *imgOpenCalendar;
@property (strong, nonatomic) UIImageView *imgAddDescription;
@property (strong, nonatomic) UIView *wrapperDescription;
@property (strong, nonatomic) UILabel *titleInvit;
@property (strong, nonatomic) UIButton *openMap;
@property (strong, nonatomic) UIButton *openCalendar;
@property (strong, nonatomic) UIScrollView *wrapper;
@property (strong, nonatomic) UITextView *descriptionInput;
@property (strong, nonatomic) UIView *bottomBar;
@property (strong, nonatomic) Activity *createActivity;
@property (strong, nonatomic) Location *locationSelected;
@property (nonatomic) CANUCreateActivity canuCreateActivity;
@property (strong, nonatomic) CreateEditUserList *userList;
@property (strong, nonatomic) UICanuTextField *titleInput;
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
@property (strong, nonatomic) UICanuButtonSignBottomBar *buttonAction;

@end

#pragma mark - Lifecycle

@implementation CreateEditActivityViewController

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
    
    self.wrapper = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 57)];
    [self.view addSubview:_wrapper];
    
    // Title
    
    self.titleInput = [[UICanuTextField alloc]initWithFrame:CGRectMake(10, 85, 250, 47)];
    self.titleInput.placeholder = NSLocalizedString(@"What do you want to do?", nil);
    self.titleInput.returnKeyType = UIReturnKeyNext;
    self.titleInput.delegate = self;
    [self.wrapper addSubview:_titleInput];
    
    // Description
    
    self.imgAddDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 47)];
    self.imgAddDescription.image = [UIImage imageNamed:@"F1_add_description"];
    
    UIButton *addDescription = [[UIButton alloc]initWithFrame:CGRectMake(10 + 250 + 1, _titleInput.frame.origin.y, 49, 47)];
    [addDescription addTarget:self action:@selector(openDescriptionView) forControlEvents:UIControlEventTouchDown];
    addDescription.backgroundColor = [UIColor whiteColor];
    [addDescription addSubview:_imgAddDescription];
    [self.wrapper addSubview:addDescription];
    
    // Date
    
    self.todayBtnSelect = [[UICanuButtonSelect alloc]initWithFrame:CGRectMake(10, _titleInput.frame.origin.y + _titleInput.frame.size.height + 5, 100, 47)];
    self.todayBtnSelect.textButton = NSLocalizedString(@"Today", nil);
    self.todayBtnSelect.selected = YES;
    [self.todayBtnSelect addTarget:self action:@selector(buttonSelectManager:) forControlEvents:UIControlEventTouchDown];
    [self.wrapper addSubview:_todayBtnSelect];
    
    self.tomorrowBtnSelect = [[UICanuButtonSelect alloc]initWithFrame:CGRectMake(10 + 100, _titleInput.frame.origin.y + _titleInput.frame.size.height + 5, 100, 47)];
    self.tomorrowBtnSelect.textButton = NSLocalizedString(@"Tomorrow", nil);
    [self.tomorrowBtnSelect addTarget:self action:@selector(buttonSelectManager:) forControlEvents:UIControlEventTouchDown];
    [self.wrapper addSubview:_tomorrowBtnSelect];
    
    self.imgOpenCalendar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 47)];
    self.imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar"];
    
    self.openCalendar = [[UIButton alloc]initWithFrame:CGRectMake(200 + 10, _titleInput.frame.origin.y + _titleInput.frame.size.height + 5, 100, 47)];
    self.openCalendar.backgroundColor = [UIColor clearColor];
    [self.openCalendar addTarget:self action:@selector(buttonSelectManager:) forControlEvents:UIControlEventTouchDown];
    [self.openCalendar addSubview:_imgOpenCalendar];
    [self.wrapper addSubview:_openCalendar];
    
    // Time
    
    self.timePicker = [[UICanuTimePicker alloc]initWithFrame:CGRectMake(10, _todayBtnSelect.frame.origin.y + _todayBtnSelect.frame.size.height + 5, 149, 57)];
    [self.timePicker isToday:YES];
    [self.wrapper addSubview:_timePicker];
    
    self.lenghtPicker = [[UICanuLenghtPicker alloc]initWithFrame:CGRectMake(10 + 149 + 1, _todayBtnSelect.frame.origin.y + _todayBtnSelect.frame.size.height + 5, 149, 57)];
    [self.wrapper addSubview:_lenghtPicker];
    
    // Location
    
    self.locationInput = [[UICanuTextFieldLocation alloc]initWithFrame:CGRectMake(10, _timePicker.frame.origin.y + _timePicker.frame.size.height + 5, 250, 47)];
    self.locationInput.placeholder = NSLocalizedString(@"Find a place", nil);
    self.locationInput.delegate = self;
    self.locationInput.returnKeyType = UIReturnKeySearch;
    [self.wrapper addSubview:_locationInput];
    
    UIImageView *imgOpenMap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 47)];
    imgOpenMap.image = [UIImage imageNamed:@"F1_open_map"];
    
    self.openMap = [[UIButton alloc]initWithFrame:CGRectMake(10 + 250 + 1, _timePicker.frame.origin.y + _timePicker.frame.size.height + 5, 49, 47)];
    [self.openMap addTarget:self action:@selector(btnSearchWithTheMap) forControlEvents:UIControlEventTouchDown];
    self.openMap.backgroundColor = [UIColor whiteColor];
    [self.openMap addSubview:imgOpenMap];
    [self.wrapper addSubview:_openMap];
    
    self.cancelLocation = [[UICanuButtonCancel alloc]initWithFrame:CGRectMake(320 - 10, _openMap.frame.origin.y, 0, 47)];
    [self.cancelLocation addTarget:self action:@selector(cancelSearchLocation) forControlEvents:UIControlEventTouchDown];
    [self.cancelLocation detectSize];
    self.cancelLocation.alpha = 0;
    self.cancelLocation.titleLabel.alpha = 0;
    [self.wrapper addSubview:_cancelLocation];
    
    // Invit
    
    self.titleInvit = [[UILabel alloc]initWithFrame:CGRectMake(10, _locationInput.frame.origin.y + _locationInput.frame.size.height + 51, 300, 18)];
    self.titleInvit.backgroundColor = backgroundColorView;
    self.titleInvit.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.titleInvit.text = NSLocalizedString(@"Who is invited?", nil);
    self.titleInvit.textColor = UIColorFromRGB(0x2b4b58);
    self.titleInvit.textAlignment = NSTextAlignmentCenter;
    [self.wrapper addSubview:_titleInvit];
    
    self.invitInput = [[UICanuTextFieldInvit alloc]initWithFrame:CGRectMake(10, _titleInvit.frame.origin.y + _titleInvit.frame.size.height + 5, 300, 47)];
    self.invitInput.placeholder = NSLocalizedString(@"Who is invited?", nil);
    self.invitInput.delegate = self;
    self.invitInput.returnKeyType = UIReturnKeySearch;
    [self.wrapper addSubview:_invitInput];
    
    self.cancelInvit = [[UICanuButtonCancel alloc]initWithFrame:CGRectMake(320 - 10, _invitInput.frame.origin.y, 0, 47)];
    [self.cancelInvit setTitle:NSLocalizedString(@"Ok", nil) forState:UIControlStateNormal];
    [self.cancelInvit addTarget:self action:@selector(cancelInvitUser) forControlEvents:UIControlEventTouchDown];
    [self.cancelInvit detectSize];
    self.cancelInvit.titleLabel.alpha = 0;
    [self.wrapper addSubview:_cancelInvit];
    
    // Bottom bar
    
    self.bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 57, self.view.frame.size.width, 57)];
    self.bottomBar.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.view addSubview:_bottomBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    [_bottomBar addSubview:backButton];
    
    self.buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0) andBlue:YES];
    [self.buttonAction setTitle:NSLocalizedString(@"CREATE", nil) forState:UIControlStateNormal];
    [self.buttonAction addTarget:self action:@selector(createEditForm) forControlEvents:UIControlEventTouchDown];
    [_bottomBar addSubview:_buttonAction];
    
    // Wrapper
    self.wrapper.contentSize = CGSizeMake(320, _invitInput.frame.origin.y + _invitInput.frame.size.height + 5);
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    // Description
    self.wrapperDescription = [[UIView alloc]initWithFrame:CGRectMake(0, _titleInput.frame.origin.y + _titleInput.frame.size.height + 5, 320, 0)];
    self.wrapperDescription.backgroundColor = UIColorFromRGB(0xe9eeee);
    self.wrapperDescription.clipsToBounds = YES;
    [self.wrapper addSubview:_wrapperDescription];
    
    self.descriptionInput = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, 280, 80)];
    self.descriptionInput.textColor = UIColorFromRGB(0xabb3b7);
    self.descriptionInput.text = NSLocalizedString(@"Add a description", nil);
    self.descriptionInput.backgroundColor = UIColorFromRGB(0xe9eeee);
    self.descriptionInput.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.descriptionInput.returnKeyType = UIReturnKeyNext;
    self.descriptionInput.delegate = self;
    [self.wrapperDescription addSubview:_descriptionInput];
    
    UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 6)];
    shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
    [self.wrapperDescription addSubview:shadowDescription];
    
    UIImageView *shadowDescriptionReverse = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100 - 6, 320, 6)];
    shadowDescriptionReverse.image = [UIImage imageNamed:@"F1_Shadow_Description"];
    shadowDescriptionReverse.transform = CGAffineTransformMakeRotation(M_PI);
    [self.wrapperDescription addSubview:shadowDescriptionReverse];
    
    // Calendar
    
    self.calendar = [[UICanuCalendarPicker alloc]initWithFrame:CGRectMake(0, _todayBtnSelect.frame.origin.y + _todayBtnSelect.frame.size.height + 5, 320, 0)];
    self.calendar.delegate = self;
    [self.wrapper addSubview:_calendar];
    
    // Search Location
    
    self.searchLocation = [[UICanuSearchLocation alloc]initWithFrame:CGRectMake(0, _locationInput.frame.origin.y + _locationInput.frame.size.height + 5, 320, 0)];
    self.searchLocation.delegate = self;
    [self.wrapper addSubview:_searchLocation];
    
    // Current Location
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
            
        }
        
        // Active Map or not
         
     }];
    
    // User List
    
    self.userList = [[CreateEditUserList alloc]initWithFrame:CGRectMake(0, _invitInput.frame.origin.y + _invitInput.frame.size.height + 5, 320, 0)];
    self.userList.delegate = self;
    [self.wrapper addSubview:_userList];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _titleInput) {
        [self.titleInput resignFirstResponder];
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
        [self openUserListView];
    }
    
    [self performSelector:@selector(changePositionWrapper:) withObject:position afterDelay:0.4];
    
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
        } else {
            self.invitInput.activeReset = NO;
        }
        
        [self.userList searchPhoneBook:newString];
        
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
    }
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:NSLocalizedString(@"Add a description", nil)]) {
        textView.text = @"";
        textView.textColor = UIColorFromRGB(0x2b4b58);
    }
    [textView becomeFirstResponder];
    
    NSNumber *position = [NSNumber numberWithInt:_titleInput.frame.origin.y - 5];
    
    [self performSelector:@selector(changePositionWrapper:) withObject:position afterDelay:0.4];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"Add a description", nil);
        textView.textColor = UIColorFromRGB(0xabb3b7);
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
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

#pragma mark -  CreateEditUserListDelegate

- (void)changeUserSelected:(NSMutableArray *)arrayAllUserSelected{
    
    [self.invitInput updateUserSelected:arrayAllUserSelected];
    
}

#pragma mark - Private

- (void)cancelSearchLocation{
    
    [self.locationInput resignFirstResponder];
    
}

- (void)cancelInvitUser{
    
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

- (void)changePositionWrapper:(NSNumber *)position{
    
    [self.wrapper setContentOffset:CGPointMake(0, [position intValue]) animated:YES];
    
}

- (void)openDescriptionView{
    
    self.descriptionIsOpen = !_descriptionIsOpen;
    
    int heightDescription;
    
    if (_descriptionIsOpen) {
        self.imgAddDescription.image = [UIImage imageNamed:@"F1_add_description_selected"];
        
        heightDescription = 100;
    } else {
        self.imgAddDescription.image = [UIImage imageNamed:@"F1_add_description"];
        
        heightDescription = - 100;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + heightDescription);
        self.wrapperDescription.frame = CGRectMake(_wrapperDescription.frame.origin.x, _wrapperDescription.frame.origin.y, _wrapperDescription.frame.size.width, _wrapperDescription.frame.size.height + heightDescription);
        self.todayBtnSelect.frame = CGRectMake(_todayBtnSelect.frame.origin.x, _todayBtnSelect.frame.origin.y + heightDescription, _todayBtnSelect.frame.size.width, _todayBtnSelect.frame.size.height);
        self.tomorrowBtnSelect.frame = CGRectMake(_tomorrowBtnSelect.frame.origin.x, _tomorrowBtnSelect.frame.origin.y + heightDescription, _tomorrowBtnSelect.frame.size.width, _tomorrowBtnSelect.frame.size.height);
        self.openCalendar.frame = CGRectMake(_openCalendar.frame.origin.x, _openCalendar.frame.origin.y + heightDescription, _openCalendar.frame.size.width, _openCalendar.frame.size.height);
        self.calendar.frame = CGRectMake(_calendar.frame.origin.x, _calendar.frame.origin.y + heightDescription, _calendar.frame.size.width, _calendar.frame.size.height);
        self.timePicker.frame = CGRectMake(_timePicker.frame.origin.x, _timePicker.frame.origin.y + heightDescription, _timePicker.frame.size.width, _timePicker.frame.size.height);
        self.lenghtPicker.frame = CGRectMake(_lenghtPicker.frame.origin.x, _lenghtPicker.frame.origin.y + heightDescription, _lenghtPicker.frame.size.width, _lenghtPicker.frame.size.height);
        self.locationInput.frame = CGRectMake(_locationInput.frame.origin.x, _locationInput.frame.origin.y + heightDescription, _locationInput.frame.size.width, _locationInput.frame.size.height);
        self.openMap.frame = CGRectMake(_openMap.frame.origin.x, _openMap.frame.origin.y + heightDescription, _openMap.frame.size.width, _openMap.frame.size.height);
        self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y + heightDescription, _searchLocation.frame.size.width, _searchLocation.frame.size.height);
        self.titleInvit.frame = CGRectMake(_titleInvit.frame.origin.x, _titleInvit.frame.origin.y + heightDescription, _titleInvit.frame.size.width, _titleInvit.frame.size.height);
        self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y + heightDescription, _invitInput.frame.size.width, _invitInput.frame.size.height);
        self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y + heightDescription, _userList.frame.size.width, _userList.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)openCalendarViewWithReset:(BOOL)reset{
    
    self.calendarIsOpen = !_calendarIsOpen;
    
    int heightCalendar,margin;
    
    if (_calendarIsOpen) {
        heightCalendar = 116 + 10;
        margin = 10;
    } else {
        heightCalendar = - 116 - 10;
        margin = - 10;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + heightCalendar);
        self.calendar.frame = CGRectMake(_calendar.frame.origin.x, _calendar.frame.origin.y, _calendar.frame.size.width, _calendar.frame.size.height + heightCalendar - margin);
        self.timePicker.frame = CGRectMake(_timePicker.frame.origin.x, _timePicker.frame.origin.y + heightCalendar, _timePicker.frame.size.width, _timePicker.frame.size.height);
        self.lenghtPicker.frame = CGRectMake(_lenghtPicker.frame.origin.x, _lenghtPicker.frame.origin.y + heightCalendar, _lenghtPicker.frame.size.width, _lenghtPicker.frame.size.height);
        self.locationInput.frame = CGRectMake(_locationInput.frame.origin.x, _locationInput.frame.origin.y + heightCalendar, _locationInput.frame.size.width, _locationInput.frame.size.height);
        self.openMap.frame = CGRectMake(_openMap.frame.origin.x, _openMap.frame.origin.y + heightCalendar, _openMap.frame.size.width, _openMap.frame.size.height);
        self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y + heightCalendar, _searchLocation.frame.size.width, _searchLocation.frame.size.height);
        self.titleInvit.frame = CGRectMake(_titleInvit.frame.origin.x, _titleInvit.frame.origin.y + heightCalendar, _titleInvit.frame.size.width, _titleInvit.frame.size.height);
        self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y + heightCalendar, _invitInput.frame.size.width, _invitInput.frame.size.height);
        self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y + heightCalendar, _userList.frame.size.width, _userList.frame.size.height);
    } completion:^(BOOL finished) {
        if (reset) {
            [self.calendar resetCalendar];
        }
    }];
    
}

- (void)openSearchLocationView{
    
    self.searchLocationIsOpen = !_searchLocationIsOpen;
    
    int heightSearchLocation,margin;
    
    if (_searchLocationIsOpen) {
        heightSearchLocation = self.searchLocation.maxHeight + 10;
        margin = 10;
        self.wrapper.scrollEnabled = NO;
    } else {
        heightSearchLocation = - self.searchLocation.maxHeight - 10;
        margin = - 10;
        self.wrapper.scrollEnabled = YES;
    }
    
    if (_searchLocationIsOpen) {
        self.cancelLocation.frame = _openMap.frame;
    } else {
        
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        if (_searchLocationIsOpen) {
            self.cancelLocation.alpha = 1;
        } else {
            self.cancelLocation.frame = _openMap.frame;
            self.locationInput.frame = CGRectMake(_locationInput.frame.origin.x, _locationInput.frame.origin.y, 250, _locationInput.frame.size.height);
            self.cancelLocation.titleLabel.alpha = 0;
        }
        self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + heightSearchLocation);
        self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y, _searchLocation.frame.size.width, _searchLocation.frame.size.height + heightSearchLocation - margin);
        self.titleInvit.frame = CGRectMake(_titleInvit.frame.origin.x, _titleInvit.frame.origin.y + heightSearchLocation, _titleInvit.frame.size.width, _titleInvit.frame.size.height);
        self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y + heightSearchLocation, _invitInput.frame.size.width, _invitInput.frame.size.height);
        self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y + heightSearchLocation, _userList.frame.size.width, _userList.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            if (_searchLocationIsOpen) {
                self.cancelLocation.frame = CGRectMake(320 - 10 - self.cancelLocation.maxWidth, _openMap.frame.origin.y, self.cancelLocation.maxWidth, 47);
                self.locationInput.frame = CGRectMake(_locationInput.frame.origin.x, _locationInput.frame.origin.y, 300 - 1 - self.cancelLocation.maxWidth, _locationInput.frame.size.height);
                self.cancelLocation.titleLabel.alpha = 1;
            } else {
                self.cancelLocation.alpha = 0;
            }
        } completion:^(BOOL finished) {
            if (!_searchLocationIsOpen) {
                self.cancelLocation.frame = CGRectMake(320 - 10, _openMap.frame.origin.y, 0, 47);
            }
        }];
    }];
    
}

- (void)openUserListView{
    
    self.userListIsOpen = !_userListIsOpen;
    
    int height,margin;
    
    if (_userListIsOpen) {
        height = self.userList.maxHeight + 10;
        margin = 10;
        self.wrapper.scrollEnabled = NO;
    } else {
        height = - self.userList.maxHeight - 10;
        margin = - 10;
        self.wrapper.scrollEnabled = YES;
    }
    
    if (_userListIsOpen) {
        self.cancelInvit.frame = CGRectMake(320 - 10, _invitInput.frame.origin.y, 0, 47);
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        if (_userListIsOpen) {
            self.cancelInvit.frame = CGRectMake(320 - 10 - self.cancelInvit.maxWidth, _invitInput.frame.origin.y, self.cancelInvit.maxWidth, 47);
            self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y, 300 - 1 - self.cancelInvit.maxWidth, _invitInput.frame.size.height);
            self.cancelInvit.titleLabel.alpha = 1;
        } else {
            self.cancelInvit.frame = CGRectMake(320 - 10, _invitInput.frame.origin.y, 0, 47);
            self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y, 300, _invitInput.frame.size.height);
            self.cancelInvit.titleLabel.alpha = 0;
        }
        self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + height);
        self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y, _userList.frame.size.width, _userList.frame.size.height + height);
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
                                                   
                                                   if (!_ghostUser) {
                                                       
                                                       [UIView animateWithDuration:0.4 animations:^{
                                                           self.wrapper.alpha = 0;
                                                           self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, self.view.frame.size.height, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
                                                       } completion:^(BOOL finished) {
                                                           
                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
                                                       
                                                   } else {
                                                       
                                                       self.createActivity = activity;
                                                       
                                                       self.messageGhostUser = [[MessageGhostUser alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) andArray:self.userList.arrayAllUserSelected andParentViewcontroller:self];
                                                       self.messageGhostUser.delegate = self;
                                                       [self.view addSubview:_messageGhostUser];
                                                       
                                                   }
                                                   
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
                                                   
                                               }
                                               
                                               self.buttonAction.hidden = NO;
                                     
                                 }];
        
    }
    
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
    
    if (_canuCreateActivity == CANUCreateActivityTribes) {
        
        if ([self.userList.arrayAllUserSelected count] != 0) {
            self.invitInput.valueValide = YES;
        } else {
            self.invitInput.valueValide = NO;
            inputValid = NO;
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

#pragma mark -- MessageGhostUserDelegate

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

@end
