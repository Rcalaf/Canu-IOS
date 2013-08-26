//
//  TutorialViewController.m
//  CANU
//
//  Created by Roger Calaf on 25/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "TutorialViewController.h"
#import "AppDelegate.h"

@interface TutorialViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *navView;
@property (strong, nonatomic) UIButton *runTutorialButton;
@property (strong, nonatomic) UIButton *skipTutorialButton;
@property (strong, nonatomic) UIButton *doneTutorialButton;


@end


@implementation TutorialViewController{
    int step;
}

@synthesize navView = _navView;
@synthesize runTutorialButton = _runTutorialButton;
@synthesize doneTutorialButton = _doneTutorialButton;
@synthesize skipTutorialButton = _skipTutorialButton;


- (IBAction)start:(id)sender
{
    self.runTutorialButton.hidden = YES;
    self.runTutorialButton = nil;
    self.skipTutorialButton.hidden = YES;
    self.skipTutorialButton = nil;
    self.navView.hidden = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_step_2.png"]];
}

- (IBAction)done:(id)sender
{
    //AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSLog(@"dismissing!!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showProfile:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        self.navView.frame = CGRectMake(260.0, 400.0, 63.0, 63.0);
        self.navView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menunav_me.png"]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_step_3.png"]];
    }];
    step = 2;
    [self.navView removeGestureRecognizer:gesture];
}

- (IBAction)showActivities:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        self.navView.frame = CGRectMake(-3.0, 400.0, 63.0, 63.0);
        self.navView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_world.png"]];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_step_4.png"]];
    }];

    step = 3;
    
}



-(IBAction)bounce:(UITapGestureRecognizer *)gesture{
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _navView.frame;
        frame.origin.y = 380.0f;
        _navView.frame = frame;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _navView.frame;
            frame.origin.y = 400.0f;
            _navView.frame = frame;
        }];
    }];
}

-(IBAction)createActivity:(UIPanGestureRecognizer *)recognizer
{
    //  NSLog(@"test action:%@",recognizer);
    CGPoint location = [recognizer locationInView:self.view];
    //  NSLog(@"location x:%f",location.x);
    if (location.y < 400.0f && location.y > 0.0f) {
        _navView.frame = CGRectMake(_navView.frame.origin.x, location.y, _navView.frame.size.width, _navView.frame.size.height);
    }
    
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        if (_navView.frame.origin.y < 318.0f && step == 3) {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_step_5.png"]];
            _navView.hidden = YES;
            self.doneTutorialButton.hidden = NO;
            
        }
        [UIView animateWithDuration:0.3 animations:^{
            _navView.frame = CGRectMake(_navView.frame.origin.x, 400.0,_navView.frame.size.width, _navView.frame.size.height);
        }];
    }
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
    step = 1;
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_step_1.png"]];
    self.runTutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.runTutorialButton.frame = CGRectMake(80.0f, 362.0f, 160.0f, 37.0f);
    [self.runTutorialButton setImage:[UIImage imageNamed:@"guide_btn_start.png"] forState:UIControlStateNormal];
    [self.runTutorialButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.runTutorialButton];
    self.skipTutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipTutorialButton.frame = CGRectMake(80.0f, 410.0f, 160.0f, 37.0f);
    [self.skipTutorialButton setImage:[UIImage imageNamed:@"guide_btn_skip.png"] forState:UIControlStateNormal];
    [self.skipTutorialButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipTutorialButton];
    self.doneTutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneTutorialButton.frame = CGRectMake(80.0f, 362.0f, 160.0f, 37.0f);
    [self.doneTutorialButton setImage:[UIImage imageNamed:@"guide_btn_gotit.png"] forState:UIControlStateNormal];
    [self.doneTutorialButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    self.doneTutorialButton.hidden = YES;
    [self.view addSubview:self.doneTutorialButton];
    //[self.view setUserInteractionEnabled:YES];
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(-3.0, 400.0, 63.0, 63.0)];
    self.navView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_world.png"]];
    self.navView.hidden = YES;
    [self.view addSubview:self.navView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *goProfileGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showProfile:)];
    goProfileGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *goActivitiesGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showActivities:)];
    goActivitiesGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UIPanGestureRecognizer *createActivityGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(createActivity:)];
    createActivityGesture.delegate = self;

    UITapGestureRecognizer *bounceNavGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bounce:)];
    
    [_navView addGestureRecognizer:goProfileGesture];
    [_navView addGestureRecognizer:goActivitiesGesture];
    [_navView addGestureRecognizer:bounceNavGesture];
    [_navView addGestureRecognizer:createActivityGesture];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#define SWIPE_UP_THRESHOLD -1000.0f
#define SWIPE_DOWN_THRESHOLD 1000.0f
#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f

- (void)handlePanSwipe:(UIPanGestureRecognizer*)recognizer
{
    // Get the translation in the view
    CGPoint t = [recognizer translationInView:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    // TODO: Here, you should translate your target view using this translation
    _navView.center = CGPointMake(_navView.center.x + t.x, _navView.center.y + t.y);
    
    // But also, detect the swipe gesture
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint vel = [recognizer velocityInView:recognizer.view];
        
        if (vel.x < SWIPE_LEFT_THRESHOLD)
        {
            // TODO: Detected a swipe to the left
        }
        else if (vel.x > SWIPE_RIGHT_THRESHOLD)
        {
            // TODO: Detected a swipe to the right
        }
        else if (vel.y < SWIPE_UP_THRESHOLD)
        {
            // TODO: Detected a swipe up
        }
        else if (vel.y > SWIPE_DOWN_THRESHOLD)
        {
            // TODO: Detected a swipe down
        }
        else
        {
            // TODO:
            // Here, the user lifted the finger/fingers but didn't swipe.
            // If you need you can implement a snapping behaviour, where based on the location of your         targetView,
            // you focus back on the targetView or on some next view.
            // It's your call
        }
    }
}

@end
