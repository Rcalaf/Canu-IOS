//
//  SignInViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "SignInViewController.h"
#import "UserProfileViewController.h"
#import "AFCanuAPIClient.h"

@interface SignInViewController ()

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@end

@implementation SignInViewController

@synthesize username = _username;
@synthesize password = _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.username = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 25.0, 200.0, 25.0)];
        self.username.borderStyle = UITextBorderStyleRoundedRect;
        self.username.placeholder = @"USERNAME";
        self.username.delegate = self;
        [self.view addSubview:self.username];
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 60.0, 200.0, 25.0)];
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.placeholder = @"PASSWORD";
        self.password.secureTextEntry = YES;
        self.password.delegate = self;
        [self.view addSubview:self.password];
    }
    return self;
}

-(IBAction)login:(id)sender
{
    NSLog(@"Login Logic, AFNetwork, get a token and put inside the UserDefaults...");
    
    if (self.username.text && self.password.text) {
    
    NSArray *objectsArray = [NSArray arrayWithObjects:self.username.text,self.password.text,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"username",@"password",nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
   [[AFCanuAPIClient sharedClient] postPath:@"api-token-auth/" parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         //NSLog(@"%@",operation);
                                         NSLog(@"%@",[JSON valueForKey:@"token"]);
                                         [[NSUserDefaults standardUserDefaults] setObject:[JSON valueForKey:@"token"] forKey:@"token"];
                                         UserProfileViewController *upvc = [[UserProfileViewController alloc] init];
                                         [self.navigationController setViewControllers:[NSArray arrayWithObject:upvc]];
                                         
                                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //NSLog(@"%@",operation);
                                         //NSLog(@"%@",error);
                                         NSLog(@"Error");
                                     }];
    }

}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // NSLog(@"Should Return Editing");
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"Should Return Editing");
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"login" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    _username = nil;
    _password = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
