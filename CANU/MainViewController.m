//
//  MainViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "MainViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getOn;
@property (weak, nonatomic) IBOutlet UIButton *logIn;

@end

@implementation MainViewController

@synthesize getOn = _getOn;
@synthesize logIn = _logIn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goSignUp:(id)sender
{    
    NSLog(@"Go to SignUp");
    [self.navigationController pushViewController:[[SignUpViewController alloc] init] animated:YES];
}

- (IBAction)goSignIn:(id)sender
{
    NSLog(@"Go to SignIN");
    [self.navigationController pushViewController:[[SignInViewController alloc] init] animated:YES];

   // [self performSegueWithIdentifier:@"SignIn" sender:sender];
}

-(void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:(235.0 / 255.0) green:(235.0 / 255.0) blue:(235.0 / 255.0) alpha: 1];
    
    _getOn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_getOn setTitle:@"Get On" forState:UIControlStateNormal];
    [_getOn setFrame:CGRectMake(25.0, 25.0, 200.0, 45.0)];
    [_getOn addTarget:self action:@selector(goSignUp:) forControlEvents:UIControlEventTouchDown];
    
    _logIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_logIn setTitle:@"Log In" forState:UIControlStateNormal];
    [_logIn setFrame:CGRectMake(25.0, 85.0, 200.0, 45.0)];
    [_logIn addTarget:self action:@selector(goSignIn:) forControlEvents:UIControlEventTouchDown];
    
    //UIActivityIndicatorView *
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    [self.view addSubview:_getOn];
    [self.view addSubview:_logIn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
