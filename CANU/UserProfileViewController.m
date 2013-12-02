//
//  UserProfileViewController.m
//  CANU
//
//  Created by Roger Calaf on 23/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AFCanuAPIClient.h"
#import "UIImageView+AFNetworking.h"

//Custom CANU class import
#import "UIProfileView.h"
#import "UICanuNavigationController.h" 


//Models class import
#import "User.h"
#import "Activity.h"

//Controllers import
#import "AppDelegate.h"
#import "UserProfileViewController.h"
#import "UserSettingsViewController.h"
#import "ActivityTableViewController.h"



@interface UserProfileViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>


//@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *activitiesButton;
@property (strong, nonatomic) IBOutlet UIButton *createActivityButton;

@property (strong, nonatomic) IBOutlet UIProfileView *profileView;
//@property (strong, nonatomic) IBOutlet UITableView *myActivities;
@property (nonatomic) BOOL profileHidden;


//- (void)reload:(id)sender;

@end

@implementation UserProfileViewController

@synthesize activitiesButton = _activitiesButton;
@synthesize createActivityButton = _createActivityButton;
@synthesize user = _user;

@synthesize profileHidden = _profileHidden;
@synthesize profileView = _profileView;

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


- (void)showHideProfile:(id)sender
{
    if (_profileHidden) {
        [UIView animateWithDuration:0.3 animations:^(void){
            _profileView.frame = CGRectMake(0.0f, 345.0f + KIphone5Margin, 320.0f, 114.0f);
            [_profileView hideComponents:NO];
            [self.view insertSubview:_profileView.mask belowSubview:_profileView];
        } completion:^(BOOL finished) {
            if (finished){
                //self.view.userInteractionEnabled = NO;
                _profileHidden = NO;
                //[(UICanuNavigationController *)self.navigationController controlFadeShow];
            }
        }];
   
    }else{
        [UIView animateWithDuration:0.3 animations:^(void){
            _profileView.frame = CGRectMake(0.0f, 460.0f + KIphone5Margin, 320.0f, 114.0f);
        } completion:^(BOOL finished) {
            if (finished){
                //self.view.userInteractionEnabled = YES;
                [_profileView.mask removeFromSuperview];
                [_profileView hideComponents:YES];
                _profileHidden = YES;
               // [(UICanuNavigationController *)self.navigationController controlFadeShow];
            }
        }];
    }
}

- (IBAction)showSettings:(id)sender
{
    UserSettingsViewController *us = [[UserSettingsViewController alloc] init];
    [self presentViewController:us animated:YES completion:nil];
}

//User profile ImagePicker
-(IBAction)takePic:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose an existing one",@"Take a picture", nil];
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
    
    [self.user editUserProfilePicture:newImage Block:^(User *user, NSError *error) {
        if (!error) {
            self.profileView.profileImage.image = newImage;
            //self.user = user;
            [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
            appDelegate.user = nil;
        }
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
    
    self.profileView = [[UIProfileView alloc] initWithUser:self.user];
    [self.view addSubview:_profileView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.logoutButton addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchDown];
    
    
    //[self.activitiesButton addTarget:self action:@selector(showActivities:) forControlEvents:UIControlEventTouchDown];
    //[self.createActivityButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchDown];
    
    /*UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showProfileInfo:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
     [_profileView addGestureRecognizer:swipeRecognizer];*/
    
    /*swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(HideProfileInfo:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [_profileView addGestureRecognizer:swipeRecognizer];*/
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings:)];
    [_profileView.settingsButton addGestureRecognizer:tapRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic:)];
    [_profileView.profileImage addGestureRecognizer:tapRecognizer];

    
    // [self reload:nil];
    
    // AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    // NSLog(@"%@",appDelegate.user.userName);
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
 
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
    //[self.profileView.profileImage setImageWithURL:_user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    self.profileView.name.text = [NSString stringWithFormat:@"%@",self.user.firstName];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,self.user.profileImageUrl]];
    [self.profileView.profileImage  setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    
   // self.profileView.profileImage.image = self.user.profileImage;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideProfile:)];
    //[_profileView addGestureRecognizer:tapRecognizer];
    
    UICanuNavigationController *navController = (UICanuNavigationController *)self.navigationController;
    [navController.control addGestureRecognizer:tapRecognizer];
    navController.control.hidden = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    //self.logoutButton = nil;
    [super viewWillDisappear:YES];
    if (!_profileHidden) [self performSelector:@selector(showHideProfile:) withObject:self];
    UICanuNavigationController *navController = (UICanuNavigationController *)self.navigationController;
    [navController.control removeGestureRecognizer:[navController.control.gestureRecognizers lastObject]];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
