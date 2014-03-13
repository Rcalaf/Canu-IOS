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
#import "UICanuTextField.h"
#import "TTTAttributedLabel.h"
#import "User.h"
#import "UICanuButtonSignBottomBar.h"
#import "MainViewController.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SignInViewController ()

@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIView *wrapper;
@property (nonatomic) UIView *container;
@property (nonatomic) UIView *resetContainer;
@property (nonatomic) UIView *bottomBar;
@property (nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) UICanuTextField *userName;
@property (nonatomic) UICanuTextField *password;
@property (nonatomic) UICanuButtonSignBottomBar *buttonAction;

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
    
    self.bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 57, self.view.frame.size.width, 57)];
    self.bottomBar .backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.wrapper addSubview:self.bottomBar];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
    [self.bottomBar  addSubview:self.backButton];
    
    self.buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0) andBlue:YES];
    [self.buttonAction setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    [self.buttonAction addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    [self.bottomBar  addSubview:_buttonAction];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.frame = CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0);
    [self.bottomBar  addSubview:_loadingIndicator];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    title1.text = NSLocalizedString(@"Welcome Back", nil);
    title1.textAlignment = NSTextAlignmentCenter;
    title1.backgroundColor = [UIColor clearColor];
    title1.textColor = UIColorFromRGB(0x1ca6c3);
    title1.font = [UIFont fontWithName:@"Lato-Bold" size:24];
    [self.container addSubview:title1];
    
//    UITapGestureRecognizer *tapForgotPassword = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgotPassword)];
//    
//    TTTAttributedLabel *labelForgotPassword = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 50, 320, 20)];
//    labelForgotPassword.text = NSLocalizedString(@"Forgot password", nil);
//    labelForgotPassword.textColor = UIColorFromRGB(0x1ca6c3);
//    labelForgotPassword.font = [UIFont fontWithName:@"Lato-Regular" size:14];
//    labelForgotPassword.textAlignment = NSTextAlignmentCenter;
//    labelForgotPassword.backgroundColor = [UIColor clearColor];
//    [labelForgotPassword addGestureRecognizer:tapForgotPassword];
//    [self.container addSubview:labelForgotPassword];
//    
//    [labelForgotPassword setText:labelForgotPassword.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        
//        NSRange termsRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Forgot password", nil) options:NSCaseInsensitiveSearch];
//        
//        [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:termsRange];
//        
//        return mutableAttributedString;
//        
//    }];
    
    UIImageView *iconeUsername = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 47, 47)];
    iconeUsername.image = [UIImage imageNamed:@"icon_username"];
    [self.container addSubview:iconeUsername];
    
    self.userName = [[UICanuTextField alloc] initWithFrame:CGRectMake(57.5, 80, 252.5, 47.0)];
    self.userName.placeholder = NSLocalizedString(@"Username", nil);
    self.userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.userName setReturnKeyType:UIReturnKeyNext];
    self.userName.delegate = self;
    [self.container addSubview:self.userName];
    
    UIImageView *iconePassword = [[UIImageView alloc]initWithFrame:CGRectMake(10, 128, 47, 47)];
    iconePassword.image = [UIImage imageNamed:@"icon_password"];
    [self.container addSubview:iconePassword];
    
    self.password = [[UICanuTextField alloc] initWithFrame:CGRectMake(57.5, 128, 252.5, 47.0)];
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
            
            [self.userName resignFirstResponder];
            [self.password resignFirstResponder];
            
            AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [user updateDeviceToken:appDelegate.device_token Block:^(NSError *error){
                if (error) {
                    NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                }
            }];
            
            [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
            
            [self.delegate signInGoToFeed];
            
            [UIView animateWithDuration:0.4 animations:^{
                self.wrapper.alpha = 0;
            } completion:^(BOOL finished) {
                
                if (user.phoneIsVerified) {
                    NSLog(@"User Active");
                    appDelegate.canuViewController = [[UICanuNavigationController alloc] initWithActivityFeed:appDelegate.feedViewController];
                    [appDelegate.canuViewController pushViewController:appDelegate.feedViewController animated:NO];
                    appDelegate.window.rootViewController = appDelegate.canuViewController;
                }else{
                    NSLog(@"User Not Active");
                    MainViewController *loginViewController = [[MainViewController alloc] init];
                    loginViewController.isPhoneCheck = YES;
                    appDelegate.window.rootViewController = loginViewController;
                }
                
            }];
            
        }
        
        [self.loadingIndicator stopAnimating];
        self.buttonAction.hidden = NO;
        
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
    
    self.resetContainer.frame = CGRectMake( 320, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.resetContainer.frame = CGRectMake( 0, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185);
        self.container.frame = CGRectMake( -320, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185);
    } completion:^(BOOL finished) {
        [self.buttonAction setTitle:NSLocalizedString(@"RESET", nil) forState:UIControlStateNormal];
        
        [self.buttonAction removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
        [self.buttonAction addTarget:self action:@selector(resetPassWord) forControlEvents:UIControlEventTouchDown];
        
        [self.backButton removeTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
        [self.backButton addTarget:self action:@selector(backToSignIn) forControlEvents:UIControlEventTouchDown];
    }];
    
}

- (void)backToSignIn{
    [UIView animateWithDuration:0.4 animations:^{
        self.resetContainer.frame = CGRectMake( 320, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185);
        self.container.frame = CGRectMake( 0, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185);
    } completion:^(BOOL finished) {
        
        [self.resetContainer removeFromSuperview];
        
        [self.buttonAction setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
        
        [self.buttonAction removeTarget:self action:@selector(resetPassWord) forControlEvents:UIControlEventTouchDown];
        [self.buttonAction addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
        
        [self.backButton removeTarget:self action:@selector(backToSignIn) forControlEvents:UIControlEventTouchDown];
        [self.backButton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
    }];
}

- (UIView *)resetContainer{
    
    if (!_resetContainer) {
        
        _resetContainer = [[UIView alloc]initWithFrame:CGRectMake( 320, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185)];
        [self.wrapper addSubview:_resetContainer];
        
        UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        title1.text = NSLocalizedString(@"Reset Password", nil);
        title1.textAlignment = NSTextAlignmentCenter;
        title1.backgroundColor = [UIColor clearColor];
        title1.textColor = UIColorFromRGB(0x1ca6c3);
        title1.font = [UIFont fontWithName:@"Lato-Bold" size:24];
        [_resetContainer addSubview:title1];
        
        TTTAttributedLabel *labelForgotPassword = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 100, 320, 20)];
        labelForgotPassword.text = NSLocalizedString(@"Check your email. Contact us if you need help", nil);
        labelForgotPassword.textColor = UIColorFromRGB(0x1ca6c3);
        labelForgotPassword.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        labelForgotPassword.textAlignment = NSTextAlignmentCenter;
        labelForgotPassword.backgroundColor = [UIColor clearColor];
        [_resetContainer addSubview:labelForgotPassword];
        
        [labelForgotPassword setText:labelForgotPassword.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange termsRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Contact us", nil) options:NSCaseInsensitiveSearch];
            
            [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:termsRange];
            
            return mutableAttributedString;
            
        }];
        
        UICanuTextField *email = [[UICanuTextField alloc] initWithFrame:CGRectMake(10, 128, 300, 47.0)];
        email.placeholder = NSLocalizedString(@"your email or phone number", nil);
        [email setReturnKeyType:UIReturnKeyGo];
        [_resetContainer addSubview:email];
        
    }
    
    return _resetContainer;
    
}

- (void)resetPassWord{
    
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

- (void)viewDidUnload{

    _password = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

@end
