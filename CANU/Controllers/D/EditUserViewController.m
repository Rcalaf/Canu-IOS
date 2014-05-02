//
//  EditUserViewController.m
//  CANU
//
//  Created by Roger Calaf on 24/09/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "UICanuTextFieldLine.h"

#import "EditUserViewController.h"
#import "EditUserPasswordViewController.h"
#import "UserManager.h"
#import "UICanuButton.h"
#import "UICanuBottomBar.h"

@interface EditUserViewController () <UITextFieldDelegate>

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UICanuTextFieldLine *userName;
@property (strong, nonatomic) IBOutlet UICanuButton *changePasswordButton;
@property (strong, nonatomic) IBOutlet UICanuTextFieldLine *name;
@property (strong, nonatomic) IBOutlet UICanuTextFieldLine *email;

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.userName) {
        [self.userName textChange:newString];
    } else if (textField == self.name) {
        [self.name textChange:newString];
    } else if (textField == self.email) {
        [self.email textChange:newString];
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.userName isFirstResponder]) {
        [self.name becomeFirstResponder];
    } else if ([self.name isFirstResponder]) {
        [self.email becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.name resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.email resignFirstResponder];
}

- (void)loadView
{
    [super loadView];
    
    self.user = [[UserManager sharedUserManager] currentUser];
    
    self.view.backgroundColor = backgroundColorView;
    
    UILabel *editProfileTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 320, 20)];
    editProfileTitle.text = NSLocalizedString(@"Edit profile", nil);
    editProfileTitle.textColor = UIColorFromRGB(0x2b4b58);
    editProfileTitle.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    editProfileTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:editProfileTitle];
    
    self.name = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 85, 280, 45)];
    self.name.placeholder = NSLocalizedString(@"Full name", nil);
    self.name.text = _user.firstName;
    [self.name setReturnKeyType:UIReturnKeyNext];
    self.name.delegate = self;
    [self.view addSubview:self.name];
    
    self.userName = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 85 + 5 + 45, 280, 45)];
    self.userName.placeholder = NSLocalizedString(@"Username", nil);
    self.userName.text = _user.userName;
    [self.userName setReturnKeyType:UIReturnKeyNext];
    self.userName.delegate = self;
    [self.view addSubview:self.userName];
    
    self.email = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 85 + 5 + 45 + 5 + 45, 280, 45)];
    self.email.placeholder = NSLocalizedString(@"Email", nil);
    self.email.text = _user.email;
    [self.email setReturnKeyType:UIReturnKeyDone];
    self.email.delegate = self;
    [self.view addSubview:self.email];
    
    self.changePasswordButton = [[UICanuButton alloc]initWithFrame:CGRectMake(10, 85 + 5 + 45 + 5 + 45 + 10 + 45, 300, 45) forStyle:UICanuButtonStyleWhiteArrow];
    [self.changePasswordButton setTitle:NSLocalizedString(@"Change your password", nil) forState:UIControlStateNormal];
    [self.changePasswordButton  addTarget:self action:@selector(showEditPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changePasswordButton];
    
    UIImageView *illu = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 91) / 2, 85 + 5 + 45 + 5 + 45 + 10 + 45 + 5 + 45 + 35, 79, 91)];
    illu.image = [UIImage imageNamed:@"D_illu_edit_profile"];
    [self.view addSubview:illu];

    self.toolBar = [[UICanuBottomBar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 45, 320.0, 45)];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    self.saveButton = [[UICanuButton alloc]initWithFrame:CGRectMake(45 + 10, 4, (self.view.frame.size.width - (45 + 10)*2), 37.0) forStyle:UICanuButtonStyleLarge];
    [self.saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [self.saveButton  addTarget:self action:@selector(updateUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:_saveButton];
    
    // Activity Indicator
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.center = CGPointMake(188.5f, 22.5f);
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
