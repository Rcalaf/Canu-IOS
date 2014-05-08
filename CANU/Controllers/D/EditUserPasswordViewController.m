//
//  EditUserPasswordViewController.m
//  CANU
//
//  Created by Roger Calaf on 24/09/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"
#import "EditUserPasswordViewController.h"
#import "UserManager.h"
#import "UICanuButton.h"
#import "UICanuButton.h"
#import "UICanuBottomBar.h"
#import "UICanuTextFieldLine.h"

@interface EditUserPasswordViewController () <UITextFieldDelegate>

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) UICanuBottomBar *toolBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UICanuButton *saveButton;

@property (strong, nonatomic) UICanuTextFieldLine *password;
@property (strong, nonatomic) UICanuTextFieldLine *proxyPassword;

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

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)updatePassword:(id)sender
{
    self.password.rightView = nil;
   self.proxyPassword.rightView = nil;
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.password) {
        [self.password textChange:newString];
    } else if (textField == self.proxyPassword) {
        [self.proxyPassword textChange:newString];
    }
    
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
    
    UILabel *editProfileTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 320, 20)];
    editProfileTitle.text = NSLocalizedString(@"Edit your password", nil);
    editProfileTitle.textColor = UIColorFromRGB(0x2b4b58);
    editProfileTitle.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    editProfileTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:editProfileTitle];
    
    self.user = [[UserManager sharedUserManager] currentUser];
    
    self.view.backgroundColor = backgroundColorView;
    
    self.password = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 85, 280, 45)];
    self.password.placeholder = NSLocalizedString(@"New Password", nil);
    self.password.secureTextEntry = YES;
    [self.password setReturnKeyType:UIReturnKeyNext];
    self.password.delegate = self;
    [self.view addSubview:self.password];
    
    self.proxyPassword = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 85 + 5 + 45, 280, 45)];
    self.proxyPassword.placeholder = NSLocalizedString(@"Password Confirmation", nil);
    self.proxyPassword.secureTextEntry = YES;
    [self.proxyPassword setReturnKeyType:UIReturnKeyDone];
    self.proxyPassword.delegate = self;
    [self.view addSubview:self.proxyPassword];
    
    UIImageView *illu = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 91) / 2, 85 + 5 + 45 + 5 + 45 + 35, 79, 91)];
    illu.image = [UIImage imageNamed:@"D_illu_edit_profile"];
    [self.view addSubview:illu];
    
    self.toolBar = [[UICanuBottomBar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 45, 320.0, 45)];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:_backButton];
    
    self.saveButton = [[UICanuButton alloc]initWithFrame:CGRectMake(45 + 10, 4, (self.view.frame.size.width - (45 + 10)*2), 37.0) forStyle:UICanuButtonStyleLarge];
    [self.saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [self.saveButton  addTarget:self action:@selector(updatePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:_saveButton];
    
    // Activity Indicator
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.center = CGPointMake(188.5f, 28.5f);
    [self.toolBar addSubview:_loadingIndicator];
    
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
