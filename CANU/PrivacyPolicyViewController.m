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
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *backButton;
@property (nonatomic) BOOL isForTerms;

@end

@implementation PrivacyPolicyViewController

@synthesize browser = _browser;
@synthesize toolBar = _toolBar;
@synthesize closeButton = _closeButton;
@synthesize backButton = _backButton;

- (id)initForTerms:(BOOL)isForTerms
{
    self = [super init];
    if (self) {
        self.isForTerms = isForTerms;
    }
    return self;
}

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = backgroundColorView;
    
    _browser = [[UIWebView alloc] initWithFrame:self.view.frame];
    _browser.scalesPageToFit = YES;
    
    if (!_isForTerms) {
        [_browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.canu.se/privacy"]]];
    }else{
        [_browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.canu.se/terms"]]];
    }
    
    [self.view addSubview:_browser];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeButton setFrame:CGRectMake(10.0f, 403.0f + KIphone5Margin, 300.0f, 47.0f)];
    [_closeButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    _closeButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_closeButton setBackgroundColor:[UIColor whiteColor]];
    [_closeButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_closeButton];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
