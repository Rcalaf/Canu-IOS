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


@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UICanuTextField *description;

@property (strong, nonatomic) IBOutlet UILabel *start;
@property (strong, nonatomic) IBOutlet UILabel *lengthPicker;


@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) IBOutlet UIButton *createButon;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;

@property (strong, nonatomic) MKMapItem *location;
@property (strong, nonatomic) UILabel *locationName;

- (void)itemMap:(NSNotification*)notification;

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
@synthesize location = _location;
@synthesize locationName = _locationName;


float oldValue;

 
- (IBAction)createActivity:(id)sender{
     NSLog(@"tap title: %@ and location: %@",self.name.text, self.activity.location);
    NSLog(@"%@",self.location);
   if (self.name.text && self.location) {
      
       //NSArray *lengthTimeParts = [self.lengthPicker.text componentsSeparatedByString:@":"];
       
       //NSInteger delay = (([[lengthTimeParts objectAtIndex:0] integerValue]*60) + [[lengthTimeParts objectAtIndex:1] integerValue])*60;
       
       NSDate *start;
       if (self.activity) {
          start = self.activity.start;
       } else {
          start = [NSDate date];
       }
       
       /*NSDate *end = [start dateByAddingTimeInterval:delay];
       
       
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
       dateFormatter.dateFormat = @"dd MMM HH:mm";
       [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];*/
        
       if (self.activity) {
           [self.activity editActivityForUserWithTitle:self.name.text
                                        Description:self.description.text
                                          StartDate:self.start.text
                                             Length:self.lengthPicker.text
                                            EndDate:@""//[dateFormatter stringFromDate:end]
                                             Street:self.location.placemark.addressDictionary[@"Street"]
                                               City:self.location.placemark.addressDictionary[@"City"]
                                                Zip:self.location.placemark.addressDictionary[@"ZIP"]
                                            Country:self.location.placemark.addressDictionary[@"Country"]
                                           Latitude:[NSString stringWithFormat:@"%f",self.location.placemark.coordinate.latitude]
                                          Longitude:[NSString stringWithFormat:@"%f",self.location.placemark.coordinate.longitude ]
                                              Image:[UIImage imageNamed:@"icon_userpic.png"]
                                              Block:^(NSError *error) {
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              }];
       } else {
           [Activity createActivityForUserWithTitle:self.name.text
                                        Description:self.description.text
                                          StartDate:self.start.text
                                             Length:self.lengthPicker.text
                                            EndDate:@""//[dateFormatter stringFromDate:end]
                                             Street:self.location.placemark.addressDictionary[@"Street"]
                                               City:self.location.placemark.addressDictionary[@"City"]
                                                Zip:self.location.placemark.addressDictionary[@"ZIP"]
                                            Country:self.location.placemark.addressDictionary[@"Country"]
                                           Latitude:[NSString stringWithFormat:@"%f",self.location.placemark.coordinate.latitude]
                                          Longitude:[NSString stringWithFormat:@"%f",self.location.placemark.coordinate.longitude ]
                                              Image:[UIImage imageNamed:@"icon_userpic.png"]
                                              Block:^(NSError *error) {
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              }];
           
       }

   }
    
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)tapped:(UITapGestureRecognizer *)gesture{
    UIDatePickerActionSheet *das = [[UIDatePickerActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Accept", nil];
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
    self.lengthPicker.text = [Activity lengthToString:_length];
}

- (void)actionSheet:(UIDatePickerActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"dd MMM HH:mm";
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
        _length = [self.activity lengthToInteger];
        _location = self.activity.location;
    }else{
        _length = 20;
        // _location =
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];
    
    UIColor *textColor = [UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f];
    
    // Gradient background Background
    UIImageView *background;
    if (self.activity) {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit_bg.png"]];
    }else{
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_bg.png"]];
    }
    
    
    background.frame = CGRectMake(0.0f, -219.0f, 320.0f, 699.0f);
    [self.view addSubview:background];
    
    // FormGrid
    UIImageView *formGrid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_world.png"]];
    CGRect formGridFrame = formGrid.frame;
    formGridFrame.origin.x = 10.0f;
    formGridFrame.origin.y = 203.0f;
    formGrid.frame = formGridFrame;
    [formGrid setUserInteractionEnabled:YES];
    
    
    _name = [[UITextField alloc] initWithFrame:CGRectMake(18.0f, 0.0f, 260.0, 47.0)];
    _name.placeholder = @"Title";
    _name.textColor = textColor;
    _name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _name.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _name.text = self.activity.title;
    _name.delegate = self;
    [_name setReturnKeyType:UIReturnKeyNext];
    [formGrid addSubview:_name];
    
    _start = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 47.5f, 110.0f, 47.0f)];
    _start.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _start.textColor = textColor;
    // Create the gesture to trigger the date picker
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_start addGestureRecognizer:tapRecognizer];
    
    // Set the time formatter and the start time
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"dd MMM HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (self.activity) {
        self.start.text = [dateFormatter stringFromDate:self.activity.start];
    } else {
        self.start.text = [dateFormatter stringFromDate:[NSDate date]];
    }
    
    [self.start setUserInteractionEnabled:YES];
    
    [formGrid addSubview:_start];
    
    _lengthPicker = [[UILabel alloc] initWithFrame:CGRectMake(215.0f, 47.5f, 87.0f, 47.0f)];
    _lengthPicker.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _lengthPicker.textColor = textColor;
    _lengthPicker.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];
    _lengthPicker.text = [Activity lengthToString:_length];
    [_lengthPicker setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(incrementActivityLength:)];
    tgr.delegate = self;
    [_lengthPicker addGestureRecognizer:tgr];
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(finetuneActivityLength:)];
    pgr.delegate = self;
    [_lengthPicker addGestureRecognizer:pgr];
    
    [formGrid addSubview:_lengthPicker];
    
    
    
    UIView *findLocationButton = [[UIView alloc] initWithFrame:CGRectMake(47.5f, 95.0f, 252.5, 47.0)];
    
    _locationName = [[UILabel alloc] initWithFrame:CGRectMake(18.0, 0.0, 226.5, 47.0)];
    if (self.activity) {
        _locationName.text = [self.activity locationDescription];
    }else{
        _locationName.text = @"Current location";
    }
    [findLocationButton addSubview:_locationName];
    _locationName.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    _locationName.textColor = [UIColor colorWithRed:26.0f/255.0f green:144.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    
    findLocationButton.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];
    UITapGestureRecognizer *fl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerFindLocation:)];
    tgr.delegate = self;
    [findLocationButton addGestureRecognizer:fl];
    
    
    
    [formGrid addSubview:findLocationButton];
    
    
    _description = [[UICanuTextField alloc] initWithFrame:CGRectMake(10.0f, 345.0f, 300.0f, 47.0)];
    _description.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
    _description.placeholder = @"Details";
    _description.text = self.activity.description;
    _description.delegate = self;
    [self.description setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:_description];
    
    [self.view addSubview:formGrid];
    

    
    
    
    
    
    // Set the toolbar
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    //set the create button
    _createButon = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.activity) {
        [_createButon setTitle:@"EDIT ACTIVITY" forState:UIControlStateNormal];
    } else {
        [_createButon setTitle:@"CREATE ACTIVITY" forState:UIControlStateNormal];
    }
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
    
    [_toolBar addSubview:_createButon];
    [_toolBar addSubview:_backButton];
    [self.view addSubview:_toolBar];
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

- (void)itemMap:(NSNotification*)notification
{
   
    self.location = (MKMapItem *)notification.object;
    self.locationName.text = self.location.placemark.addressDictionary[@"Street"];
  //  [self.view setNeedsDisplay];
  //   NSLog(@"%@",self.location.placemark.addressDictionary);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemMap:)
                                                 name:FindLocationDissmised
                                               object:nil];
    
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
