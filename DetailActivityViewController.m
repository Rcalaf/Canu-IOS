//
//  DetailActivityViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailActivityViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NewActivityViewController.h"


@interface DetailActivityViewController ()

@end

@implementation DetailActivityViewController

//@synthesize toolBar = _toolBar;
//@synthesize backButton = _backButton;
@synthesize actionButton = _actionButton;

@synthesize numberOfAssistents = _numberOfAssistents;
@synthesize activity = _activity;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)triggerCellAction:(id)recognizer
{
    NewActivityViewController *eac;
   // AppDelegate *appDelegate =
   // [[UIApplication sharedApplication] delegate];
    
    if ([self.actionButton.imageView.image isEqual:[UIImage imageNamed:@"feed_action_edit.png"]]){
        eac = [[NewActivityViewController alloc] init];
        eac.activity = self.activity;
        [self presentViewController:eac animated:YES completion:nil];
    }else if ([self.actionButton.imageView.image isEqual:[UIImage imageNamed:@"feed_action_go.png"]]){
        [self.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
               // Activity *activity = [activities objectAtIndex:self.activity.activityId];
                //_numberOfAssistents = [NSString stringWithFormat:@"%ul",[activity.attendeeIds count]];
                 _numberOfAssistents = [NSString stringWithFormat:@"%ul",[self.activity.attendeeIds count]];
                [_actionButton setImage:[UIImage imageNamed:@"feed_action_yes.png"] forState:UIControlStateNormal];
                
            }
        }];
    }
    else {
       
        [self.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _numberOfAssistents = [NSString stringWithFormat:@"%ul",[self.activity.attendeeIds count]];
               [_actionButton setImage:[UIImage imageNamed:@"feed_action_go.png"] forState:UIControlStateNormal];
            }
        }];
    }
   
    
}

- (void)loadView
{
    [super loadView];
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    
    UITextField *description = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 10.0, 200.0, 200.0)];
    description.text = self.activity.description;
    [self.view addSubview:description];
    
    
    UIImageView *userPic = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 91.0, 25.0, 25.0)];
    [userPic setImageWithURL:self.activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    [self.view addSubview:userPic];
    
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(37.0f, 89.0f, 128.0f, 25.0f)];
    userName.text = [NSString stringWithFormat:@"%@ %@",self.activity.user.firstName,self.activity.user.lastName];
    userName.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
    userName.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    [self.view addSubview:userName];
    
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionButton setFrame:CGRectMake(200.0, 0.0, 57.0, 57.0)];
    
    if (appDelegate.user == self.activity.user) [_actionButton setImage:[UIImage imageNamed:@"feed_action_edit.png"] forState:UIControlStateNormal];
    else if ([self.activity.attendeeIds indexOfObject:[NSNumber numberWithUnsignedInteger:appDelegate.user.userId]] == NSNotFound) [_actionButton setImage:[UIImage imageNamed:@"feed_action_go.png"] forState:UIControlStateNormal];
    else [_actionButton setImage:[UIImage imageNamed:@"feed_action_yes.png"] forState:UIControlStateNormal];
    
    [_actionButton addTarget:self action:@selector(triggerCellAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _numberOfAssistents = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 10.0f, 18.0f, 25.0f)];
    _numberOfAssistents.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.activity.attendeeIds count]];
    _numberOfAssistents.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
    _numberOfAssistents.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    [toolBar addSubview:_numberOfAssistents];
    
    [toolBar addSubview:backButton];
    [toolBar addSubview:_actionButton];
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
