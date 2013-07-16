//
//  UserProfileViewController.m
//  CANU
//
//  Created by Roger Calaf on 23/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ActivitiesViewController.h"
#import "MainViewController.h"
#import "NewActivityViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "Activity.h"
#import "UICanuActivityCell.h"
#import "UIProfileView.h"

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

-(IBAction)createActivity:(id)sender{
    NewActivityViewController *nac = [[NewActivityViewController alloc] init];
    [self presentViewController:nac animated:YES completion:nil];
}

-(IBAction)performLogout:(id)sender
{
    NSLog(@"Logging out!");
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    NSLog(@"session token: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]);
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    
    MainViewController *mvc = [[MainViewController alloc] init];
    //[nvc addChildViewController:mvc];
    appDelegate.window.rootViewController = mvc;
 
    NSLog(@"%@",appDelegate.user.userName);
    
    //[self.navigationController setViewControllers:[NSArray arrayWithObject:[[MainViewController alloc] init]]];
}

- (IBAction)showHideProfileInfo:(id)sender{
    [UIView animateWithDuration:0.3 animations:^(void){
        if (_profileHidden){
            _profileView.frame = CGRectMake(0.0f, 345.0f, 320.0f, 114.0f);
            _profileView.profileImage.hidden = NO;
            
            _myActivities.frame = CGRectMake(10.0f, 10.0f, 300.0f, 325.0f);
        }else{
            _profileView.frame = CGRectMake(0.0f, 440.0f, 320.0f, 114.0f);
            _profileView.profileImage.hidden = YES;
            _myActivities.frame = CGRectMake(10.0f, 10.0f, 300.0f, 420.0f);
        }
    } completion:^(BOOL finished) {
        if (finished){
            if (_profileHidden){
                _profileHidden = NO;
                
            }else{
                _profileHidden = YES;
            }
        }
    }];
}

/*
-(IBAction)showActivities:(id)sender
{
  // [self.navigationController setViewControllers:[NSArray arrayWithObject:[[ActivitiesViewController alloc] init]]];
    [self.navigationController pushViewController:[[ActivitiesViewController alloc] init] animated:YES];
}
*/

-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];
    
    self.myActivities = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 420.0) style:UITableViewStylePlain];
    self.myActivities.dataSource = self;
    self.myActivities.delegate = self;
    
    [self reload:nil];
    [self.view addSubview:self.myActivities];
 
/*    self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.logoutButton.frame = CGRectMake(25.0, 25.0, 200.0, 50.0);
    [self.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [self.view addSubview:self.logoutButton];*/
 
   /* self.activitiesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.activitiesButton.frame = CGRectMake(25.0, 85.0, 200.0, 50.0);
    [self.activitiesButton setTitle:@"Activities" forState:UIControlStateNormal];
    [self.view addSubview:self.activitiesButton];*/
 /*
    self.createActivityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.createActivityButton.frame = CGRectMake(25.0, 145.0, 200.0, 50.0);
    [self.createActivityButton setTitle:@"New Activity" forState:UIControlStateNormal];
    [self.view addSubview:self.createActivityButton];
*/
    
    self.profileView = [[UIProfileView alloc] initWithUser:self.user];   

    [self.view addSubview:_profileView];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.logoutButton addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchDown];
    
    
    //[self.activitiesButton addTarget:self action:@selector(showActivities:) forControlEvents:UIControlEventTouchDown];
    //[self.createActivityButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchDown];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideProfileInfo:)];
     [_profileView addGestureRecognizer:tapRecognizer];
    
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
        cell = [[UICanuActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier activity:activity];
    }
    
   
    //cell.activity = activity;
    
    cell.textLabel.text = activity.title;
    
    return cell;
}

@end
