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
#import "UICanuButtonSelect.h"
#import "UICanuTimePicker.h"
#import "UICanuLenghtPicker.h"
#import "CreateEditUserList.h"
#import "UICanuCalendarPicker.h"
#import "UICanuSearchLocation.h"
#import "AppDelegate.h"

@interface CreateEditActivityViewController () <UITextFieldDelegate,UITextViewDelegate,UICanuCalendarPickerDelegate>

@property (nonatomic) BOOL descriptionIsOpen;
@property (nonatomic) BOOL calendarIsOpen;
@property (nonatomic) BOOL searchLocationIsOpen;
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
@property (strong, nonatomic) CreateEditUserList *userList;
@property (strong, nonatomic) UICanuTextField *titleInput;
@property (strong, nonatomic) UICanuTextField *invitInput;
@property (strong, nonatomic) UICanuTextFieldLocation *locationInput;
@property (strong, nonatomic) UICanuButtonSelect *todayBtnSelect;
@property (strong, nonatomic) UICanuButtonSelect *tomorrowBtnSelect;
@property (strong, nonatomic) UICanuTimePicker *timePicker;
@property (strong, nonatomic) UICanuLenghtPicker *lenghtPicker;
@property (strong, nonatomic) UICanuCalendarPicker *calendar;
@property (strong, nonatomic) UICanuSearchLocation *searchLocation;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Init
    
    self.descriptionIsOpen = NO;
    self.calendarIsOpen = NO;
    self.searchLocationIsOpen = NO;
    
    self.wrapper = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.wrapper.contentSize = CGSizeMake(320, 800);
    [self.view addSubview:_wrapper];
    
    // Title
    
    self.titleInput = [[UICanuTextField alloc]initWithFrame:CGRectMake(10, 90, 250, 47)];
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
    [self.wrapper addSubview:_timePicker];
    
    self.lenghtPicker = [[UICanuLenghtPicker alloc]initWithFrame:CGRectMake(10 + 149 + 1, _todayBtnSelect.frame.origin.y + _todayBtnSelect.frame.size.height + 5, 149, 57)];
    [self.wrapper addSubview:_lenghtPicker];
    
    // Location
    
    self.locationInput = [[UICanuTextFieldLocation alloc]initWithFrame:CGRectMake(10, _timePicker.frame.origin.y + _timePicker.frame.size.height + 5, 250, 47)];
    self.locationInput.placeholder = NSLocalizedString(@"Find a place", nil);
    self.locationInput.delegate = self;
    self.locationInput.returnKeyType = UIReturnKeyNext;
    [self.wrapper addSubview:_locationInput];
    
    UIImageView *imgOpenMap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 47)];
    imgOpenMap.image = [UIImage imageNamed:@"F1_open_map"];
    
    self.openMap = [[UIButton alloc]initWithFrame:CGRectMake(10 + 250 + 1, _timePicker.frame.origin.y + _timePicker.frame.size.height + 5, 49, 47)];
    self.openMap.backgroundColor = [UIColor whiteColor];
    [self.openMap addSubview:imgOpenMap];
    [self.wrapper addSubview:_openMap];
    
    // Invit
    
    self.titleInvit = [[UILabel alloc]initWithFrame:CGRectMake(10, _locationInput.frame.origin.y + _locationInput.frame.size.height + 51, 300, 18)];
    self.titleInvit.backgroundColor = backgroundColorView;
    self.titleInvit.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.titleInvit.text = NSLocalizedString(@"Who is invited?", nil);
    self.titleInvit.textColor = UIColorFromRGB(0x2b4b58);
    self.titleInvit.textAlignment = NSTextAlignmentCenter;
    [self.wrapper addSubview:_titleInvit];
    
    self.invitInput = [[UICanuTextField alloc]initWithFrame:CGRectMake(10, _titleInvit.frame.origin.y + _titleInvit.frame.size.height + 5, 300, 47)];
    self.invitInput.placeholder = NSLocalizedString(@"Who is invited?", nil);
    self.invitInput.delegate = self;
    self.invitInput.returnKeyType = UIReturnKeySearch;
    [self.wrapper addSubview:_invitInput];
    
    self.userList = [[CreateEditUserList alloc]initWithFrame:CGRectMake(10, _invitInput.frame.origin.y + _invitInput.frame.size.height + 5, 300, 200)];
    [self.wrapper addSubview:_userList];
    
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
        } else {
            
            self.currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]]];
            
            self.searchLocation.currentLocation = _currentLocation;
            
        }
        
        // Active Map or not
         
     }];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _titleInput) {
        [self.titleInput resignFirstResponder];
    } else if (textField == _locationInput) {
        [self.locationInput resignFirstResponder];
    }
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSNumber *position = [NSNumber numberWithInt:textField.frame.origin.y - 5];
    
    if (textField == _locationInput) {
        if (!_searchLocationIsOpen) {
            [self openSearchLocationView];
        }
    }
    
    [self performSelector:@selector(changePositionWrapper:) withObject:position afterDelay:0.4];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _locationInput) {
        
        [self.timerSearch invalidate];
        self.timerSearch = nil;
        
        self.timerSearch = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector:@selector(startSearchLocation) userInfo: nil repeats:NO];
    }
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _locationInput) {
        if (_searchLocationIsOpen) {
            [self openSearchLocationView];
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

#pragma mark - Private

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
        heightSearchLocation = 213 + 10;
        margin = 10;
    } else {
        heightSearchLocation = - 213 - 10;
        margin = - 10;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.contentSize = CGSizeMake(320, _wrapper.contentSize.height + heightSearchLocation);
        self.searchLocation.frame = CGRectMake(_searchLocation.frame.origin.x, _searchLocation.frame.origin.y, _searchLocation.frame.size.width, _searchLocation.frame.size.height + heightSearchLocation - margin);
        self.titleInvit.frame = CGRectMake(_titleInvit.frame.origin.x, _titleInvit.frame.origin.y + heightSearchLocation, _titleInvit.frame.size.width, _titleInvit.frame.size.height);
        self.invitInput.frame = CGRectMake(_invitInput.frame.origin.x, _invitInput.frame.origin.y + heightSearchLocation, _invitInput.frame.size.width, _invitInput.frame.size.height);
        self.userList.frame = CGRectMake(_userList.frame.origin.x, _userList.frame.origin.y + heightSearchLocation, _userList.frame.size.width, _userList.frame.size.height);
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
    } else if (sender == _tomorrowBtnSelect){
        self.imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar"];
        self.todayBtnSelect.selected = NO;
        self.tomorrowBtnSelect.selected = YES;
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
        
    }
    
    if (calendarGoOpen != _calendarIsOpen) {
        
        [self openCalendarViewWithReset:reset];
        
    }
    
}

- (void)startSearchLocation{
    self.searchLocation.searchLocation = _locationInput.text;
}

@end
