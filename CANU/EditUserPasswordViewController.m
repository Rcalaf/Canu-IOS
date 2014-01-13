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

@synthesize user = _user;

@synthesize toolBar = _toolBar;
@synthesize backButton = _backButton;
@synthesize saveButton = _saveButton;

@synthesize password = _password;
@synthesize proxyPassword = _proxyPassword;

@synthesize loadingIndicator = _loadingIndicator;

- (void)operationInProcess:(BOOL)isInProcess
{
    if (isInProcess) {
        [_loadingIndicator startAnimating];
        _saveButton.hidden = YES;
    }else{
        [_loadingIndicator stopAnimating];
        _saveButton.hidden = NO;
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
    _password.rightView = nil;
    _proxyPassword.rightView = nil;
    //NSLog(@" %@ %@",_password.text,_proxyPassword.text);
    if ([_password.text isEqualToString:_proxyPassword.text]) {
    
        [self operationInProcess:YES];
        
        [self.user editUserWithUserName:_user.userName
                           Password:_password.text
                          FirstName:_user.firstName
                           LastName:@""
                              Email:_user.email
                              Block:^(User *user, NSError *error){
                                  NSLog(@"%@",[error localizedRecoverySuggestion]);
                                  if (error && [[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                                      [self.user logOut];
                                  } else {
                                      
                                      if (error && [[error localizedRecoverySuggestion] rangeOfString:@"proxy_password"].location != NSNotFound) {
                                          _proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                      }else{
                                          _proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                      }
                                      if (error && [[error localizedRecoverySuggestion] rangeOfString:@"password"].location != NSNotFound){
                                          _password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                      }else{
                                          _password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
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
        if (!_password.text)  _password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
        _proxyPassword.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
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
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
    
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
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 57, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [_saveButton setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_saveButton setBackgroundColor:[UIColor colorWithRed:(28.0 / 255.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
    [self.saveButton  addTarget:self action:@selector(updatePassword:) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBar addSubview:_saveButton];
    
    // Activity Indicator
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingIndicator.center = CGPointMake(188.5f, 28.5f);
    [_toolBar addSubview:_loadingIndicator];
    
    [_toolBar addSubview:_backButton];
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
