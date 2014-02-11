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
#import "UICanuButtonSelect.h"
#import "UICanuTimePicker.h"
#import "UICanuLenghtPicker.h"

@interface CreateEditActivityViewController ()

@property (strong, nonatomic) UILabel *titleInvit;
@property (strong, nonatomic) UIButton *openMap;
@property (strong, nonatomic) UIButton *openCalendar;
@property (strong, nonatomic) UIScrollView *wrapper;
@property (strong, nonatomic) UICanuTextField *titleInput;
@property (strong, nonatomic) UICanuTextField *locationInput;
@property (strong, nonatomic) UICanuButtonSelect *todayBtnSelect;
@property (strong, nonatomic) UICanuButtonSelect *tomorrowBtnSelect;
@property (strong, nonatomic) UICanuTimePicker *timePicker;
@property (strong, nonatomic) UICanuLenghtPicker *lenghtPicker;

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
	
    self.wrapper = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, 320, self.view.frame.size.height - 90)];
    [self.view addSubview:_wrapper];
    
    // Title
    
    self.titleInput = [[UICanuTextField alloc]initWithFrame:CGRectMake(10, 0, 250, 47)];
    self.titleInput.placeholder = NSLocalizedString(@"What do you want to do?", nil);
    [self.wrapper addSubview:_titleInput];
    
    // Description
    
    UIImageView *imgAddDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 47)];
    imgAddDescription.image = [UIImage imageNamed:@"F1_add_description"];
    
    UIButton *addDescription = [[UIButton alloc]initWithFrame:CGRectMake(10 + 250 + 1, 0, 49, 47)];
    addDescription.backgroundColor = [UIColor whiteColor];
    [addDescription addSubview:imgAddDescription];
    [self.wrapper addSubview:addDescription];
    
    // Date
    
    self.todayBtnSelect = [[UICanuButtonSelect alloc]initWithFrame:CGRectMake(10, _titleInput.frame.size.height + 5, 100, 47)];
    self.todayBtnSelect.textButton = NSLocalizedString(@"Today", nil);
    self.todayBtnSelect.selected = YES;
    [self.wrapper addSubview:_todayBtnSelect];
    
    self.tomorrowBtnSelect = [[UICanuButtonSelect alloc]initWithFrame:CGRectMake(10 + 100, _titleInput.frame.size.height + 5, 100, 47)];
    self.tomorrowBtnSelect.textButton = NSLocalizedString(@"Tomorrow", nil);
    [self.wrapper addSubview:_tomorrowBtnSelect];
    
    UIImageView *imgOpenCalendar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 47)];
    imgOpenCalendar.image = [UIImage imageNamed:@"F1_calendar"];
    
    self.openCalendar = [[UIButton alloc]initWithFrame:CGRectMake(200 + 10, _titleInput.frame.size.height + 5, 100, 47)];
    self.openCalendar.backgroundColor = [UIColor clearColor];
    [self.openCalendar addSubview:imgOpenCalendar];
    [self.wrapper addSubview:_openCalendar];
    
    // Time
    
    self.timePicker = [[UICanuTimePicker alloc]initWithFrame:CGRectMake(10, _todayBtnSelect.frame.origin.y + _todayBtnSelect.frame.size.height + 5, 149, 57)];
    [self.wrapper addSubview:_timePicker];
    
    self.lenghtPicker = [[UICanuLenghtPicker alloc]initWithFrame:CGRectMake(10 + 149 + 1, _todayBtnSelect.frame.origin.y + _todayBtnSelect.frame.size.height + 5, 149, 57)];
    [self.wrapper addSubview:_lenghtPicker];
    
    // Location
    
    self.locationInput = [[UICanuTextField alloc]initWithFrame:CGRectMake(10, _timePicker.frame.origin.y + _timePicker.frame.size.height + 5, 250, 47)];
    self.locationInput.placeholder = NSLocalizedString(@"Location", nil);
    [self.wrapper addSubview:_locationInput];
    
    UIImageView *imgOpenMap = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 47)];
    imgOpenMap.image = [UIImage imageNamed:@"F1_open_map"];
    
    self.openMap = [[UIButton alloc]initWithFrame:CGRectMake(10 + 250 + 1, _timePicker.frame.origin.y + _timePicker.frame.size.height + 5, 49, 47)];
    self.openMap.backgroundColor = [UIColor whiteColor];
    [self.openMap addSubview:imgOpenMap];
    [self.wrapper addSubview:_openMap];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
