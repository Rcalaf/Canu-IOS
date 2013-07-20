//
//  SignInViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "UserProfileViewController.h"
#import "UICanuNavigationController.h"
#import "ActivitiesFeedViewController.h"
#import "AFCanuAPIClient.h"
#import "UICanuTextField.h"
#import "User.h"

@interface SignInViewController ()

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *toolBar;



- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;

@end

@implementation SignInViewController

@synthesize email = _email;
@synthesize password = _password;
@synthesize backButton = _backButton;
@synthesize loginButton = _loginButton;

@synthesize container = _container;
@synthesize toolBar =  _toolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(IBAction)login:(id)sender
{
    //NSLog(@"Login Logic, AFNetwork, get a token and put inside the UserDefaults...");
    
    if (self.email.text && self.password.text) {
        
        [User logInWithEmail:self.email.text Password:self.password.text Block:^(User *user, NSError *error) {
            if (user){
                AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
                appDelegate.user = user;
                
                NSLog(@"%@",user.token);
                [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:@"accessToken"];
                
                UICanuNavigationController *nvc = [[UICanuNavigationController alloc] init];
                ActivitiesFeedViewController *avc = [[ActivitiesFeedViewController alloc] init];
                //[nvc pushViewController:avc animated:NO];
                [nvc addChildViewController:avc];
                appDelegate.window.rootViewController = nvc;
                
                
               // UserProfileViewController *upvc = [[UserProfileViewController alloc] init];
                
                //[self.navigationController setViewControllers:[NSArray arrayWithObject:upvc]];
            }
        }];
  
    
    }

}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{}];
   // [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signin_bg.png"]];
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(10.0, 298.0, 300.0, 94.5)];
    [_container setBackgroundColor:[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1]];
    
    UIView *userIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 47.0, 47.0)];
    UIView *lockerIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 47.5, 47.0, 47.0)];
    userIconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_username.png"]];
    lockerIconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_password.png"]];
   
    [_container addSubview:userIconView];
    [_container addSubview:lockerIconView];
    
    self.email = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 0.0, 252.5, 47.0)];
    self.email.placeholder = @"Email";
    [self.password setReturnKeyType:UIReturnKeyNext];
    self.email.delegate = self;
    [_container addSubview:self.email];
    
    self.password = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 47.5, 252.5, 47.0)];
    self.password.placeholder = @"Password";
    [self.password setReturnKeyType:UIReturnKeyGo];
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [_container addSubview:self.password];

    [self.view addSubview:_container];
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [_loginButton setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
    
    [_toolBar addSubview:_loginButton];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    
    [_toolBar addSubview:_backButton];
    
    
    [self.view addSubview:_toolBar];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];


    //self.navigationController.navigationBarHidden = NO;
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.placeholder isEqual: @"Password"]) {
        [self login:nil];
    } else {
        [self.password becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.password resignFirstResponder];
    [self.email resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        _container.frame =CGRectMake(10.0, 139.0, _container.frame.size.width, _container.frame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        _container.frame =CGRectMake(10.0, 298.0, _container.frame.size.width, _container.frame.size.height);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"login" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification

                                                  object:nil];
    _toolBar = nil;
    _container = nil;
    _email = nil;
    _password = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
