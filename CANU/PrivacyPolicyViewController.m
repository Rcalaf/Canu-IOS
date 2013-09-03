//
//  PrivacyPolicyViewController.m
//  CANU
//
//  Created by Roger Calaf on 02/09/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@property (strong, nonatomic) UIWebView *browser;
@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation PrivacyPolicyViewController

@synthesize browser = _browser;
@synthesize toolBar = _toolBar;
@synthesize backButton = _backButton;

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


- (void)loadView
{
    [super loadView];
    _browser = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    /*NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"privacy_policy" ofType:@"pdf"] encoding:NSUTF8StringEncoding error:nil];
    [self.browser loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];*/
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"privacy_policy" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_browser loadRequest:request];
    
    [self.view addSubview:_browser];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setFrame:CGRectMake(10.0f, 403.0f + KIphone5Margin, 300.0f, 47.0f)];
    [close setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [close setBackgroundColor:[UIColor whiteColor]];
    [close  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:close];
    
    /*_toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5 + KIphone5Margin, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    
    [_toolBar addSubview:_backButton];
    [self.view addSubview:_toolBar];*/
    
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

@end
