//
//  MainViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "MainViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "UICanuButton.h"
#import "UICanuTextFieldLine.h"

@interface MainViewController () <SignUpViewControllerDelegate,SignInViewControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIView *backgroundColor;
@property (strong, nonatomic) UIImageView *backgroundCloud;
@property (strong, nonatomic) UIImageView *backgroundTotem;
@property (strong, nonatomic) UILabel *createAccountText;
@property (strong, nonatomic) UIView *wrapperSignUP;
@property (strong, nonatomic) UIButton *signIn;
@property (strong, nonatomic) UICanuTextFieldLine *username;
@property (strong, nonatomic) UICanuTextFieldLine *password;
@property (strong, nonatomic) SignUpViewController *signUpViewController;
@property (strong, nonatomic) SignInViewController *signInViewController;
@property (strong, nonatomic) UICanuButton *nextButton;

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
    
    self.backgroundColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundColor.backgroundColor = backgroundColorView;
    
    self.backgroundCloud = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 480, self.view.frame.size.width, 480)];
    self.backgroundCloud.image = [UIImage imageNamed:@"Main_background_cloud"];
    [self.backgroundColor addSubview:self.backgroundCloud];
    
    self.backgroundTotem = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 480, self.view.frame.size.width, 480)];
    self.backgroundTotem.image = [UIImage imageNamed:@"Main_background_totem"];
    [self.backgroundColor addSubview:self.backgroundTotem];
    
    self.createAccountText = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 190, 300, 25)];
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
    
    self.signIn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 170, 280, 30)];
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
    
    self.wrapperSignUP = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 140, 320.0f, 140)];
    [self.backgroundColor addSubview:_wrapperSignUP];
    
    self.username = [[UICanuTextFieldLine alloc]initWithFrame:CGRectMake(20, 0, 280, 45)];
    self.username.placeholder = NSLocalizedString(@"Username", nil);
    self.username.delegate = self;
    self.username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.username setReturnKeyType:UIReturnKeyNext];
    [self.wrapperSignUP addSubview:_username];
    
    self.password = [[UICanuTextFieldLine alloc]initWithFrame:CGRectMake(20, 45, 280, 45)];
    self.password.placeholder = NSLocalizedString(@"Password", nil);
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [self.password setReturnKeyType:UIReturnKeyNext];
    [self.wrapperSignUP addSubview:_password];
    
    self.nextButton = [[UICanuButton alloc]initWithFrame:CGRectMake(0, _wrapperSignUP.frame.size.height - 35 - 5, 320, 35) forStyle:UICanuButtonStyleLarge];
    [self.nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(goSignUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self.wrapperSignUP addSubview:_nextButton];

    
    [self.view addSubview:self.backgroundColor];
    
    if (_isPhoneCheck) {
        [self goSignUpForCHeckNumberPhone];
    }
    
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

#pragma mark -- Sign Up

- (void)goSignUp{
    self.signUpViewController = [[SignUpViewController alloc]initForCheckPhonenumber:NO];
    self.signUpViewController.delegate = self;
    [self addChildViewController:_signUpViewController];
    [self.backgroundColor addSubview:_signUpViewController.view];
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = backgroundColorView;
        self.backgroundCloud.alpha = 0;
        self.backgroundTotem.frame = CGRectMake(-320, self.view.frame.size.height - 480, self.view.frame.size.width, 480);
        self.createAccountText.frame = CGRectMake(-310, self.view.frame.size.height - 190, 300, 25);
        self.signIn.frame = CGRectMake(-320, self.view.frame.size.height - 170, 280, 30);
        self.wrapperSignUP.frame = CGRectMake(-320, self.view.frame.size.height - 140, 320.0f, 140);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)goSignUpForCHeckNumberPhone{
    self.signUpViewController = [[SignUpViewController alloc]initForCheckPhonenumber:YES];
    self.signUpViewController.delegate = self;
    [self addChildViewController:_signUpViewController];
    [self.backgroundColor addSubview:_signUpViewController.view];
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0x83d2d5);
        self.backgroundCloud.alpha = 0;
        self.backgroundTotem.frame = CGRectMake(-320, self.view.frame.size.height - 480, self.view.frame.size.width, 480);
        self.createAccountText.frame = CGRectMake(-310, self.view.frame.size.height - 190, 300, 25);
        self.signIn.frame = CGRectMake(-320, self.view.frame.size.height - 170, 280, 30);
        self.wrapperSignUP.frame = CGRectMake(-320, self.view.frame.size.height - 140, 320.0f, 140);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)signUpGoBackHome{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0xe4f8f7);
        self.backgroundCloud.alpha = 1;
        self.backgroundTotem.frame = CGRectMake(0, self.view.frame.size.height - 480, self.view.frame.size.width, 480);
        self.createAccountText.frame = CGRectMake( 10, self.view.frame.size.height - 190, 300, 25);
        self.signIn.frame = CGRectMake(20, self.view.frame.size.height - 170, 280, 30);
        self.wrapperSignUP.frame = CGRectMake(0, self.view.frame.size.height - 140, 320.0f, 140);
    } completion:^(BOOL finished) {
        [self.signUpViewController willMoveToParentViewController:nil];
        [self.signUpViewController.view removeFromSuperview];
        [self.signUpViewController removeFromParentViewController];
        self.signUpViewController = nil;
    }];
}

- (void)checkPhoneNumberDidAppear{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0x83d2d5);
    } completion:nil];
}

- (void)checkPhoneNumberDidDisappear{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0xe8eeee);
    } completion:nil];
}

#pragma mark -- Sign In

- (void)goSignIn{
    self.signInViewController = [[SignInViewController alloc]init];
    self.signInViewController.delegate = self;
    [self addChildViewController:_signInViewController];
    [self.backgroundColor addSubview:_signInViewController.view];
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = backgroundColorView;
        self.backgroundCloud.alpha = 0;
        self.backgroundTotem.frame = CGRectMake(-320, self.view.frame.size.height - 480, self.view.frame.size.width, 480);
        self.createAccountText.frame = CGRectMake(-310, self.view.frame.size.height - 190, 300, 25);
        self.signIn.frame = CGRectMake(-320, self.view.frame.size.height - 170, 280, 30);
        self.wrapperSignUP.frame = CGRectMake(-320, self.view.frame.size.height - 140, 320.0f, 140);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)signInGoBackHome{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0xe4f8f7);
        self.backgroundCloud.alpha = 1;
        self.backgroundTotem.frame = CGRectMake(0, self.view.frame.size.height - 480, self.view.frame.size.width, 480);
        self.createAccountText.frame = CGRectMake( 10, self.view.frame.size.height - 190, 300, 25);
        self.signIn.frame = CGRectMake(20, self.view.frame.size.height - 170, 280, 30);
        self.wrapperSignUP.frame = CGRectMake(0, self.view.frame.size.height - 140, 320.0f, 140);
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

@end
