//
//  SignUpViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SignUpViewController.h"
#import "AFCanuAPIClient.h"
#import "AppDelegate.h"


@interface SignUpViewController ()

@property (strong,nonatomic) IBOutlet UITextField *userName;
@property (strong,nonatomic) IBOutlet UITextField *password;
@property (strong,nonatomic) IBOutlet UITextField *name;
@property (strong,nonatomic) IBOutlet UITextField *lastName;
@property (strong,nonatomic) IBOutlet UITextField *email;
@property (strong,nonatomic) IBOutlet UIButton *facebookButton;

- (void)sessionStateChanged:(NSNotification*)notification;

@end

@implementation SignUpViewController

@synthesize userName = _userName;
@synthesize password = _password;
@synthesize name = _name;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize facebookButton = _facebookButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userName = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 25.0, 200.0, 25.0)];
        self.userName.borderStyle = UITextBorderStyleRoundedRect;
        self.userName.placeholder = @"Username";
        self.userName.delegate = self;
        [self.view addSubview:self.userName];
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 60.0, 200.0, 25.0)];
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.placeholder = @"Password";
        self.password.secureTextEntry = YES;
        self.password.delegate = self;
        [self.view addSubview:self.password];
        
        self.name = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 95.0, 200.0, 25.0)];
        self.name.borderStyle = UITextBorderStyleRoundedRect;
        self.name.placeholder = @"name";
        self.name.delegate = self;
        [self.view addSubview:self.name];
        
        self.email = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 130.0, 200.0, 25.0)];
        self.email.borderStyle = UITextBorderStyleRoundedRect;
        self.email.placeholder = @"email";
        self.email.delegate = self;
        [self.view addSubview:self.email];
        
        self.facebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.facebookButton addTarget:self action:@selector(authButtonAction:) forControlEvents:UIControlEventTouchDown];
        self.facebookButton.frame = CGRectMake(25.0, 165.0, 200.0, 50.0);
        [self.facebookButton setTitle:@"Link Facebook" forState:UIControlStateNormal];
        [self.view addSubview:self.facebookButton];

        // Custom initialization
    }
    return self;
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.facebookButton setTitle:@"Unlink Facebook" forState:UIControlStateNormal];
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 NSString *userInfo = @"";
                 
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Name: %@\n\n",
                              user.first_name]];
                 self.name.text = user.first_name;
                 
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Last Name: %@\n\n",
                              user.last_name]];
                self.name.text = [self.name.text stringByAppendingFormat:@" %@",user.last_name];
                 
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Email: %@\n\n",
                              [user objectForKey:@"email"]]];
                 self.email.text = [user objectForKey:@"email"];
                 // Display the user info
                // [self authButtonAction:self.authButton];
                 
             }
         }];
    } else {
        [self.facebookButton setTitle:@"Link Facebook" forState:UIControlStateNormal];
    }
}

- (IBAction)authButtonAction:(id)sender {
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        NSLog(@"Clossing session");
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}

- (IBAction)performSingUp:(id)sender
{
    /*
    NSString *alertMessage = @"";
    if([self.name.text isEqualToString: @"name"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                         self.name.text]];
    }
    if([self.email.text isEqualToString: @"email"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                         self.email.text]];
    }
    if([self.userName.text isEqualToString: @"user name"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                         self.userName.text]];
    }
    if([self.password.text isEqualToString: @"password"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                        self.password.text]];
    }
    if(![alertMessage isEqualToString:@""]){
        UIAlertView *signInVerificationErrors = [[UIAlertView alloc] initWithTitle:@"Sign in Verification" message:alertMessage delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [signInVerificationErrors show];
    }*/
    
    
    //Another userName existance verification
    NSArray *objectsArray = [NSArray arrayWithObjects:self.userName.text,self.password.text,self.name.text,self.email.text,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"username",@"password",@"first_name",@"email",nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    
    [[AFCanuAPIClient sharedClient] postPath:@"users/" parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         NSLog(@"%@",operation);
                                         NSLog(@"%@",JSON);
                                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //NSLog(@"%@",operation);
                                         NSLog(@"%@",error);
                                     }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:(235.0 / 255.0) green:(235.0 / 255.0) blue:(235.0 / 255.0) alpha: 1];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"sign up" style:UIBarButtonItemStyleBordered target:self action:@selector(performSingUp:)];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
