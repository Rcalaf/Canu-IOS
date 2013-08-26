//
//  UserProfileViewController.m
//  CANU
//
//  Created by Roger Calaf on 23/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

//#import "UIImageView+AFNetworking.h"

//Custom CANU class import
//#import "UICanuActivityCell.h"
#import "UIProfileView.h"
#import "AppDelegate.h"


//Models class import
#import "User.h"
#import "Activity.h"

//Controllers import
#import "UserProfileViewController.h"
#import "MainViewController.h"
#import "UserSettingsViewController.h"
#import "ActivityTableViewController.h"
//#import "NewActivityViewController.h"
//#import "DetailActivityViewController.h"


@interface UserProfileViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>


//@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *activitiesButton;
@property (strong, nonatomic) IBOutlet UIButton *createActivityButton;

@property (strong, nonatomic) IBOutlet UIProfileView *profileView;
//@property (strong, nonatomic) IBOutlet UITableView *myActivities;
@property (nonatomic) BOOL profileHidden;


//- (void)reload:(id)sender;

@end

@implementation UserProfileViewController/*{
@private
    NSArray *_activities;
}*/

//@synthesize logoutButton = _logoutButton;
@synthesize activitiesButton = _activitiesButton;
@synthesize createActivityButton = _createActivityButton;
@synthesize user = _user;
@synthesize profileHidden = _profileHidden;


@synthesize profileView = _profileView;
//@synthesize myActivities = _myActivities;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
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
        //_myActivities.frame = CGRectMake(0.0f, 0.0f, 320.0f, 325.0f);
    } completion:^(BOOL finished) {
        if (finished){
            _profileHidden = NO;
        }
    }];
}

- (IBAction)HideProfileInfo:(id)sender{
    [UIView animateWithDuration:0.3 animations:^(void){
        _profileView.frame = CGRectMake(0.0f, 440.0f, 320.0f, 114.0f);
       // _myActivities.frame = CGRectMake(0.0f, 0.0f, 320.0f, 420.0f);
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

//User profile ImagePicker
-(IBAction)takePic:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose an existing one",@"Take a picutre", nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [self.user editUserWithProfilePicture:newImage Block:^(User *user, NSError *error) {
        if (!error) {
            self.profileView.profileImage.image = newImage;
            //self.user = user;
            [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
            appDelegate.user = nil;
        }
        // NSLog(@"new pic url: %@",user.profileImageUrl);
        // NSLog(@"app pic url: %@",appDelegate.user.profileImageUrl);
      
    }];
        
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];
    
    ActivityTableViewController *activitiesList = [[ActivityTableViewController alloc] init];
    [self addChildViewController:activitiesList];
    [self.view addSubview:activitiesList.view];
    
    /*self.myActivities = [[UITableView alloc] initWithFrame:CGRectMake(0.0, -10.0, 320.0, 450.0) style:UITableViewStyleGrouped];

    
    self.myActivities.backgroundView = nil;
    self.myActivities.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];

    self.myActivities.dataSource = self;
    self.myActivities.delegate = self;
    [self.myActivities setTransform:CGAffineTransformMakeRotation(M_PI)];
    self.myActivities.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 311.5);
    
    //[self reload:nil];
    [self.view addSubview:self.myActivities];*/
    
    self.profileView = [[UIProfileView alloc] initWithUser:self.user];
    [self.view addSubview:_profileView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.logoutButton addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchDown];
    
    
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
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic:)];
    [_profileView.profileImage addGestureRecognizer:tapRecognizer];
    
    //[self reload:nil];
    
    // AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
   //  NSLog(@"%@",appDelegate.user.userName);
    
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //[self.profileView.profileImage setImageWithURL:_user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    self.profileView.name.text = [NSString stringWithFormat:@"%@ %@",self.user.firstName,self.user.lastName];
    self.profileView.profileImage.image = self.user.profileImage;

   // NSLog(@"user: %u",self.user.userId);
   // [self reload:nil];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    //self.logoutButton = nil;
    [super viewWillDisappear:YES];
    [self performSelector:@selector(HideProfileInfo:) withObject:self];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Table view data source
- (void)reload:(id)sender
{
    //[_activityIndicatorView startAnimating];
    */
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
   /* [self.user userActivitiesWithBlock:^(NSArray *activities, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            //NSLog(@"%@",activities);
            _activities = activities;
            [self.myActivities reloadData];
        }
    }];*/
    //NSLog(@"Loading user_id: %d",self.user.userId);
    
    
    
    
/*}

-(void)triggerCellAction:(id)recognizer
{
    UICanuActivityCell *cell = (UICanuActivityCell *)[[[recognizer view] superview] superview];
    NewActivityViewController *eac;
   // NSLog(@"%u",cell.activity.status);
    
    if (cell.activity.status == UICanuActivityCellGo) {
        [cell.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
               // Activity *a = [activities objectAtIndex:1] ;
                //NSLog(@"activities GO:%@",a.attendeeIds );
                //_activities = activities;
                //[self.myActivities reloadData];
                [self reload:nil];
                
            }
        }];
    }
    if (cell.activity.status == UICanuActivityCellEditable) {
        eac = [[NewActivityViewController alloc] init];
        eac.activity = cell.activity;
        [self presentViewController:eac animated:YES completion:nil];
    }
    
    if (cell.activity.status == UICanuActivityCellToGo) {
        [cell.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                //Activity *a = [activities objectAtIndex:1] ;
                //NSLog(@"activities TOGO:%@",a.attendeeIds );
                //_activities = activities;
                //[self.myActivities reloadData];
                [self reload:nil];
                
            }
        }];
    }
    // Activity *a = [_activities objectAtIndex:1] ;
   // NSLog(@"activities global:%@",a.attendeeIds );
   // [self.myActivities reloadData];
    //NSLog(@"%lu", (unsigned long)cell.activity.activityId);
    
   // ;
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
    //static NSString *CellIdentifier = @"Canu Cell";
    
    Activity *activity= [_activities objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Canu Cell %u",activity.status];
    
    UICanuActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (!cell) {
        cell = [[UICanuActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier activity:activity];
    }else{
        
        cell.activity = activity;
        
        [cell.imageView setImageWithURL:cell.activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        
        cell.textLabel.text = activity.title;
        cell.location.text = activity.locationDescription;
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",activity.user.firstName, activity.user.lastName];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"dd MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        cell.day.text = [dateFormatter stringFromDate:activity.start];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        cell.timeStart.text = [timeFormatter stringFromDate:activity.start];
        cell.timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:activity.end]];
    }
   
    //cell.activity = activity;
    //cell.textLabel.text = activity.title;
    
    //[cell.actionButton addTarget:self action:@selector(triggerCellAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *cellAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerCellAction:)];
    [cell.actionButton addGestureRecognizer:cellAction];
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    DetailActivityViewController *davc = [[DetailActivityViewController alloc] init];
    davc.activity = [_activities objectAtIndex:indexPath.row];
    [self presentViewController:davc animated:YES completion:nil];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0f;
}

*/
@end
