//
//  UserProfileViewController.m
//  CANU
//
//  Created by Roger Calaf on 23/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

//Custom CANU class import
#import "UICanuActivityCell.h"
#import "UIProfileView.h"
#import "AppDelegate.h"

//Models class import
#import "User.h"
#import "Activity.h"

//Controllers import
#import "UserProfileViewController.h"
#import "MainViewController.h"
#import "UserSettingsViewController.h"
//#import "NewActivityViewController.h"


@interface UserProfileViewController ()

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *activitiesButton;
@property (strong, nonatomic) IBOutlet UIButton *createActivityButton;

@property (strong, nonatomic) IBOutlet UIProfileView *profileView;
@property (strong, nonatomic) IBOutlet UITableView *myActivities;
@property (nonatomic) BOOL profileHidden;
@property (strong, nonatomic) User *user;

- (void)reload:(id)sender;

@end

@implementation UserProfileViewController{
@private
    NSArray *_activities;
}

@synthesize logoutButton = _logoutButton;
@synthesize activitiesButton = _activitiesButton;
@synthesize createActivityButton = _createActivityButton;
@synthesize user = _user;
@synthesize profileHidden = _profileHidden;


@synthesize profileView = _profileView;
@synthesize myActivities = _myActivities;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
        self.user = appDelegate.user;
        _profileHidden = YES;
    }
    return self;
}

/*
-(IBAction)createActivity:(id)sender{
    NewActivityViewController *nac = [[NewActivityViewController alloc] init];
    [self presentViewController:nac animated:YES completion:nil];
}*/



- (IBAction)showProfileInfo:(id)sender{
    [UIView animateWithDuration:0.3 animations:^(void){
        _profileView.frame = CGRectMake(0.0f, 345.0f, 320.0f, 114.0f);
        [_profileView hideComponents:NO];
        _myActivities.frame = CGRectMake(0.0f, 0.0f, 310.0f, 325.0f);
    } completion:^(BOOL finished) {
        if (finished){
            _profileHidden = NO;
        }
    }];
}

- (IBAction)HideProfileInfo:(id)sender{
    [UIView animateWithDuration:0.3 animations:^(void){
        _profileView.frame = CGRectMake(0.0f, 440.0f, 320.0f, 114.0f);
        _myActivities.frame = CGRectMake(0.0f, 0.0f, 310.0f, 420.0f);
    } completion:^(BOOL finished) {
        if (finished){
            [_profileView hideComponents:YES];
            _profileHidden = YES;
            
        }
    }];
}

- (IBAction)showSettings:(id)sender{
    NSLog(@"Showing settings");

    UserSettingsViewController *us = [[UserSettingsViewController alloc] init];
    [self presentViewController:us animated:YES completion:nil];
    
}

-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];
    
    self.myActivities = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 420.0) style:UITableViewStyleGrouped];
    
    self.myActivities.backgroundView = nil;
    self.myActivities.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];

    self.myActivities.dataSource = self;
    self.myActivities.delegate = self;
    
    [self reload:nil];
    [self.view addSubview:self.myActivities];
    
    self.profileView = [[UIProfileView alloc] initWithUser:self.user];
    [self.view addSubview:_profileView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.logoutButton addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchDown];
    
    
    //[self.activitiesButton addTarget:self action:@selector(showActivities:) forControlEvents:UIControlEventTouchDown];
    //[self.createActivityButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchDown];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showProfileInfo:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
     [_profileView addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(HideProfileInfo:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [_profileView addGestureRecognizer:swipeRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings:)];
    
    [_profileView.settingsButton addGestureRecognizer:tapRecognizer];
    
    // AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
   //  NSLog(@"%@",appDelegate.user.userName);
    
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.logoutButton = nil;
    [super viewWillDisappear:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.5f;
}

#pragma mark - Table view data source
- (void)reload:(id)sender
{
    //[_activityIndicatorView startAnimating];
    
    /*[Activity publicFeedWithBlock:^(NSArray *activities, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            //NSLog(@"%@",activities);
            _activities = activities;
            [self.myActivities reloadData];
        }
        
        //[_activityIndicatorView stopAnimating];
       
    }];*/
    [self.user userActivitiesWithBlock:^(NSArray *activities, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            //NSLog(@"%@",activities);
            _activities = activities;
            [self.myActivities reloadData];
        }
    }];
    NSLog(@"Loading user_id: %d",self.user.userId);
    
    
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_activities count];
    
}

- (UICanuActivityCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Canu Cell";
    
    Activity *activity= [_activities objectAtIndex:indexPath.row];
    
    UICanuActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UICanuActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier Status:UICanuActivityCellEditable activity:activity];
    }
    
   
    //cell.activity = activity;
    
    cell.textLabel.text = activity.title;
    
    return cell;
}

@end
