//
//  AttendeesContainerViewController.m
//  CANU
//
//  Created by Roger Calaf on 21/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AttendeesContainerViewController.h"
#import "AttendeesTableViewController.h"


@interface AttendeesContainerViewController ()

@end

@implementation AttendeesContainerViewController


@synthesize activity = _activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    
    AttendeesTableViewController *attendeesList = [[AttendeesTableViewController alloc] init];
    attendeesList.activity = _activity;
    [self addChildViewController:attendeesList];
    [self.view addSubview:attendeesList.view];
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:backButton];
    [self.view addSubview:toolBar];
    
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
