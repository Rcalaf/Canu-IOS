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

- (id)initForTerms:(BOOL)isForTerms{
    self = [super init];
    if (self) {
        self.isForTerms = isForTerms;
    }
    return self;
}

- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadView{
    [super loadView];
    self.view.backgroundColor = backgroundColorView;
    
    self.browser = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.browser.scalesPageToFit = YES;
    
    if (!_isForTerms) {
        [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.canu.se/privacyapp"]]];
    }else{
        [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.canu.se/termsapp"]]];
    }
    
    [self.view addSubview:_browser];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeButton setFrame:CGRectMake(0, self.view.frame.size.height - 47, 320.0f, 47.0f)];
    [self.closeButton setTitleColor:[UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [self.closeButton setBackgroundColor:[UIColor whiteColor]];
    [self.closeButton  addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_closeButton];
}

- (void)viewDidLoad{
    [super viewDidLoad];
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
