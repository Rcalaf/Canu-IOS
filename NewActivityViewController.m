//
//  NewActivityViewController.m
//  CANU
//
//  Created by Roger Calaf on 04/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "NewActivityViewController.h"
#import "FindLocationsViewController.h"
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"
#import "UICanuTextField.h"
#import "UIDatePickerActionSheet.h"
#import "Activity.h"


@interface NewActivityViewController ()



@property int length;


@property (strong, nonatomic) IBOutlet UICanuTextField *name;
@property (strong, nonatomic) IBOutlet UICanuTextField *description;

@property (strong, nonatomic) IBOutlet UILabel *start;
@property (strong, nonatomic) IBOutlet UILabel *lengthPicker;


@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) IBOutlet UIButton *createButon;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;

@end

@implementation NewActivityViewController

@synthesize activity = _activity;
@synthesize name = _name;
@synthesize description = _description;
@synthesize length = _length;
@synthesize lengthPicker = _lengthPicker;
@synthesize start = _start;
@synthesize toolBar = _toolBar;
@synthesize backButton = _backButton;
@synthesize createButon = _createButon;
@synthesize takePictureButton = _takePictureButton;

float oldValue;

 
- (IBAction)createActivity:(id)sender{
   if (self.description.text && self.name.text) {
        NSArray *objectsArray = [NSArray arrayWithObjects:self.name.text,self.description.text,self.start.text,self.lengthPicker.text,nil];
        NSArray *keysArray = [NSArray arrayWithObjects:@"title",@"description",@"start",@"length",nil];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
       
       AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
       NSLog(@"%lu", (unsigned long)appDelegate.user.userId);
        
       
        [[AFCanuAPIClient sharedClient] postPath:[NSString stringWithFormat:@"users/%lu/activities",(unsigned long)appDelegate.user.userId] parameters:parameters
                                         success:^(AFHTTPRequestOperation *operation, id JSON) {
                                             //NSLog(@"%@",operation);
                                             NSLog(@"%@",[JSON valueForKey:@"activity"]);
                                            
                                             [self dismissViewControllerAnimated:YES completion:^{
                                                 NSLog(@"Done");
                                             }];
                                         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             //NSLog(@"%@",operation);
                                             //NSLog(@"%@",error);
                                             NSLog(@"Error");
                                         }];
    }
    
    
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)tapped:(UITapGestureRecognizer *)gesture{
    UIDatePickerActionSheet *das = [[UIDatePickerActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Acept", nil];
    [das showInView:self.view];
}

-(IBAction)finetuneActivityLength:(UIPanGestureRecognizer *)gesture
{
    //float curve = (abs([gesture velocityInView:self.view].y)%100)/100.0;
   
    if([gesture translationInView:self.view].y > oldValue){
        if (_length > 0) {
            _length = _length - 5;
        } else {
            _length = 0;
        }
    } else {
        _length = _length + 5;
    }
    
    oldValue = [gesture translationInView:self.view].y;
    
    
   //NSLog(@"leght value: %f", [gesture translationInView:self.view].y);
    
    int hours = _length/60;
    int minuts = _length%60;
    
   // NSLog(@"time: %d:%d", hours,minuts);
    
    self.lengthPicker.text = [NSString stringWithFormat:@"%.2d:%.2d", hours,minuts  ];
}

-(IBAction)incrementActivityLength:(UITapGestureRecognizer *)gesture
{
    _length = _length + 20;
    int hours = _length/60;
    int minuts = _length%60;
    self.lengthPicker.text = [NSString stringWithFormat:@"%.2d:%.2d", hours,minuts  ];
}

- (void)actionSheet:(UIDatePickerActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"dd MMM hh:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    self.start.text = [dateFormatter stringFromDate:actionSheet.datePicker.date];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    if (self.activity) {
        self.view.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(220.0 / 255.0) blue:(32.0 / 255.0) alpha: 1];
    }else{
        self.view.backgroundColor = [UIColor colorWithRed:(164.0 / 255.0) green:(205.0 / 255.0) blue:(210.0 / 255.0) alpha: 1];
    }
    
    _length = 20;
    
    self.name = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 25.0, 252.5, 47.0)];
    self.name.placeholder = @"name";
    self.name.text = self.activity.title;
    self.name.delegate = self;
    [self.name setReturnKeyType:UIReturnKeyNext];
    
    self.description = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 82.0, 252.5, 47.0)];
    self.description.placeholder = @"Description";
    self.description.text = self.activity.description;
    self.description.delegate = self;
    [self.description setReturnKeyType:UIReturnKeyNext];
    
    self.start = [[UILabel alloc] initWithFrame:CGRectMake(47.5, 139.0, 252.5, 47.0)];
    self.start.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    self.start.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
    
    self.lengthPicker = [[UILabel alloc] initWithFrame:CGRectMake(47.5, 196.0, 252.5, 47.0)];
    self.lengthPicker.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    self.lengthPicker.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
    [self.lengthPicker setUserInteractionEnabled:YES];
    self.lengthPicker.text = [NSString stringWithFormat:@"00:%.2d", _length ];
    
    // Create the gesture to trigger the date picker
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_start addGestureRecognizer:tapRecognizer];
    
    // Set the time formatter and the start time
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"dd MMM hh:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    self.start.text = [dateFormatter stringFromDate:now];
    [self.start setUserInteractionEnabled:YES];
    
    // Create Gestures for setting the time
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(incrementActivityLength:)];
    tgr.delegate = self;
    [_lengthPicker addGestureRecognizer:tgr];
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(finetuneActivityLength:)];
    pgr.delegate = self;
    [_lengthPicker addGestureRecognizer:pgr];
    
    // Set the toolbar
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    //set the create button
    _createButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createButon setTitle:@"CREATE FUN" forState:UIControlStateNormal];
    [_createButon setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
    [_createButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _createButon.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_createButon setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
    [_createButon addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    //set Back button
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_name];
    [self.view addSubview:_description];
    [self.view addSubview:_start];
    [self.view addSubview:_lengthPicker];
    [_toolBar addSubview:_createButon];
    [_toolBar addSubview:_backButton];
    [self.view addSubview:_toolBar];
    /*UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_background2.png"]];
    background.frame = CGRectMake(10.0f, 203.5f, background.frame.size.width, background.frame.size.height);
    [self.view addSubview:background];*/
    
    UIView *findLocationButton = [[UIView alloc] initWithFrame:CGRectMake(47.5, 253.0, 252.5, 47.0)];
    findLocationButton.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UITapGestureRecognizer *fl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerFindLocation:)];
    tgr.delegate = self;
    [findLocationButton addGestureRecognizer:fl];
    [self.view addSubview:findLocationButton];
    
    
}


-(IBAction)triggerFindLocation:(UITapGestureRecognizer *)gesture
{
    FindLocationsViewController *findLocations = [[ FindLocationsViewController alloc] init];
    [self presentViewController:findLocations animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UICanuTextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UICanuTextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //[_signInButton addTarget:self action:@selector(performSingUp:) forControlEvents:UIControlEventTouchUpInside];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
