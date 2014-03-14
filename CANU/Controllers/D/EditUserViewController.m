//
//  EditUserViewController.m
//  CANU
//
//  Created by Roger Calaf on 24/09/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "UICanuTextField.h"

#import "EditUserViewController.h"
#import "EditUserPasswordViewController.h"
#import "UserManager.h"

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

- (void)showEditPassword:(id)sender
{
    EditUserPasswordViewController *editPasswordController = [[EditUserPasswordViewController alloc] init];
    [self presentViewController:editPasswordController animated:YES completion:nil];
}

- (void)updateUser:(id)sender
{
    [self operationInProcess:YES];
    [self.user editUserWithUserName:_userName.text
                       Password:nil
                      FirstName:self.name.text
                       LastName:@""
                          Email:self.email.text
                          Block:^(User *user, NSError *error){
                              //NSLog(@"error: %@",error);
                              if (error && [[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                                  
                                  [[UserManager sharedUserManager] logOut];
                                  
                                  NSLog(@"EditUser Error");
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
                                  
                                  [[UserManager sharedUserManager] updateUser:user];
                                  self.user = user;
                                  
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
    
    self.user = [[UserManager sharedUserManager] currentUser];
    
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
    
    self.changePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changePasswordButton setTitle:@"Change Password" forState:UIControlStateNormal];
    [self.changePasswordButton setFrame:CGRectMake(57.5f, 67.0f, 252.5f, 47.0f)];
    [self.changePasswordButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    self.changePasswordButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    self.changePasswordButton.titleEdgeInsets = UIEdgeInsetsMake(0, -120, 0, 0);
    [self.changePasswordButton setBackgroundColor:[UIColor whiteColor]];
    [self.changePasswordButton  addTarget:self action:@selector(showEditPassword:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_arrow"]];
    arrow.frame = CGRectMake(205.5f, 0.0f, 47.0f, 47.0f);
    [self.changePasswordButton addSubview:arrow];
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
    [self.saveButton  addTarget:self action:@selector(updateUser:) forControlEvents:UIControlEventTouchUpInside];
    
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
