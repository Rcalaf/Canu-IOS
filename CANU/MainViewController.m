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

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getOn;
@property (weak, nonatomic) IBOutlet UIButton *logIn;


@end

@implementation MainViewController

@synthesize getOn = _getOn;
@synthesize logIn = _logIn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goSignUp:(id)sender
{    
    //NSLog(@"Go to SignUp");
    [self presentViewController:[[SignUpViewController alloc] init] animated:NO completion:^{}];
    //[self.navigationController pushViewController:[[SignUpViewController alloc] init] animated:YES];
}

- (IBAction)goSignIn:(id)sender
{
    //NSLog(@"Go to SignIN");
    [self presentViewController:[[SignInViewController alloc] init] animated:NO completion:^{}];
    //[self.navigationController pushViewController:[[SignInViewController alloc] init] animated:YES];

   // [self performSegueWithIdentifier:@"SignIn" sender:sender];
}

-(void) loadView
{
    [super loadView];
    
    if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_bg-568h.png"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_bg.png"]];
    }
    
   // [UIColor colorWithRed:(255.0 / 255.0) green:(235.0 / 255.0) blue:(235.0 / 255.0) alpha: 1];
    
  //  UIScrollView *scrollDescription = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 403.0)];
  //  UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scroll_content.png"]];
    
   // [scrollDescription addSubview:backgroundImage];
   // scrollDescription.contentSize = backgroundImage.image.size;
   // CGPoint bottomOffset = CGPointMake(0.0, 650.0);
    
    
   // [scrollDescription setContentOffset:bottomOffset animated:YES];
    
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 57, 320.0f, 57.0f)];
    [toolBar setBackgroundColor:[UIColor colorWithRed:(245.0 / 255.0) green:(245.0 / 255.0) blue:(245.0 / 255.0) alpha: 1]];
     
    _getOn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getOn setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [_getOn setFrame:CGRectMake(10.0, 10.0, 145.0, 37.0)];
    [_getOn setTitleColor:[UIColor colorWithRed:109.0/256.0 green:110.0/256.0 blue:122.0/256.0 alpha:1.0] forState:UIControlStateNormal];
    _getOn.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_getOn setBackgroundColor:[UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 1]];
    [_getOn addTarget:self action:@selector(goSignUp:) forControlEvents:UIControlEventTouchUpInside];
    
    _logIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_logIn setTitle:@"SIGN IN" forState:UIControlStateNormal];
    [_logIn setFrame:CGRectMake(165.0, 10.0, 145.0, 37.0)];
    [_logIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _logIn.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
  //  [_logIn setBackgroundColor:[UIColor colorWithRed:(166.0 / 255.0) green:(207.0 / 255.0) blue:(212.0 / 255.0) alpha: 1]];
    [_logIn setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
    [_logIn addTarget:self action:@selector(goSignIn:) forControlEvents:UIControlEventTouchUpInside];

    [toolBar addSubview:_getOn];
    [toolBar addSubview:_logIn];
    //[self.view addSubview:scrollDescription];
    [self.view addSubview:toolBar];
    
    
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
