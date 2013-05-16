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
#import "UICanuTextField.h"

@interface SignInViewController ()

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;

@end

@implementation SignInViewController

@synthesize username = _username;
@synthesize password = _password;
__strong UIView *_container;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"Should Return Editing");
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"An event occure");
}

-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"signin_bg.png"]];
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(10.0, 298.0, 300.0, 94.5)];
    [_container setBackgroundColor:[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1]];
    
    UIView *userIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 47.0, 47.0)];
    UIView *lockerIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 47.5, 47.0, 47.0)];
    userIconView.backgroundColor = [UIColor whiteColor];
    lockerIconView.backgroundColor = [UIColor whiteColor];
   
    [_container addSubview:userIconView];
    [_container addSubview:lockerIconView];
    
    self.username = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 0.0, 252.5, 47.0)];
    self.username.placeholder = @"Username";
    self.username.delegate = self;
    [_container addSubview:self.username];
    
    self.password = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 47.5, 252.5, 47.0)];
    self.password.placeholder = @"Password";
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [_container addSubview:self.password];

    [self.view addSubview:_container];

    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //self.navigationController.navigationBarHidden = NO;
   
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"login" style:UIBarButtonItemStyleBordered target:self action:@selector(login:)];
    
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
    _container = nil;
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
