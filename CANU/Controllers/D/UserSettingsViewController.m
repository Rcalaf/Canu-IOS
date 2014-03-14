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
#import "EditUserViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "UserManager.h"

@interface UserSettingsViewController ()

@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *tutorialButton;
@property (strong, nonatomic) UIButton *privacyPolicyButton;
@property (strong, nonatomic) UIButton *logOut;

@end

@implementation UserSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)performLogout:(id)sender{
    [[UserManager sharedUserManager] logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTutorial:(id)sender{
    TutorialViewController *tutorial = [[TutorialViewController alloc] init];
    [self presentViewController:tutorial animated:NO completion:nil];
}


- (void)showPrivacyPolicy:(id)sender{
    PrivacyPolicyViewController *privacyPolicy = [[PrivacyPolicyViewController alloc] initForTerms:NO];
    [self presentViewController:privacyPolicy animated:NO completion:nil];
}

- (void)editProfile:(id)sender{
    EditUserViewController *editProfile = [[EditUserViewController alloc] init];
    [self presentViewController:editProfile animated:NO completion:nil];
}



-(void)loadView{
    
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];

    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_arrow"]];
    arrow.frame = CGRectMake(253.0f, 0.0f, 47.0f, 47.0f);
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [self.editButton setFrame:CGRectMake(10.0f, 10.0f, 300.0f, 47.0f)];
    [self.editButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    self.editButton.titleEdgeInsets = UIEdgeInsetsMake(0, -200, 0, 0);
    [self.editButton setBackgroundColor:[UIColor whiteColor]];
    [self.editButton  addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton addSubview:arrow];
    [self.view addSubview:_editButton];
    
    UIImageView *tutorialArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_arrow"]];
    tutorialArrow.frame = CGRectMake(253.0f, 0.0f, 47.0f, 47.0f);
    self.tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tutorialButton setTitle:@"Tutorial" forState:UIControlStateNormal];
    [self.tutorialButton setFrame:CGRectMake(10.0f, 67.0f, 300.0f, 47.0f)];
    [self.tutorialButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    self.tutorialButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    self.tutorialButton.titleEdgeInsets = UIEdgeInsetsMake(0, -219, 0, 0);
    [self.tutorialButton setBackgroundColor:[UIColor whiteColor]];
    [self.tutorialButton  addTarget:self action:@selector(showTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [self.tutorialButton addSubview:tutorialArrow];
    [self.view addSubview:_tutorialButton];
    
    UIImageView *privacyArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_arrow"]];
    privacyArrow.frame = CGRectMake(253.0f, 0.0f, 47.0f, 47.0f);
    self.privacyPolicyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.privacyPolicyButton setTitle:@"Our Privacy Policy" forState:UIControlStateNormal];
    [self.privacyPolicyButton setFrame:CGRectMake(10.0f, 124.0f, 300.0f, 47.0f)];
    [self.privacyPolicyButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    self.privacyPolicyButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    self.privacyPolicyButton.titleEdgeInsets = UIEdgeInsetsMake(0, -154, 0, 0);
    [self.privacyPolicyButton setBackgroundColor:[UIColor whiteColor]];
    [self.privacyPolicyButton  addTarget:self action:@selector(showPrivacyPolicy:) forControlEvents:UIControlEventTouchUpInside];
    [self.privacyPolicyButton addSubview:privacyArrow];
    [self.view addSubview:_privacyPolicyButton];
    
    self.logOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.logOut setTitle:@"Sign Out" forState:UIControlStateNormal];
    [self.logOut setFrame:CGRectMake(10.0f, 181.0f, 300.0f, 47.0f)];
    [self.logOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.logOut.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [self.logOut setBackgroundColor:[UIColor colorWithRed:(235.0 / 255.0) green:(95.0 / 255.0) blue:(87.0 / 255.0) alpha: 1]];
    [self.logOut  addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logOut];
    
    
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 57, 320.0, 57.0)];
    self.toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolBar addSubview:_backButton];
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
