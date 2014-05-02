//
//  UserSettingsViewController.m
//  CANU
//
//  Created by Roger Calaf on 16/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "UserSettingsViewController.h"
#import "ActivitiesFeedViewController.h"
#import "EditUserViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "UICanuBottomBar.h"
#import "UICanuButton.h"

@interface UserSettingsViewController ()

@property (strong, nonatomic) UICanuBottomBar *bottomBar;
@property (strong, nonatomic) UICanuButton *backButton;
@property (strong, nonatomic) UICanuButton *editButton;
@property (strong, nonatomic) UICanuButton *tutorialButton;
@property (strong, nonatomic) UICanuButton *privacyPolicyButton;
@property (strong, nonatomic) UICanuButton *logOut;

@end

@implementation UserSettingsViewController

-(void)performLogout:(id)sender{
    [[UserManager sharedUserManager] logOut];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTutorial:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.feedViewController.activeTutorial = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
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
    self.view.backgroundColor = backgroundColorView;
    
    UIImageView *illu = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2 - 5, (self.view.frame.size.height - 480 ) / 2 + 40, 161, 150)];
    illu.image = [UIImage imageNamed:@"D_illu"];
    [self.view addSubview:illu];
    
    self.editButton = [[UICanuButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 45 - 10 - 45 - 5 - 45 - 5 - 45 - 5 - 45, 300, 45) forStyle:UICanuButtonStyleWhite];
    [self.editButton setTitle:NSLocalizedString(@"Edit Profile", nil) forState:UIControlStateNormal];
    [self.editButton  addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editButton];
    
    self.tutorialButton = [[UICanuButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 45 - 10 - 45 - 5 - 45 - 5 - 45, 300, 45) forStyle:UICanuButtonStyleWhite];
    [self.tutorialButton setTitle:NSLocalizedString(@"Tutorial", nil) forState:UIControlStateNormal];
    [self.tutorialButton  addTarget:self action:@selector(showTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tutorialButton];
    
    self.privacyPolicyButton = [[UICanuButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 45 - 10 - 45 - 5 - 45, 300, 45) forStyle:UICanuButtonStyleWhite];
    [self.privacyPolicyButton setTitle:NSLocalizedString(@"Our Privacy Policy", nil) forState:UIControlStateNormal];
    [self.privacyPolicyButton  addTarget:self action:@selector(showPrivacyPolicy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_privacyPolicyButton];
    
    self.logOut = [[UICanuButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 45 - 10 - 45, 300, 45) forStyle:UICanuButtonStyleWhite];
    [self.logOut setTitle:NSLocalizedString(@"Sign Out", nil) forState:UIControlStateNormal];
    [self.logOut  addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logOut];
    
    self.bottomBar = [[UICanuBottomBar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    self.bottomBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomBar addSubview:_backButton];
    [self.view addSubview:_bottomBar];

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
