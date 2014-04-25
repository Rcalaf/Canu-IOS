//
//  MainViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "MainViewController.h"
#import "SignInViewController.h"
#import "UICanuButton.h"
#import "UICanuTextFieldLine.h"
#import "UICanuBottomBar.h"
#import "User.h"
#import "CheckPhoneNumberViewController.h"
#import "UserManager.h"
#import "PrivacyPolicyViewController.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

typedef NS_ENUM(NSInteger, MainViewControllerView) {
    MainViewControllerViewMain = 1,
    MainViewControllerViewSignUp = 2,
    MainViewControllerViewCheckPhoneNumber = 3,
    MainViewControllerViewSignIn = 4
};

@interface MainViewController () <SignInViewControllerDelegate,UITextFieldDelegate,UIWebViewDelegate>

@property (nonatomic) BOOL keyboardSignUpOpen;
@property (nonatomic) MainViewControllerView viewType;
@property (strong, nonatomic) UIView *backgroundColor;
@property (strong, nonatomic) UIImageView *backgroundCloud;
@property (strong, nonatomic) UIImageView *backgroundTotem;
@property (strong, nonatomic) UILabel *createAccountText;
@property (strong, nonatomic) UIView *wrapperSignUP;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *signIn;
@property (strong, nonatomic) UIView *bottomBarWrapper;
@property (strong, nonatomic) UIWebView *termsPrivacy;
@property (strong, nonatomic) UICanuBottomBar *bottomBar;
@property (strong, nonatomic) UICanuTextFieldLine *username;
@property (strong, nonatomic) UICanuTextFieldLine *password;
@property (strong, nonatomic) SignInViewController *signInViewController;
@property (strong, nonatomic) UICanuButton *nextButton;
@property (strong, nonatomic) CheckPhoneNumberViewController *checkPhoneNumberViewController;

@end

@implementation MainViewController


#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) loadView{
    [super loadView];
    
    self.viewType = MainViewControllerViewMain;
    
    self.keyboardSignUpOpen = NO;
    
    self.backgroundColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundColor.backgroundColor = backgroundColorView;
    
    self.backgroundCloud = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 480) / 2, self.view.frame.size.width, 480)];
    self.backgroundCloud.image = [UIImage imageNamed:@"Main_background_cloud"];
    [self.backgroundColor addSubview:self.backgroundCloud];
    
    self.backgroundTotem = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 480) / 2, self.view.frame.size.width, 480)];
    self.backgroundTotem.image = [UIImage imageNamed:@"Main_background_totem"];
    [self.backgroundColor addSubview:self.backgroundTotem];
    
    self.createAccountText = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 190 - (self.view.frame.size.height - 480) / 4, 300, 25)];
    self.createAccountText.text = NSLocalizedString(@"Create an account", nil);
    self.createAccountText.numberOfLines = 1;
    self.createAccountText.textAlignment = NSTextAlignmentCenter;
    self.createAccountText.backgroundColor = [UIColor clearColor];
    self.createAccountText.textColor = UIColorFromRGB(0x2b4b58);
    self.createAccountText.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [self.backgroundColor addSubview:self.createAccountText];
    
    if (IS_OS_7_OR_LATER) {
        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-20);
        verticalMotionEffect.maximumRelativeValue = @(20);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-20);
        horizontalMotionEffect.maximumRelativeValue = @(20);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        // Add both effects to your view
        [self.backgroundCloud addMotionEffect:group];
    }
    
    self.signIn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 170 - (self.view.frame.size.height - 480) / 4, 280, 30)];
    [self.signIn addTarget:self action:@selector(goSignIn) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundColor addSubview:_signIn];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"I have an account", nil)];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    UILabel *signInLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 30)];
    signInLabel.attributedText = attributeString;
    signInLabel.textAlignment = NSTextAlignmentCenter;
    signInLabel.textColor = UIColorFromRGB(0x2b4b58);
    signInLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    signInLabel.backgroundColor = [UIColor clearColor];
    signInLabel.alpha = 0.16f;
    [self.signIn addSubview:signInLabel];
    
    self.wrapperSignUP = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 140 - (self.view.frame.size.height - 480)/4, 320.0f, 140)];
    [self.backgroundColor addSubview:_wrapperSignUP];
    
    self.bottomBarWrapper = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, 320, 45)];
    [self.backgroundColor addSubview:_bottomBarWrapper];
    
    self.bottomBar = [[UICanuBottomBar alloc]initWithFrame:CGRectMake(0, 45, 320, 45)];
    [self.bottomBarWrapper addSubview:_bottomBar];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonManager) forControlEvents:UIControlEventTouchDown];
    [_bottomBar addSubview:self.backButton];
    
    self.nextButton = [[UICanuButton alloc]initWithFrame:CGRectMake(45, 4, 320 - 45 * 2, 35) forStyle:UICanuButtonStyleLarge];
    [self.nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonManager) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBarWrapper addSubview:_nextButton];
    
    self.username = [[UICanuTextFieldLine alloc]initWithFrame:CGRectMake(20, 0, 280, 45)];
    self.username.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
    self.username.placeholder = NSLocalizedString(@"Username", nil);
    self.username.delegate = self;
    self.username.autocorrectionType = UITextAutocorrectionTypeNo;
    self.username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.username setReturnKeyType:UIReturnKeyNext];
    [self.wrapperSignUP addSubview:_username];
    
    self.password = [[UICanuTextFieldLine alloc]initWithFrame:CGRectMake(20, 45, 280, 45)];
    self.password.placeholder = NSLocalizedString(@"Password", nil);
    self.password.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [self.password setReturnKeyType:UIReturnKeyNext];
    [self.wrapperSignUP addSubview:_password];
    
    self.termsPrivacy = [[UIWebView alloc]initWithFrame:CGRectMake(0, 140, 320, 20)];
    self.termsPrivacy.delegate = self;
    self.termsPrivacy.backgroundColor = backgroundColorView;
    [self.wrapperSignUP addSubview:_termsPrivacy];

    
    [self.view addSubview:self.backgroundColor];
    
    if (_isPhoneCheck) {
        [self.username becomeFirstResponder];
        [self signUpKeyboardIsAppear:YES Block:^(BOOL finished) {
            self.viewType = MainViewControllerViewSignUp;
            [self goSignUpForCHeckNumberPhone:[[UserManager sharedUserManager] currentUser]];
        }];
    }
    
    [NSThread detachNewThreadSelector:@selector(addUIWebView)toTarget:self withObject:nil];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)addUIWebView{
    [self.termsPrivacy loadHTMLString:[NSString stringWithFormat:@"<html><head><style type='text/css'>body,html,p{ margin:0px; padding:0px; background-color:#f1f5f5; } p { text-align:center; font-family:\"Lato-Regular\"; font-size:9px; color: #2b4b58; opacity: 0.3;} a{ color:#2b4b58; }</style></head><body><p>%@ <a href='http://terms/'>%@</a> %@ <a href='http://privacy/'>%@</a></p></body></html>",NSLocalizedString(@"By signing up I agree with the", nil),NSLocalizedString(@"Terms", nil),NSLocalizedString(@"and the", nil),NSLocalizedString(@"Privacy Policy", nil) ] baseURL:nil];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSURL *url = [request URL];
        
        if ([url.absoluteString isEqualToString:@"http://terms/"]) {
            [self openTerms];
        }
        
        if ([url.absoluteString isEqualToString:@"http://privacy/"]) {
            [self openPrivacyPolicy];
        }
        
        return NO;
    }
    return YES;
}

- (void)backButtonManager{
    
    switch (_viewType) {
        case MainViewControllerViewMain:
            //
            break;
        case MainViewControllerViewSignIn:
            //
            break;
        case MainViewControllerViewSignUp:{
            self.viewType = MainViewControllerViewMain;
            
            [self.username resignFirstResponder];
            [self.password resignFirstResponder];
            
            self.keyboardSignUpOpen = NO;
            [self signUpKeyboardIsAppear:NO Block:nil];
        }
            break;
        case MainViewControllerViewCheckPhoneNumber:{
            if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewChooseCountry) {
                [self.checkPhoneNumberViewController hiddenPickCountryCode];
            } else if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewPhoneCode) {
                [self.checkPhoneNumberViewController goBackPhoneNumber];
            }
        }
            break;
        default:
            
            break;
    }
    
}

- (void)nextButtonManager{
    
    switch (_viewType) {
        case MainViewControllerViewMain:
            //
            break;
        case MainViewControllerViewSignUp:
            [self signUpStep1CheckUsername];
            break;
        case MainViewControllerViewCheckPhoneNumber:
            
            if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewChooseCountry) {
                [self.checkPhoneNumberViewController selectCountry];
            } else if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewPhoneNumber) {
                [self.checkPhoneNumberViewController checkPhoneNumber];
            } else if (self.checkPhoneNumberViewController.viewType == CheckPhoneNumberViewControllerViewPhoneCode) {
                [self.checkPhoneNumberViewController checkPhoneCode];
            }
            
            break;
        default:
            
            break;
    }
    
}

#pragma mark -- Sign Up Transition

- (void)signUpKeyboardIsAppear:(BOOL)isAppear Block:(void(^)(BOOL finished))block{
    
    if (isAppear) {
        
        if (_viewType != MainViewControllerViewSignUp) {
            if (!_isPhoneCheck) {
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"Username/Password" value:nil] build]];
            }
        }
        
        self.viewType = MainViewControllerViewSignUp;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.termsPrivacy.frame = CGRectMake(0, 45 + 53, 320, 20);
            self.backgroundCloud.alpha = 0;
            self.backgroundTotem.frame = CGRectMake(0, - 480, self.view.frame.size.width, 480);
            self.createAccountText.frame = CGRectMake( 10, 30 + (self.view.frame.size.height - 480)/2, 300, 25);
            self.signIn.frame = CGRectMake(20, 55 + (self.view.frame.size.height - 480)/2, 280, 30);
            self.wrapperSignUP.frame = CGRectMake(0, self.view.frame.size.height - 216 - 170 - (self.view.frame.size.height - 480)/2, 320.0f, 140);
            self.bottomBar.frame = CGRectMake(0, 0, 320, 45);
            self.bottomBarWrapper.frame = CGRectMake(0, self.view.frame.size.height - 45 - 216, 320, 45);
        } completion:^(BOOL finished) {
            
            if (block) {
                block(finished);
            }
            
        }];
    } else {
        
        self.viewType = MainViewControllerViewMain;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.termsPrivacy.frame = CGRectMake(0, 140, 320, 20);
            self.backgroundCloud.alpha = 1;
            self.backgroundTotem.frame = CGRectMake(0, (self.view.frame.size.height - 480) / 2, self.view.frame.size.width, 480);
            self.createAccountText.frame = CGRectMake( 10, self.view.frame.size.height - 190 - (self.view.frame.size.height - 480) / 4, 300, 25);
            self.signIn.frame = CGRectMake(20, self.view.frame.size.height - 170 - (self.view.frame.size.height - 480) / 4, 280, 30);
            self.wrapperSignUP.frame = CGRectMake(0, self.view.frame.size.height - 140 - (self.view.frame.size.height - 480)/4, 320.0f, 140);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height, 320, 45);
            self.bottomBarWrapper.frame = CGRectMake(0, self.view.frame.size.height - 45, 320, 45);
        } completion:^(BOOL finished) {
            if (block) {
                block(finished);
            }
        }];
    }
    
}

- (void)goSignUpForCHeckNumberPhone:(User *)user{
    
    self.viewType = MainViewControllerViewCheckPhoneNumber;
    
    if (!_isPhoneCheck) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"PhoneNumber" value:nil] build]];
    }
    
    if (!_checkPhoneNumberViewController) {
        
        self.checkPhoneNumberViewController = [[CheckPhoneNumberViewController alloc]initForUser:user ForceVerified:_isPhoneCheck];
        self.checkPhoneNumberViewController.nextButton = _nextButton;
        self.checkPhoneNumberViewController.backButton = _backButton;
        [self addChildViewController:_checkPhoneNumberViewController];
        [self.backgroundColor addSubview:_checkPhoneNumberViewController.view];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundTotem.frame = CGRectMake(-320, - 480, self.view.frame.size.width, 480);
            self.createAccountText.frame = CGRectMake( -310, 50, 300, 25);
            self.signIn.frame = CGRectMake(-300, 75, 280, 30);
            self.wrapperSignUP.frame = CGRectMake(-320, self.view.frame.size.height - 216 - 140, 320.0f, 140);
            self.bottomBar.frame = CGRectMake(0, 0, 320, 45);
            self.bottomBarWrapper.frame = CGRectMake(0, self.view.frame.size.height - 45 - 216, 320, 45);
            self.checkPhoneNumberViewController.view.frame = CGRectMake(0, _checkPhoneNumberViewController.view.frame.origin.y, _checkPhoneNumberViewController.view.frame.size.width, _checkPhoneNumberViewController.view.frame.size.height);
            self.backButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.backButton.hidden = YES;
        }];
        
    }
    
}

- (void)signUpGoBackHome{
    
    self.viewType = MainViewControllerViewMain;
    
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    
    self.keyboardSignUpOpen = NO;
    [self signUpKeyboardIsAppear:NO Block:nil];
}

#pragma mark -- Sign Up Form

- (void)signUpStep1CheckUsername{
    
    if ([self.password.text isEqualToString:@""] || self.password.text  == nil || [self.username.text isEqualToString:@""] || self.username.text  == nil) {
        
        if ([self.username.text isEqualToString:@""] || self.username.text  == nil) self.username.valueValide = NO;
        else  self.username.rightView = nil;
        if ([self.password.text isEqualToString:@""] || self.password.text  == nil) self.password.valueValide = NO;
        else  self.password.rightView = nil;
        
        return;
        
    }
    
    self.nextButton.hidden = YES;
//    [self.loadingIndicator startAnimating];
    
    [User SignUpWithUserName:self.username.text Password:self.password.text Block:^(User *user, NSError *error) {
        if (!error) {
            self.username.valueValide = YES;
            self.password.valueValide = YES;
            [self goSignUpForCHeckNumberPhone:user];
        }else{
            self.username.valueValide = NO;
        }
        self.nextButton.hidden = NO;
    }];
    
}

#pragma mark -- Sign In

- (void)goSignIn{
    
    self.viewType = MainViewControllerViewSignIn;
    
    if (_keyboardSignUpOpen) {
        
        [self.username resignFirstResponder];
        [self.password resignFirstResponder];
        
        self.keyboardSignUpOpen = NO;
        [self signUpKeyboardIsAppear:NO Block:^(BOOL finished) {
            [self goSignIn];
        }];
        
    } else {
        self.signInViewController = [[SignInViewController alloc]init];
        self.signInViewController.delegate = self;
        [self addChildViewController:_signInViewController];
        [self.backgroundColor addSubview:_signInViewController.view];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.backgroundColor.backgroundColor = backgroundColorView;
            self.backgroundCloud.alpha = 0;
            self.backgroundTotem.frame = CGRectMake(-320, (self.view.frame.size.height - 480) / 2, self.view.frame.size.width, 480);
            self.createAccountText.frame = CGRectMake(-310, self.view.frame.size.height - 190 - (self.view.frame.size.height - 480) / 4, 300, 25);
            self.signIn.frame = CGRectMake(-320, self.view.frame.size.height - 170 - (self.view.frame.size.height - 480) / 4, 280, 30);
            self.wrapperSignUP.frame = CGRectMake(-320, self.view.frame.size.height - 140 - (self.view.frame.size.height - 480)/4, 320.0f, 140);
            self.bottomBarWrapper.frame = CGRectMake(-320, self.view.frame.size.height - 45, 320, 45);
            self.bottomBar.frame = CGRectMake(0, 45, 320, 45);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)signInGoBackHome{
    
    self.viewType = MainViewControllerViewMain;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = backgroundColorView;
        self.backgroundCloud.alpha = 1;
        self.backgroundTotem.frame = CGRectMake(0, (self.view.frame.size.height - 480) / 2, self.view.frame.size.width, 480);
        self.createAccountText.frame = CGRectMake( 10, self.view.frame.size.height - 190 - (self.view.frame.size.height - 480) / 4, 300, 25);
        self.signIn.frame = CGRectMake(20, self.view.frame.size.height - 170 - (self.view.frame.size.height - 480) / 4, 280, 30);
        self.wrapperSignUP.frame = CGRectMake(0, self.view.frame.size.height - 140 - (self.view.frame.size.height - 480)/4, 320.0f, 140);
        self.bottomBarWrapper.frame = CGRectMake(0, self.view.frame.size.height - 45, 320, 45);
        self.bottomBar.frame = CGRectMake(0, 45, 320, 45);
    } completion:^(BOOL finished) {
        [self.signInViewController willMoveToParentViewController:nil];
        [self.signInViewController.view removeFromSuperview];
        [self.signInViewController removeFromParentViewController];
        self.signInViewController = nil;
    }];
}

- (void)signInGoToFeed{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = backgroundColorView;
    } completion:^(BOOL finished) {
    }];
}

#pragma Mark -- Terms & Pricavy Policy

- (void)openPrivacyPolicy{
    PrivacyPolicyViewController *privacy = [[PrivacyPolicyViewController alloc]initForTerms:NO];
    [self presentViewController:privacy animated:YES completion:^{
        [self signUpKeyboardIsAppear:NO Block:nil];
    }];
}

- (void)openTerms{
    PrivacyPolicyViewController *privacy = [[PrivacyPolicyViewController alloc]initForTerms:YES];
    [self presentViewController:privacy animated:YES completion:^{
        [self signUpKeyboardIsAppear:NO Block:nil];
    }];
}

#pragma mark - UITextFieldDelegate Sign Up

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.keyboardSignUpOpen = YES;
    [self signUpKeyboardIsAppear:YES Block:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _username) {
        [self.username resignFirstResponder];
        [self.password becomeFirstResponder];
    }else if (textField == _password){
        [self signUpStep1CheckUsername];
    }
    
    return YES;
    
}

@end
