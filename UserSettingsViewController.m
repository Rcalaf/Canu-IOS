//
//  UserSettingsViewController.m
//  CANU
//
//  Created by Roger Calaf on 16/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "UserSettingsViewController.h"
#import "TutorialViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface UserSettingsViewController ()

@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *tutorialButton;
@property (strong, nonatomic) UIButton *privacyPolicyButton;
@property (strong, nonatomic) UIButton *logOut;

@end

@implementation UserSettingsViewController

@synthesize toolBar = _toolBar;
@synthesize backButton = _backButton;
@synthesize tutorialButton = _tutorialButton;
@synthesize privacyPolicyButton = _privacyPolicyButton;
@synthesize logOut = _logOut;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)performLogout:(id)sender
{

#warning remove the notifications before log out
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.user = nil;

    MainViewController *mvc = [[MainViewController alloc] init];
    appDelegate.window.rootViewController = mvc;
    
    //NSLog(@"%@",appDelegate.user.userName);
    
    //[self.navigationController setViewControllers:[NSArray arrayWithObject:[[MainViewController alloc] init]]];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showTutorial:(id)sender
{
    TutorialViewController *tutorial = [[TutorialViewController alloc] init];
    [self presentViewController:tutorial animated:YES completion:nil];
}

- (IBAction)showPrivacyPolicy:(id)sender
{
    PrivacyPolicyViewController *privacyPolicy = [[PrivacyPolicyViewController alloc] init];
    [self presentViewController:privacyPolicy animated:NO completion:nil];
}



-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];
 
    
    _logOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logOut setTitle:@"Sign Out" forState:UIControlStateNormal];
    [_logOut setFrame:CGRectMake(10.0f, 67.0f, 300.0f, 47.0f)];
    [_logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _logOut.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_logOut setBackgroundColor:[UIColor colorWithRed:(235.0 / 255.0) green:(95.0 / 255.0) blue:(87.0 / 255.0) alpha: 1]];
    [_logOut  addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_logOut];
    
    _tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tutorialButton setTitle:@"Tutorial" forState:UIControlStateNormal];
    [_tutorialButton setFrame:CGRectMake(10.0f, 10.0f, 300.0f, 47.0f)];
    [_tutorialButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    _tutorialButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_tutorialButton setBackgroundColor:[UIColor whiteColor]];
    [_tutorialButton  addTarget:self action:@selector(showTutorial:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_tutorialButton];
    
    _privacyPolicyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_privacyPolicyButton setTitle:@"Our Privacy Policy" forState:UIControlStateNormal];
    [_privacyPolicyButton setFrame:CGRectMake(10.0f, 124.0f, 300.0f, 47.0f)];
    [_privacyPolicyButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    _privacyPolicyButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_privacyPolicyButton setBackgroundColor:[UIColor whiteColor]];
    [_privacyPolicyButton  addTarget:self action:@selector(showPrivacyPolicy:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_privacyPolicyButton];
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5 + KIphone5Margin, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    
    [_toolBar addSubview:_backButton];
    [self.view addSubview:_toolBar];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
