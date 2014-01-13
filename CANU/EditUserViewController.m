//
//  EditUserViewController.m
//  CANU
//
//  Created by Roger Calaf on 24/09/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "UICanuTextField.h"
#import "AppDelegate.h"

#import "EditUserViewController.h"
#import "EditUserPasswordViewController.h"

@interface EditUserViewController () <UITextFieldDelegate>

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

- (void)operationInProcess:(BOOL)isInProcess;

@end

@implementation EditUserViewController

@synthesize user = _user;

@synthesize toolBar = _toolBar;
@synthesize backButton = _backButton;
@synthesize saveButton = _saveButton;

@synthesize userName = _userName;
@synthesize changePasswordButton = _changePasswordButton;
@synthesize name = _name;
@synthesize email = _email;

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

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)showEditPassword:(id)sender
{
    EditUserPasswordViewController *editPasswordController = [[EditUserPasswordViewController alloc] init];
    [self presentViewController:editPasswordController animated:YES completion:nil];
}

- (IBAction)updateUser:(id)sender
{
    [self operationInProcess:YES];
    [self.user editUserWithUserName:_userName.text
                       Password:nil
                      FirstName:_name.text
                       LastName:@""
                          Email:_email.text
                          Block:^(User *user, NSError *error){
                              //NSLog(@"error: %@",error);
                              if (error && [[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                                  [self.user logOut];
                              } else {
                                  if ((error && [[error localizedRecoverySuggestion] rangeOfString:@"email"].location != NSNotFound) || self.email.text == nil) {
                                      self.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                  }else{
                                      self.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                  }
                                  if ((error && [[error localizedRecoverySuggestion] rangeOfString:@"user_name"].location != NSNotFound) || self.userName.text == nil) {
                                      self.userName.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                  }else{
                                      self.userName.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                  }
                                  if ((error && [[error localizedRecoverySuggestion] rangeOfString:@"first_name"].location != NSNotFound) || self.name.text == nil) {
                                      self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                  }else{
                                      self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                  }
                              }
                              if (user) {
                                  AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  appDelegate.user = user;
                                  self.user = user;
                                  //[self dismissViewControllerAnimated:YES completion:nil];
                                  
                              }
                              [self operationInProcess:NO];
                          }];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userName isFirstResponder]) {
        [self.name becomeFirstResponder];
    } else if ([self.name isFirstResponder]) {
        [self.email becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.name resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.email resignFirstResponder];
}

- (void)loadView
{
    [super loadView];
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.user = appDelegate.user;
    
    self.view.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];
    UIColor *textColor = [UIColor colorWithRed:28.0f/255.0f green:165.0f/255.0f blue:124.0f/255.0f alpha:1.0f];
    
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_username.png"]];
    userImage.frame = CGRectMake(10.0f, 10.0f, 47.0f, 47.0f);
    [self.view addSubview:userImage];
    
    self.userName = [[UICanuTextField alloc] initWithFrame:CGRectMake(57.5f, 10.0f, 252.5f, 47.0f)];
    self.userName.placeholder = @"Username";
    self.userName.text = _user.userName;
    self.userName.textColor = textColor;
    [self.userName setReturnKeyType:UIReturnKeyNext];
    self.userName.delegate = self;
    [self.view addSubview:self.userName];
    
    UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password.png"]];
    passImage.frame = CGRectMake(10.0f, 67.0f, 47.0f, 47.0f);
    
    [self.view addSubview:passImage];
    
    _changePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changePasswordButton setTitle:@"Change Password" forState:UIControlStateNormal];
    [_changePasswordButton setFrame:CGRectMake(57.5f, 67.0f, 252.5f, 47.0f)];
    [_changePasswordButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    _changePasswordButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    _changePasswordButton.titleEdgeInsets = UIEdgeInsetsMake(0, -120, 0, 0);
    [_changePasswordButton setBackgroundColor:[UIColor whiteColor]];
    [_changePasswordButton  addTarget:self action:@selector(showEditPassword:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_arrow"]];
    arrow.frame = CGRectMake(205.5f, 0.0f, 47.0f, 47.0f);
    [_changePasswordButton addSubview:arrow];
    [self.view addSubview:_changePasswordButton];
    
    self.name = [[UICanuTextField alloc] initWithFrame:CGRectMake(10.0f, 124.0f, 300.0f, 47.0f)];
    self.name.placeholder = @"Name";
    self.name.text = _user.firstName;
    [self.name setReturnKeyType:UIReturnKeyNext];
    self.name.textColor = textColor;
    self.name.delegate = self;
    [self.view addSubview:self.name];
    
    self.email = [[UICanuTextField alloc] initWithFrame:CGRectMake(10.0f, 181.0f, 300.0f, 47.0f)];
    self.email.placeholder = @"Email";
    self.email.text = _user.email;
    [self.email setReturnKeyType:UIReturnKeyDone];
    self.email.textColor = textColor;
    self.email.delegate = self;
    [self.view addSubview:self.email];

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
    [self.saveButton  addTarget:self action:@selector(updateUser:) forControlEvents:UIControlEventTouchUpInside];
    
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
