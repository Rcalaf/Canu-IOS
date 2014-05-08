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
#import "UICanuTextFieldLine.h"
#import "User.h"
#import "UICanuButton.h"
#import "MainViewController.h"
#import "UserManager.h"
#import "AlertViewController.h"
#import "UICanuBottomBar.h"
#import "CheckPhoneNumberViewController.h"
#import "ResetPassword.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SignInViewController () <CheckPhoneNumberViewControllerDelegate>

@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIView *wrapper;
@property (nonatomic) UIView *container;
@property (nonatomic) UICanuBottomBar *bottomBar;
@property (nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) UICanuTextFieldLine *userName;
@property (nonatomic) UICanuTextFieldLine *password;
@property (nonatomic) UICanuButton *buttonAction;
@property (strong, nonatomic) CheckPhoneNumberViewController *checkPhoneNumberViewController;
@property (strong, nonatomic) ResetPassword *resetPassword;

@end

@implementation SignInViewController

- (void)loadView{
    
    [super loadView];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, result.width, result.height)];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_wrapper];
    
    self.container = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185)];
    [self.wrapper addSubview:self.container];
    
    self.bottomBar = [[UICanuBottomBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    [self.wrapper addSubview:self.bottomBar];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(managerBack) forControlEvents:UIControlEventTouchDown];
    [self.bottomBar  addSubview:self.backButton];
    
    self.buttonAction = [[UICanuButton alloc]initWithFrame:CGRectMake(45 + 10, 4, (self.view.frame.size.width - (45 + 10)*2), 37.0) forStyle:UICanuButtonStyleLarge];
    [self.buttonAction setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    [self.buttonAction addTarget:self action:@selector(managerActionButton) forControlEvents:UIControlEventTouchDown];
    [self.bottomBar  addSubview:_buttonAction];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.frame = CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0);
    [self.bottomBar  addSubview:_loadingIndicator];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    title1.text = NSLocalizedString(@"Welcome Back", nil);
    title1.textAlignment = NSTextAlignmentCenter;
    title1.backgroundColor = [UIColor clearColor];
    title1.textColor = UIColorFromRGB(0x2b4b58);
    title1.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [self.container addSubview:title1];
    
    UIButton *btnForgotPassword = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 280, 30)];
    [btnForgotPassword addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:btnForgotPassword];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Forgot password", nil)];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    UILabel *forgotLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
    forgotLabel.attributedText = attributeString;
    forgotLabel.textAlignment = NSTextAlignmentCenter;
    forgotLabel.textColor = UIColorFromRGB(0x829096);
    forgotLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    forgotLabel.backgroundColor = [UIColor clearColor];
    [btnForgotPassword addSubview:forgotLabel];
    
    self.userName = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 80, 280, 45)];
    self.userName.placeholder = NSLocalizedString(@"Username", nil);
    self.userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.userName setReturnKeyType:UIReturnKeyNext];
    self.userName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userName.delegate = self;
    [self.container addSubview:self.userName];
    
    self.password = [[UICanuTextFieldLine alloc] initWithFrame:CGRectMake(20, 125, 280, 45)];
    self.password.placeholder = NSLocalizedString(@"Password", nil);
    [self.password setReturnKeyType:UIReturnKeyGo];
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [self.container addSubview:self.password];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.userName becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(0, - 216, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
	
}

- (void)managerActionButton{
    
    if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewChooseCountry) {
        [self.checkPhoneNumberViewController selectCountry];
    } else if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewPhoneNumber) {
        [self.checkPhoneNumberViewController checkPhoneNumber];
    } else if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewPhoneCode) {
        [self.checkPhoneNumberViewController checkPhoneCode];
    } else if (self.resetPassword) {
        [self.resetPassword updatePasswordBlock:^(User *user) {
            [User logInWithEmail:user.userName Password:self.resetPassword.password.text Block:^(User *user, NSError *error) {
                if (user){
                    
                    [self log:user];
                    
                } else {
                    NSLog(@"Error proccess");
                }
            }];
        }];
    } else {
        [self login];
    }
    
}

- (void)managerBack{
    
    if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewChooseCountry) {
        [self.checkPhoneNumberViewController hiddenPickCountryCode];
    } else if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewPhoneCode) {
        [self.checkPhoneNumberViewController goBackPhoneNumber];
    } else if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewPhoneNumber) {
        [self backToSignIn];
    } else if (self.resetPassword) {
        [self backToSignIn];
    } else {
        [self goToHome];
    }
    
}

-(void)login{
    
    [self.loadingIndicator startAnimating];
    self.buttonAction.hidden = YES;
    
    [User logInWithEmail:self.userName.text Password:self.password.text Block:^(User *user, NSError *error) {
    
        if (error) {
            if ([[error localizedRecoverySuggestion] rangeOfString:@"email"].location == NSNotFound) {
                self.userName.valueValide = YES;
            } else {
                self.userName.valueValide = NO;
            }
            if ([[error localizedRecoverySuggestion] rangeOfString:@"password"].location == NSNotFound) {
                self.password.valueValide = YES;
            } else {
                self.password.valueValide = NO;
            }
        } else {
            self.userName.valueValide = YES;
            self.password.valueValide = YES;
        }
        
        if (user){
            
            [self log:user];
            
        }
        
        [self.loadingIndicator stopAnimating];
        self.buttonAction.hidden = NO;
        
    }];
    
}

- (void)log:(User *)user{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [user updateDeviceToken:appDelegate.device_token Block:^(NSError *error){
        if (error) {
            NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
        }
    }];
    
    [[UserManager sharedUserManager] logIn:user];
    
    [self.delegate signInGoToFeed];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.alpha = 0;
    } completion:^(BOOL finished) {
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:@"&uid" value:[NSString stringWithFormat:@"%lu",(unsigned long)user.userId]];
        
        if (user.phoneIsVerified) {
            NSLog(@"User Active");
            appDelegate.canuViewController = [[UICanuNavigationController alloc] initWithActivityFeed:appDelegate.feedViewController];
            [appDelegate.canuViewController pushViewController:appDelegate.feedViewController animated:NO];
            appDelegate.window.rootViewController = appDelegate.canuViewController;
            
            UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            if (types & UIRemoteNotificationTypeAlert){
                
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
                
            } else {
                
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                
                AlertViewController *alert = [[AlertViewController alloc]init];
                alert.canuAlertViewType = CANUAlertViewPopIn;
                alert.canuError = CANUErrorPushNotDetermined;
                
                [appDelegate.window addSubview:alert.view];
                [appDelegate.window.rootViewController addChildViewController:alert];
                
            }
            
        }else{
            NSLog(@"User Not Active");
            MainViewController *loginViewController = [[MainViewController alloc] init];
            loginViewController.isPhoneCheck = YES;
            appDelegate.window.rootViewController = loginViewController;
        }
        
    }];
}

- (void)goToHome{
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        [self.delegate signInGoBackHome];
    }];
    
}

- (void)forgotPassword{
    
    [self.buttonAction setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
    
    self.checkPhoneNumberViewController = [[CheckPhoneNumberViewController alloc]initForResetPassword];
    self.checkPhoneNumberViewController.delegate = self;
    self.checkPhoneNumberViewController.nextButton = _buttonAction;
    self.checkPhoneNumberViewController.backButton = _backButton;
    [self addChildViewController:_checkPhoneNumberViewController];
    [self.view addSubview:_checkPhoneNumberViewController.view];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.checkPhoneNumberViewController.view.frame = CGRectMake(0, _checkPhoneNumberViewController.view.frame.origin.y, _checkPhoneNumberViewController.view.frame.size.width, _checkPhoneNumberViewController.view.frame.size.height);
        self.container.frame = CGRectMake( -320, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)backToSignIn{
    
    [self.buttonAction setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    
    [self.userName becomeFirstResponder];
    
    [UIView animateWithDuration:0.4 animations:^{
        if (self.checkPhoneNumberViewController) {
            self.checkPhoneNumberViewController.view.frame = CGRectMake(320, _checkPhoneNumberViewController.view.frame.origin.y, _checkPhoneNumberViewController.view.frame.size.width, _checkPhoneNumberViewController.view.frame.size.height);
        } else {
            self.resetPassword.frame = CGRectMake(320, 0, 320,  self.view.frame.size.height - 216 - 45);
        }
        self.container.frame = CGRectMake( 0, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185);
    } completion:^(BOOL finished) {
        if (self.checkPhoneNumberViewController) {
            [self.checkPhoneNumberViewController willMoveToParentViewController:nil];
            [self.checkPhoneNumberViewController.view removeFromSuperview];
            [self.checkPhoneNumberViewController removeFromParentViewController];
            self.checkPhoneNumberViewController = nil;
        } else {
            [self.resetPassword removeFromSuperview];
            self.resetPassword = nil;
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _userName) {
        [self.userName resignFirstResponder];
        [self.password becomeFirstResponder];
    }else if (textField == _password){
        [self login];
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.userName) {
        [self.userName textChange:newString];
    } else if (textField == self.password) {
        [self.password textChange:newString];
    }
    
    return YES;
    
}

#pragma mark - CheckPhoneNumberViewControllerDelegate

- (void)goToResetPasswordTo:(User *)user{
    
    [self.buttonAction setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    
    self.resetPassword = [[ResetPassword alloc]initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height - 216 - 45) AndUser:user];
    [self.view addSubview:_resetPassword];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.checkPhoneNumberViewController.view.frame = CGRectMake(-320, _checkPhoneNumberViewController.view.frame.origin.y, _checkPhoneNumberViewController.view.frame.size.width, _checkPhoneNumberViewController.view.frame.size.height);
        self.resetPassword.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 216 - 45);
    } completion:^(BOOL finished) {
        
        [self.checkPhoneNumberViewController willMoveToParentViewController:nil];
        [self.checkPhoneNumberViewController.view removeFromSuperview];
        [self.checkPhoneNumberViewController removeFromParentViewController];
        self.checkPhoneNumberViewController = nil;
    }];
    
}

- (void)viewDidUnload{

    _password = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

@end
