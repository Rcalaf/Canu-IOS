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
#define KNavboxPosition
#define KNavboxSize ((CGRect) 2.0,418.0 + KIphone5Margin,63.0,63.0)


@interface UICanuNavigationController () <UIGestureRecognizerDelegate>
    
@end

@implementation UICanuNavigationController

@synthesize control = _control;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBarHidden = YES;
        self.control = [[UIView alloc] initWithFrame:CGRectMake(2.0, 415.0 + KIphone5Margin, 63.0, 63.0)];
        self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_local.png"]];
        [self.view addSubview:self.control];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *goProfileGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goProfile:)];
    goProfileGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *goActivitiesGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goActivities:)];
    goActivitiesGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    UIPanGestureRecognizer *upGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(testSwipeUp:)];
    upGesture.delegate = self;
    
    UIPanGestureRecognizer *swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(test2SwipeUp:)];
    swipeGesture.delegate = self;
    
    UITapGestureRecognizer *bounceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bounce:)];
    
    [_control addGestureRecognizer:goProfileGesture];
    [_control addGestureRecognizer:goActivitiesGesture];
    [_control addGestureRecognizer:bounceGesture];
    [_control addGestureRecognizer:upGesture];
    
}

- (void)goProfile:(UISwipeGestureRecognizer *)gesture{
    
    NSLog(@"goProfile");
    
    [UIView animateWithDuration:0.3 animations:^{
        _control.frame = CGRectMake(255.0, 415.0 + KIphone5Margin, 63.0, 63.0);
    }completion:^(BOOL finished) {
        
    }];
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    UserProfileViewController *upvc =  appDelegate.profileViewController;
    self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_me.png"]];
    [self pushViewController:upvc animated:YES];
    
}

-(void)bounce:(UITapGestureRecognizer *)gesture{
    
    NSLog(@"bounce");
   
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = _control.frame;
        frame.origin.y = 400.0f + KIphone5Margin;
        _control.frame = frame;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:.2 animations:^{
            CGRect frame = _control.frame;
            frame.origin.y = 415.0f + KIphone5Margin;
            _control.frame = frame;
        }completion:^(BOOL finished) {
        }];
    }];
}

-(void)testSwipeUp:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"testSwipeUp");
    CGPoint location = [recognizer locationInView:self.view];
    
    if (location.y < 423.0f + KIphone5Margin && location.y > 0.0f) {
        _control.frame = CGRectMake(_control.frame.origin.x, location.y, _control.frame.size.width, _control.frame.size.height);
    }
    
    if (([recognizer state] == UIGestureRecognizerStateEnded) || ([recognizer state] == UIGestureRecognizerStateCancelled)) {
        if (_control.frame.origin.y < 318.0f + KIphone5Margin) {
            NewActivityViewController *nac = [[NewActivityViewController alloc] init];
            [self presentViewController:nac animated:YES completion:nil];
        }
        [UIView animateWithDuration:0.3 animations:^{
            _control.frame = CGRectMake(_control.frame.origin.x, 415.0f + KIphone5Margin,_control.frame.size.width, _control.frame.size.height);
        }completion:^(BOOL finished) {
            
        }];
    }
}



- (void)goActivities:(UISwipeGestureRecognizer *)gesture{
    NSLog(@"goActivities");
    [UIView animateWithDuration:0.3 animations:^{
        _control.frame = CGRectMake(2.0, 415.0 + KIphone5Margin, 63.0, 63.0);
        
    }completion:^(BOOL finished) {
       
    }];
   
    [self popViewControllerAnimated:YES];
    
    self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_local.png"]];
    
}

- (void)changePosition:(float)position{
    
    _control.frame = CGRectMake(_control.frame.origin.x, 415.0f + KIphone5Margin + position * 65,_control.frame.size.width, _control.frame.size.height);
    
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

@end
