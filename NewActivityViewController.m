//
//  NewActivityViewController.m
//  CANU
//
//  Created by Roger Calaf on 04/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//
#import "AppDelegate.h"
#import "AFCanuAPIClient.h"
#import "UICanuTextField.h"
#import "UIDatePickerActionSheet.h"

#import "NewActivityViewController.h"
#import "FindLocationsViewController.h"


#import "Activity.h"



@interface NewActivityViewController () 



@property int length;

@property (strong, nonatomic) UIImageView *formGrid;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) UITextView *description;

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
@synthesize formGrid = _formGrid;
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

- (IBAction)deleteActivity:(id)sender{
    NSLog(@"trigger delete");
    [self.activity removeActivityWithBlock:^(NSError *error){
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        }
     
    }];
    
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
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocationManager *lm = [[CLLocationManager alloc]init];
        lm.delegate = self;
        [lm startUpdatingLocation];
        
        //Block address
        [geocoder reverseGeocodeLocation: lm.location completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             
             if (error != nil) {
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                             message:[error localizedDescription]
                                            delegate:nil
                                   cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                 return;
             }
             //Get address
             //NSLog(@"%@",[[placemarks objectAtIndex:0] class]);
             //CLPlacemark *placemark = ;
             
             
             _location = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]]];
             
             //String to address
             // NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             //Print the location in the console
             //   NSLog(@"Currently address is: %@",locatedaddress);
             
             
             
         }];
        [lm stopUpdatingLocation];
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
    _formGrid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_world.png"]];
    CGRect formGridFrame = _formGrid.frame;
    formGridFrame.origin.x = 10.0f;
    formGridFrame.origin.y = 203.0f;
    _formGrid.frame = formGridFrame;
    [_formGrid setUserInteractionEnabled:YES];
    
    
    _name = [[UITextField alloc] initWithFrame:CGRectMake(18.0f, 0.0f, 260.0, 47.0)];
    _name.placeholder = @"Title";
    _name.textColor = textColor;
    _name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _name.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _name.text = self.activity.title;
    _name.delegate = self;
    [_name setReturnKeyType:UIReturnKeyNext];
    [_formGrid addSubview:_name];
    
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
    
    [_formGrid addSubview:_start];
    
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
    
    [_formGrid addSubview:_lengthPicker];
    
    
    
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
    
    
    
    [_formGrid addSubview:findLocationButton];
    
    
    if (![_description hasText]) {
        UITextField *detailsPlaceholder = [[UICanuTextField alloc] initWithFrame:CGRectMake(10.0f, 345.0f, 300.0f, 47.0)];
        detailsPlaceholder.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];
        detailsPlaceholder.placeholder = @"Details";
        detailsPlaceholder.text = self.activity.description;
        detailsPlaceholder.delegate = self;
        [detailsPlaceholder setReturnKeyType:UIReturnKeyNext];
        [self.view addSubview:detailsPlaceholder];
    }

    
    _description = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 345.0f, 300.0f, 47.0)];
    _description.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
    _description.text = self.activity.description ;
    _description.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    _description.textColor = textColor;
    _description.contentInset = UIEdgeInsetsMake(4.0f, 8.0f, 0.0f, 8.0f);
    [self.description setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:_description];
    
    [self.view addSubview:_formGrid];
    
    
    // Set the toolbar
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    //set the create button
   
    if (self.activity) {
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        saveButton.frame = CGRectMake(67.0f, 10.0f, 116.0f, 36.0f);
        [saveButton setImage:[UIImage imageNamed:@"edit_save.png"] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(194.0f, 10.0f, 116.0f, 36.0f);
        [deleteButton setImage:[UIImage imageNamed:@"edit_delete.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteActivity:) forControlEvents:UIControlEventTouchUpInside];
    
        [_toolBar addSubview:saveButton];
        [_toolBar addSubview:deleteButton];
    } else {
         _createButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createButon setImage:[UIImage imageNamed:@"create_active.png"] forState:UIControlStateNormal];
        [_createButon setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
        [_createButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _createButon.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
        [_createButon setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
        [_createButon addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:_createButon];
    }
 
    
    //set Back button
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_toolBar addSubview:_backButton];
    [self.view addSubview:_toolBar];
}


-(IBAction)triggerFindLocation:(UITapGestureRecognizer *)gesture
{
    FindLocationsViewController *findLocations = [[ FindLocationsViewController alloc] init];
    findLocations.chosenLocation = _location;
    NSLog(@"location 1: %@",findLocations.chosenLocation);
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_name resignFirstResponder];
    [_description resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    if ([_description hasText] && ![_description.text isEqualToString:@"Details"]) {
        [UIView animateWithDuration:0.25 animations:^{
            _formGrid.frame =CGRectMake(10.0, -9.5f, _formGrid.frame.size.width, _formGrid.frame.size.height);
            _description.frame =CGRectMake(10.0, 133.0f, _description.frame.size.width, 101.0f);
            _description.backgroundColor = [UIColor whiteColor];
        }];
    } else {
        if ([_name isFirstResponder]) {
            [UIView animateWithDuration:0.25 animations:^{
                _formGrid.frame =CGRectMake(10.0f, 196.0f, _formGrid.frame.size.width, _formGrid.frame.size.height);
                //_description.frame = CGRectMake(10.0, 338.5f, _description.frame.size.width, _description.frame.size.height);
            }];
        }else if ([_description isFirstResponder]){
            [UIView animateWithDuration:0.25 animations:^{
                _formGrid.frame =CGRectMake(10.0, -9.5f, _formGrid.frame.size.width, _formGrid.frame.size.height);
                _description.frame =CGRectMake(10.0, 133.0f, _description.frame.size.width, 101.0f);
                _description.backgroundColor = [UIColor whiteColor];
            }];
        }
    }


}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([_description hasText] && ![_description.text isEqualToString:@"Details"]) {
            [UIView animateWithDuration:0.25 animations:^{
                _formGrid.frame =CGRectMake(10.0, 149.5f, _formGrid.frame.size.width, _formGrid.frame.size.height);
                _description.frame =CGRectMake(10.0,  292.0f, _description.frame.size.width, 101.0f);
            }];
    } else {
        if ([_name isFirstResponder]) {
            [UIView animateWithDuration:0.25 animations:^{
                _formGrid.frame =CGRectMake(10.0, 203.0f, _formGrid.frame.size.width, _formGrid.frame.size.height);
                _description.frame =CGRectMake(10.0,  345.0f, _description.frame.size.width, 47.0f);
                _description.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
            }];
            
        } else if ([_description isFirstResponder]){
            [UIView animateWithDuration:0.25 animations:^{
                _formGrid.frame =CGRectMake(10.0, 203.0f, _formGrid.frame.size.width, _formGrid.frame.size.height);
                _description.frame =CGRectMake(10.0,  345.0f, _description.frame.size.width, 47.0f);
                _description.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
            }];
            
        }
    }

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    

  
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FindLocationDissmised
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
     
                                                  object:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    /*_activity = nil;
    _formGrid = nil;
    _name = nil;
    _description = nil;
    _lengthPicker = nil;
    _start = nil;
    _toolBar = nil;
    _backButton = nil;
    _createButon = nil;
    _takePictureButton = nil;
    _location = nil;
    _locationName = nil;*/
    
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
