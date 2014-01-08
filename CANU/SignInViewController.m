//
//  SignInViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"
#import "UICanuNavigationController.h"
#import "ActivitiesFeedViewController.h"
#import "AFCanuAPIClient.h"
#import "UICanuTextField.h"
#import "User.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SignInViewController ()

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *toolBar;

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)operationInProcess:(BOOL)isInProcess;

@end

@implementation SignInViewController

@synthesize email = _email;
@synthesize password = _password;
@synthesize backButton = _backButton;
@synthesize loginButton = _loginButton;

@synthesize container = _container;
@synthesize toolBar =  _toolBar;

@synthesize loadingIndicator = _loadingIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)operationInProcess:(BOOL)isInProcess
{
    if (isInProcess) {
        [_loadingIndicator startAnimating];
        _loginButton.hidden = YES;
    }else{
        [_loadingIndicator stopAnimating];
        _loginButton.hidden = NO;
    }
}

-(IBAction)login:(id)sender
{
    //NSLog(@"Login Logic, AFNetwork, get a token and put inside the UserDefaults...");
    
   // if (self.email.text && self.password.text) {
        [self operationInProcess:YES];
        
        [User logInWithEmail:self.email.text Password:self.password.text Block:^(User *user, NSError *error) {
           
           /*if (error != nil) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                            message:[error localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                return;
            }*/
            
            //NSLog(@"%@",[[error localizedRecoverySuggestion] componentsSeparatedByString:@"\""]);
          
            if ([[error localizedRecoverySuggestion] rangeOfString:@"email"].location != NSNotFound || self.email.text == nil) {
                self.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
            }else{
                self.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
            }
            if ([[error localizedRecoverySuggestion] rangeOfString:@"password"].location != NSNotFound || self.password.text == nil) {
                self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
            }else{
                self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
            }
            
            
            if (user){
                AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                //appDelegate.user = user;
                
                [user updateDeviceToken:appDelegate.device_token Block:^(NSError *error){
                    if (error) {
                        NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                    }
                }];
               
                [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
                
                appDelegate.canuViewController = [[UICanuNavigationController alloc] initWithActivityFeed:appDelegate.feedViewController];
                [appDelegate.canuViewController pushViewController:appDelegate.feedViewController animated:NO];
                appDelegate.window.rootViewController = appDelegate.canuViewController;
                
            }
            [self operationInProcess:NO];
        }];
  
    
 //   }

}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{}];
   // [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void) loadView
{
    [super loadView];
    
    if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hello_bg-568h.png"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hello_bg.png"]];
    }
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(10.0, self.view.frame.size.height - 95 - 10 - 57, 300.0, 94.5)];
    [_container setBackgroundColor:[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1]];
    
    UIView *userIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 47.0, 47.0)];
    UIView *lockerIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 47.5, 47.0, 47.0)];
    userIconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_username.png"]];
    lockerIconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_password.png"]];
   
    [_container addSubview:userIconView];
    [_container addSubview:lockerIconView];
    
    self.email = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 0.0, 252.5, 47.0)];
    self.email.placeholder = @"Email or UserName";
    self.email.keyboardType = UIKeyboardTypeEmailAddress;
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
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 57, 320.0, 57.0)];
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
    
    // Activity Indicator
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingIndicator.center = CGPointMake(188.5f, 28.5f);
    [_toolBar addSubview:_loadingIndicator];
    
    [self.view addSubview:_toolBar];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];


    //self.navigationController.navigationBarHidden = NO;
   
}

-(BOOL)shouldAutorotate
{
    return NO;
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
        _container.frame =CGRectMake(10.0, self.view.frame.size.height - 95 - 10 - 216, _container.frame.size.width, _container.frame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        _container.frame =CGRectMake(10.0, self.view.frame.size.height - 95 - 10 - 57, _container.frame.size.width, _container.frame.size.height);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Sign In"];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    
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
