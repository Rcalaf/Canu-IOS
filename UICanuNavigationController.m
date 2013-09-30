//
//  UICanuNavigationController.m
//  CANU
//
//  Created by Roger Calaf on 30/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "UICanuNavigationController.h"
#import "UserProfileViewController.h"
#import "ActivitiesFeedViewController.h"	
#import "NewActivityViewController.h"
#import "Activity.h"

#define kNavboxAlpha ((float) .7)


@interface UICanuNavigationController () <UIGestureRecognizerDelegate>
    
@end

@implementation UICanuNavigationController

@synthesize control = _control;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBarHidden = YES;
        self.control = [[UIView alloc] initWithFrame:CGRectMake(-3.0, 420.0 + KIphone5Margin, 63.0, 63.0)];
        self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_world.png"]];
        [self.view addSubview:self.control];
        [UIView animateWithDuration:1.0 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            _control.alpha = kNavboxAlpha;
        }completion:nil];
    }
    return self;
}

- (IBAction)goProfile:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        _control.frame = CGRectMake(260.0, 420.0 + KIphone5Margin, 63.0, 63.0);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            _control.alpha = kNavboxAlpha;
        }completion:nil];
    }];
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    UserProfileViewController *upvc =  appDelegate.profileViewController;
    self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menunav_me.png"]];
    [self pushViewController:upvc animated:YES];
    //NSLog(@"%@",self.topViewController);

}

-(IBAction)bounce:(UITapGestureRecognizer *)gesture{
    //NSLog(@"Bounce");
   
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _control.frame;
        frame.origin.y = 400.0f + KIphone5Margin;
        _control.frame = frame;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _control.frame;
            frame.origin.y = 420.0f + KIphone5Margin;
            _control.frame = frame;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                _control.alpha = kNavboxAlpha;
            }completion:nil];
        }];
    }];
}

-(IBAction)testSwipeUp:(UIPanGestureRecognizer *)recognizer
{
  //  NSLog(@"test action:%@",recognizer);
    CGPoint location = [recognizer locationInView:self.view];
  //  NSLog(@"location x:%f",location.x);
    if (location.y < 423.0f + KIphone5Margin && location.y > 0.0f) {
        _control.frame = CGRectMake(_control.frame.origin.x, location.y, _control.frame.size.width, _control.frame.size.height);
    }
    
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        if (_control.frame.origin.y < 318.0f + KIphone5Margin) {
            NewActivityViewController *nac = [[NewActivityViewController alloc] init];
            [self presentViewController:nac animated:YES completion:nil];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _control.frame = CGRectMake(_control.frame.origin.x, 420.0f + KIphone5Margin,_control.frame.size.width, _control.frame.size.height);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                _control.alpha = kNavboxAlpha;
            }completion:nil];
        }];
    }
}



- (IBAction)goActivities:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        _control.frame = CGRectMake(-3.0, 420.0 + KIphone5Margin, 63.0, 63.0);
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            _control.alpha = kNavboxAlpha;
        }completion:nil];
    }];
   // NSLog(@"Load Activities view");
    [self popViewControllerAnimated:YES];
    
    self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_world.png"]];
    //NSLog(@"%@",self.topViewController);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    UISwipeGestureRecognizer *goProfileGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goProfile:)];
    goProfileGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *goActivitiesGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goActivities:)];
    goActivitiesGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    UIPanGestureRecognizer *upGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(testSwipeUp:)];
    //swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    upGesture.delegate = self;
    
    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(test2SwipeUp:)];
    swipeGesture.delegate = self;
    
    UITapGestureRecognizer *bounceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bounce:)];
    
    [_control addGestureRecognizer:goProfileGesture];
    [_control addGestureRecognizer:goActivitiesGesture];
    [_control addGestureRecognizer:bounceGesture];
  //  [_control addGestureRecognizer:swipeGesture];
    [_control addGestureRecognizer:upGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
   // NSLog(@"one: %@",gestureRecognizer);
   // NSLog(@"other: %@",otherGestureRecognizer);
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _control.alpha = 1.0f;
}


- (BOOL)shouldAutorotate
{
    if ([self.visibleViewController isKindOfClass:[ActivitiesFeedViewController class]]) {
        return YES;
    }else{
        return NO;
    }
}

@end
