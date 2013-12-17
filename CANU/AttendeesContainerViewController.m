//
//  AttendeesContainerViewController.m
//  CANU
//
//  Created by Roger Calaf on 21/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AttendeesContainerViewController.h"
#import "AttendeesTableViewController.h"

#import "AttendeesScrollViewController.h"


@interface AttendeesContainerViewController ()

@property (strong, nonatomic) Activity *activity;

@end

@implementation AttendeesContainerViewController

- (id)initWithFrame:(CGRect)frame andWithActivity:(Activity *)activity{
    self = [super init];
    if (self) {
        
        self.view.frame = frame;
        
        self.view.backgroundColor = backgroundColorView;
        
//        AttendeesScrollViewController *attendeesList = [[AttendeesScrollViewController alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//        attendeesList.activity = _activity;
//        [self addChildViewController:attendeesList];
//        [self.view addSubview:attendeesList.view];
        
    }
    return self;
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
