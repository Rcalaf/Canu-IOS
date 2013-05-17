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

@interface UserProfileViewController ()

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *activitiesButton;

@end

@implementation UserProfileViewController

@synthesize logoutButton = _logoutButton;
@synthesize activitiesButton = _activitiesButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
  
    }
    return self;
}

-(IBAction)performLogout:(id)sender
{
    NSLog(@"Logging out!");
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:[[MainViewController alloc] init]]];

    
    
}

-(IBAction)showActivities:(id)sender
{
  // [self.navigationController setViewControllers:[NSArray arrayWithObject:[[ActivitiesViewController alloc] init]]];
    [self.navigationController pushViewController:[[ActivitiesViewController alloc] init] animated:YES];
}

-(void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:(235.0 / 255.0) green:(235.0 / 255.0) blue:(235.0 / 255.0) alpha: 1];
 
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.logoutButton addTarget:self action:@selector(performLogout:) forControlEvents:UIControlEventTouchDown];
    self.logoutButton.frame = CGRectMake(25.0, 25.0, 200.0, 50.0);
    [self.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [self.view addSubview:self.logoutButton];
 
    self.activitiesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.activitiesButton addTarget:self action:@selector(showActivities:) forControlEvents:UIControlEventTouchDown];
    self.activitiesButton.frame = CGRectMake(25.0, 85.0, 200.0, 50.0);
    [self.activitiesButton setTitle:@"Activities" forState:UIControlStateNormal];
    [self.view addSubview:self.activitiesButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

@end
