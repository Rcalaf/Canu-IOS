//
//  TutorialViewController.m
//  CANU
//
//  Created by Roger Calaf on 25/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@property (retain, nonatomic) UIView *navView;


@end

@implementation TutorialViewController

- (IBAction)showProfile:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        self.navView.frame = CGRectMake(260.0, 400.0, 63.0, 63.0);
    }];
    self.navView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menunav_me.png"]];
   // [self pushViewController:upvc animated:YES];
    //NSLog(@"%@",self.topViewController);
    
}

- (IBAction)ShowActivities:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        self.navView.frame = CGRectMake(-3.0, 400.0, 63.0, 63.0);
        
    }];
    self.navView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_world.png"]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor redColor];
    //[self.view setUserInteractionEnabled:YES];
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(-3.0, 400.0, 63.0, 63.0)];
    self.navView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_world.png"]];
    [self.view addSubview:self.navView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *goProfileGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile:)];
    goProfileGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *goActivitiesGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ShowActivities:)];
    goActivitiesGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [_navView addGestureRecognizer:goProfileGesture];
    [_navView addGestureRecognizer:goActivitiesGesture];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
