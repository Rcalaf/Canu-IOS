//
//  UICanuNavigationController.m
//  CANU
//
//  Created by Roger Calaf on 30/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuNavigationController.h"
#import "UserProfileViewController.h"
#import "NewActivityViewController.h"
#import "Activity.h"

@interface UICanuNavigationController ()
    
@end

@implementation UICanuNavigationController

@synthesize control = _control;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationBarHidden = YES;
        self.control = [[UIView alloc] initWithFrame:CGRectMake(-3.0, 423.0, 63.0, 63.0)];
        self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"navmenu_world.png"]];
        [self.view addSubview:self.control];
    }
    return self;
}

- (IBAction)goProfile:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        _control.frame = CGRectMake(260.0, 423.0, 63.0, 63.0);
    }];
    //NSLog(@"Load Profile view");
    self.control.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"menunav_me.png"]];
    //[self popViewControllerAnimated:YES];
    [self pushViewController:[[UserProfileViewController alloc] init] animated:YES];
    //NSLog(@"%@",self.topViewController);

}

-(IBAction)createActivity:(UITapGestureRecognizer *)gesture{
    NewActivityViewController *nac = [[NewActivityViewController alloc] init];
    [self presentViewController:nac animated:YES completion:nil];
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //_control.frame = CGRectMake(_control.frame.origin.x, 0.0, _control.frame.size.width, _control.frame.size.height);
    
    NSLog(@"%@",touches);
   
}*/


- (IBAction)goActivities:(UISwipeGestureRecognizer *)gesture{
    [UIView animateWithDuration:0.3 animations:^{
        _control.frame = CGRectMake(-3.0, 423.0, 63.0, 63.0);
        
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
    
   /* UISwipeGestureRecognizer *createActivityGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(createActivity:)];
    createActivityGesture.direction = UISwipeGestureRecognizerDirectionUp;*/
    
    UITapGestureRecognizer *createActivityGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createActivity:)];
    
    [_control addGestureRecognizer:goProfileGesture];
    [_control addGestureRecognizer:goActivitiesGesture];
    [_control addGestureRecognizer:createActivityGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
