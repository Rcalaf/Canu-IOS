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
#import "UICanuButtonSignBottomBar.h"

@interface MainViewController () <SignUpViewControllerDelegate>

@property (nonatomic) UICanuButtonSignBottomBar *getOn;
@property (nonatomic) UICanuButtonSignBottomBar *logIn;
@property (nonatomic) SignUpViewController *signUpViewController;
@property (nonatomic) UIView *backgroundColor;
@property (nonatomic) UIImageView *backgroundCloud;
@property (nonatomic) UIImageView *backgroundTotem;
@property (nonatomic) UILabel *slogan;
@property (nonatomic) UIView *toolBar;

@end

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goSignUp{
    self.signUpViewController = [[SignUpViewController alloc]initForCheckPhonenumber:NO];
    self.signUpViewController.delegate = self;
    [self addChildViewController:_signUpViewController];
    [self.backgroundColor addSubview:_signUpViewController.view];
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0xe8eeee);
        self.backgroundCloud.alpha = 0;
        self.backgroundTotem.frame = CGRectMake(-320, self.view.frame.size.height - 480, self.view.frame.size.width, 480);
        self.slogan.frame = CGRectMake(-320,  40 + (self.view.frame.size.height - 480)/2, 320, 80);
        self.toolBar.frame = CGRectMake(0.0f, self.view.frame.size.height, 320.0f, 57.0f);
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
        self.slogan.frame = CGRectMake(-320,  40 + (self.view.frame.size.height - 480)/2, 320, 80);
        self.toolBar.frame = CGRectMake(0.0f, self.view.frame.size.height, 320.0f, 57.0f);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)signUpGoBackHome{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0xe4f8f7);
        self.backgroundCloud.alpha = 1;
        self.backgroundTotem.frame = CGRectMake(0, self.view.frame.size.height - 480, self.view.frame.size.width, 480);
        self.slogan.frame = CGRectMake(0,  40 + (self.view.frame.size.height - 480)/2, 320, 80);
        self.toolBar.frame = CGRectMake(0.0f, self.view.frame.size.height - 57, 320.0f, 57.0f);
    } completion:^(BOOL finished) {
        [self.signUpViewController willMoveToParentViewController:nil];
        [self.signUpViewController.view removeFromSuperview];
        [self.signUpViewController removeFromParentViewController];
        self.signUpViewController = nil;
    }];
}

-(void)chechPhoneNumber{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor.backgroundColor = UIColorFromRGB(0x83d2d5);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)goSignIn:(id)sender
{
    [self presentViewController:[[SignInViewController alloc] init] animated:NO completion:^{}];
}

-(void) loadView
{
    [super loadView];
    
    self.backgroundColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundColor.backgroundColor = UIColorFromRGB(0xe4f8f7);
    
    self.backgroundCloud = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 480, self.view.frame.size.width, 480)];
    self.backgroundCloud.image = [UIImage imageNamed:@"Main_background_cloud"];
    [self.backgroundColor addSubview:self.backgroundCloud];
    
    self.backgroundTotem = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 480, self.view.frame.size.width, 480)];
    self.backgroundTotem.image = [UIImage imageNamed:@"Main_background_totem"];
    [self.backgroundColor addSubview:self.backgroundTotem];
    
    self.slogan = [[UILabel alloc]initWithFrame:CGRectMake(0, 40 + (self.view.frame.size.height - 480)/2, 320, 80)];
    self.slogan.text = NSLocalizedString(@"Put your future moments\n in one place", nil);
    self.slogan.numberOfLines = 2;
    self.slogan.textAlignment = NSTextAlignmentCenter;
    self.slogan.backgroundColor = [UIColor clearColor];
    self.slogan.textColor = UIColorFromRGB(0x1ca6c3);
    self.slogan.font = [UIFont fontWithName:@"Lato-Bold" size:24];
    [self.backgroundColor addSubview:self.slogan];
    
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
    
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 57, 320.0f, 57.0f)];
    [self.toolBar setBackgroundColor:[UIColor colorWithRed:(245.0 / 255.0) green:(245.0 / 255.0) blue:(245.0 / 255.0) alpha: 1]];
    
    self.getOn = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(10.0, 10.0, 145.0, 37.0) andBlue:NO];
    [self.getOn setTitle:NSLocalizedString(@"I'M NEW", nil) forState:UIControlStateNormal];
    [self.getOn addTarget:self action:@selector(goSignUp) forControlEvents:UIControlEventTouchUpInside];
    
    self.logIn = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(165.0, 10.0, 145.0, 37.0) andBlue:YES];
    [self.logIn setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    [self.logIn addTarget:self action:@selector(goSignIn:) forControlEvents:UIControlEventTouchUpInside];

    [self.toolBar addSubview:_getOn];
    [self.toolBar addSubview:_logIn];
    
    [self.backgroundColor addSubview:_toolBar];
    
    [self.view addSubview:self.backgroundColor];
    
    if (_isPhoneCheck) {
        [self goSignUpForCHeckNumberPhone];
    }
    
}

-(BOOL)shouldAutorotate
{
    return NO;
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

@end
