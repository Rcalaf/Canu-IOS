//
//  EditUserPasswordViewController.m
//  CANU
//
//  Created by Roger Calaf on 24/09/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"
#import "UICanuTextField.h"
#import "EditUserPasswordViewController.h"
#import "UserManager.h"


@interface EditUserPasswordViewController () <UITextFieldDelegate>

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *saveButton;

@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UITextField *proxyPassword;

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

- (void)operationInProcess:(BOOL)isInProcess;

@end

@implementation EditUserPasswordViewController

- (void)operationInProcess:(BOOL)isInProcess
{
    if (isInProcess) {
        [self.loadingIndicator startAnimating];
        self.saveButton.hidden = YES;
    }else{
        [self.loadingIndicator stopAnimating];
        self.saveButton.hidden = NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)updatePassword:(id)sender
{
    self.password.rightView = nil;
   self.proxyPassword.rightView = nil;
    //NSLog(@" %@ %@",_password.text,_proxyPassword.text);
    if ([self.password.text isEqualToString:_proxyPassword.text]) {
    
        [self operationInProcess:YES];
        
        [self.user editUserWithUserName:_user.userName Password:_password.text FirstName:_user.firstName LastName:@"" Email:_user.email Block:^(User *user, NSError *error){
                                  NSLog(@"%@",[error localizedRecoverySuggestion]);
                                  if (error && [[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                                      [[UserManager sharedUserManager] logOut];
                                      NSLog(@"editUser Error");
                                  } else {
                                      
                                      if (error && [[error localizedRecoverySuggestion] rangeOfString:@"proxy_password"].location != NSNotFound) {
                                          self.proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                      }else{
                                          self.proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                      }
                                      if (error && [[error localizedRecoverySuggestion] rangeOfString:@"password"].location != NSNotFound){
                                          self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                      }else{
                                          self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                      }
                                  }
                                  
                                 if (user) {
                                      [self dismissViewControllerAnimated:NO completion:nil];
                                      //AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                                      //appDelegate.user = user;
                                      //self.user = user;
                                 }
                                 [self operationInProcess:NO];
                        }];
    } else {
        if (!_password.text)  self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
        self.proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.password isFirstResponder]) {
        [self.proxyPassword becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.password resignFirstResponder];
    [self.proxyPassword resignFirstResponder];
}

- (void)loadView
{
    [super loadView];
    
    self.user = [[UserManager sharedUserManager] currentUser];
    
    self.view.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];
    
    self.password = [[UICanuTextField alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 47.0f)];
    self.password.placeholder = @"New Password";
    self.password.secureTextEntry = YES;
    [self.password setReturnKeyType:UIReturnKeyNext];
    self.password.delegate = self;
    [self.view addSubview:self.password];
    
    self.proxyPassword = [[UICanuTextField alloc] initWithFrame:CGRectMake(10.0f, 67.0f, 300.0f, 47.0f)];
    self.proxyPassword.placeholder = @"Password Confirmation";
    self.proxyPassword.secureTextEntry = YES;
    [self.proxyPassword setReturnKeyType:UIReturnKeyDone];
    self.proxyPassword.delegate = self;
    [self.view addSubview:self.proxyPassword];
    
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 57, 320.0, 57.0)];
    self.toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [self.saveButton setBackgroundColor:[UIColor colorWithRed:(28.0 / 255.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
    [self.saveButton  addTarget:self action:@selector(updatePassword:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolBar addSubview:_saveButton];
    
    // Activity Indicator
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.center = CGPointMake(188.5f, 28.5f);
    [self.toolBar addSubview:_loadingIndicator];
    
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
