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
@property (strong, nonatomic) NSDate *dateTime;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) UITextView *description;
@property (strong, nonatomic) UITextField *detailsPlaceholder;

@property (strong, nonatomic) IBOutlet UILabel *start;
@property (strong, nonatomic) IBOutlet UILabel *lengthPicker;


@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;

@property (strong, nonatomic) MKMapItem *location;
@property (strong, nonatomic) UILabel *locationName;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;

//@property (strong, nonatomic) CLLocationManager *locationManager;


- (void)itemMap:(NSNotification*)notification;
- (void)operationInProcess:(BOOL)isInProcess;

@end

@implementation NewActivityViewController{
    UIView *findLocationButton;
}

@synthesize activity = _activity;
@synthesize formGrid = _formGrid;
@synthesize name = _name;
@synthesize description = _description;
@synthesize length = _length;
@synthesize lengthPicker = _lengthPicker;
@synthesize start = _start;
@synthesize toolBar = _toolBar;
@synthesize backButton = _backButton;
@synthesize createButton = _createButton;
@synthesize saveButton = _saveButton;
@synthesize deleteButton = _deleteButton;
@synthesize takePictureButton = _takePictureButton;
@synthesize dateTime = _dateTime;

@synthesize loadingIndicator = _loadingIndicator;

//@synthesize locationManager = _locationManager;
@synthesize location = _location;
@synthesize locationName = _locationName;


float oldValue;


- (void)operationInProcess:(BOOL)isInProcess
{
    if (isInProcess) {
        [_loadingIndicator startAnimating];
        _createButton.hidden = YES;
        _saveButton.hidden = YES;
        _deleteButton.hidden = YES;
    }else{
        [_loadingIndicator stopAnimating];
        _createButton.hidden = NO;
        _saveButton.hidden = NO;
        _deleteButton.hidden = NO;
    }
}

 
- (IBAction)createActivity:(id)sender{
   if (self.location) {
      
       [self operationInProcess:YES];
       
       NSDate *start;
       if (self.activity) {
          start = self.activity.start;
       } else {
          start = [NSDate date];
       }
       
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
       dateFormatter.dateFormat = @"yyyy-M-dd HH:mm";
       [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
       if (self.activity) {
           [self.activity editActivityForUserWithTitle:self.name.text
                                        Description:self.description.text
                                             StartDate:[dateFormatter stringFromDate:self.dateTime]//self.start.text
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
                                                  if (error) {
                                                      if ([[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                                                          AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                          [appDelegate.user logOut];
                                                      } else {
                                                          if ([[error localizedRecoverySuggestion] rangeOfString:@"title"].location != NSNotFound) {
                                                              self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                                          }else{
                                                              self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                                          }
                                                      }
                                                  } else {
                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
                                                  }
                                                  [self operationInProcess:NO];
                                              }];
       } else {
           [Activity createActivityForUserWithTitle:self.name.text
                                        Description:self.description.text
                                          StartDate:[dateFormatter stringFromDate:self.dateTime]//self.start.text
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
                                                  if (error) {
                                                      NSLog(@"%lu",(unsigned long)[[error localizedRecoverySuggestion] rangeOfString:@"title"].location);
                                                      if ([[error localizedRecoverySuggestion] rangeOfString:@"Access denied"].location != NSNotFound) {
                                                          AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                          [appDelegate.user logOut];
                                                      } else {
                                                          if ([[error localizedRecoverySuggestion] rangeOfString:@"title"].location != NSNotFound) {
                                                              self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
                                                          }else{
                                                              self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
                                                          }
                                                      }
                                                    
                                                  } else {
                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadActivity" object:nil];
                                                  }
                                                  [self operationInProcess:NO];
                                              }];
           
           
       }

   }else{
       self.locationName.text = @"GPS disabled or couldn't get location";
   }
    
}

- (IBAction)deleteActivity:(id)sender{
    [self operationInProcess:YES];
    [self.activity removeActivityWithBlock:^(NSError *error){
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            //[error localizedDescription]
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:@"Couldn't delete the activity." delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        }
     [self operationInProcess:NO];
    }];
    
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)selectDayTime:(UITapGestureRecognizer *)gesture{
    UIDatePickerActionSheet *das = [[UIDatePickerActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Accept", nil];
    if (self.activity) {
        das.datePicker.date = self.activity.start;
    } else {
        das.datePicker.date = [NSDate date];
    }    
    [das showInView:self.view];
}

-(IBAction)finetuneActivityLength:(UIPanGestureRecognizer *)gesture
{
   
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
    
    int hours = _length/60;
    int minuts = _length%60;
    
    self.lengthPicker.text = [NSString stringWithFormat:@"%.2d:%.2d", hours,minuts  ];
}

-(IBAction)incrementActivityLength:(UITapGestureRecognizer *)gesture
{
    _length = _length + 15;
    self.lengthPicker.text = [Activity lengthToString:_length];
}

- (void)actionSheet:(UIDatePickerActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"d MMM HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    self.dateTime = actionSheet.datePicker.date;
    self.start.text = [dateFormatter stringFromDate:actionSheet.datePicker.date];
}

- (void)loadView
{
    [super loadView];
    
    if (self.activity) {
        _length = [self.activity lengthToInteger];
        _location = self.activity.location;
    }else{
        _length = 15;
         AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        //_location = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:appDelegate.currentLocation addressDictionary:nil]];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation: [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.latitude  longitude:appDelegate.currentLocation.longitude] completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             if (error != nil) {
                 [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cannot Provide Directions",nil)
                                             message:@"The map server is not available."//[error localizedDescription]
                                            delegate:nil
                                   cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                 return;
             }
             
             _location = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]]];
             findLocationButton.userInteractionEnabled = YES;
             //String to address
             NSString *locatedaddress = [[_location.placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             //Print the location in the console
             NSLog(@"Currently address is: %@",locatedaddress);
             
             
             
         }];
        /*locationManager = appDelegate.locationManager;
        locationManager.delegate = self;*/
       // [_locationManager startUpdatingLocation];
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];
    
    UIColor *textColor = [UIColor colorWithRed:(109.0f/255.0f) green:(110.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f];
    
    // Gradient background Background
    UIImageView *background;
    if (self.activity) {
        if (IS_IPHONE_5) {
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit_bg-568h.png"]];
        }else{
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit_bg.png"]];
        }
    }else{
        if (IS_IPHONE_5) {
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_bg-568h.png"]];
        }else{
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_bg.png"]];
        }
    }
    
    
    background.frame = CGRectMake(0.0f, -219.0f, 320.0f, 699.0f + KIphone5Margin);
    [self.view addSubview:background];
    
    // FormGrid
    _formGrid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_world.png"]];
    CGRect formGridFrame = _formGrid.frame;
    formGridFrame.origin.x = 10.0f;
    formGridFrame.origin.y = self.view.frame.size.height - 57 - 10 - 47 - 142;
    _formGrid.frame = formGridFrame;
    [_formGrid setUserInteractionEnabled:YES];
    
    _name = [[UITextField alloc] initWithFrame:CGRectMake(18.0f, 0.0f, 280.0, 47.0)];
    _name.placeholder = @"Title";
    _name.textColor = textColor;
    _name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _name.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _name.text = self.activity.title;
    _name.rightViewMode = UITextFieldViewModeAlways;
    _name.rightView.bounds = CGRectMake(self.name.rightView.frame.size.width - 47.0, 0.0, 47.0, 47.0);
    _name.delegate = self;
    [_name setReturnKeyType:UIReturnKeyNext];
    [_formGrid addSubview:_name];
    
    _start = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 47.5f, 110.0f, 47.0f)];
    _start.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
    _start.textColor = textColor;
    // Create the gesture to trigger the date picker
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDayTime:)];
    [_start addGestureRecognizer:tapRecognizer];
    
    // Set the time formatter and the start time
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"d MMM HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (self.activity) {
        self.start.text = [dateFormatter stringFromDate:self.activity.start];
        self.dateTime = self.activity.start;
    } else {
        self.start.text = [dateFormatter stringFromDate:[NSDate date]];
        self.dateTime =[NSDate date];
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
    
    
    
    findLocationButton = [[UIView alloc] initWithFrame:CGRectMake(47.5f, 95.0f, 252.5, 47.0)];
    
    _locationName = [[UILabel alloc] initWithFrame:CGRectMake(18.0, 0.0, 226.5, 47.0)];
    if (self.activity) {
        _locationName.text = [self.activity locationDescription];
    }else{
        _locationName.text = @"Current location";
        findLocationButton.userInteractionEnabled = NO;
    }
    [findLocationButton addSubview:_locationName];
    _locationName.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    _locationName.textColor = [UIColor colorWithRed:26.0f/255.0f green:144.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    
    findLocationButton.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];
    
    UITapGestureRecognizer *fl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerFindLocation:)];
    tgr.delegate = self;
    [findLocationButton addGestureRecognizer:fl];
    
    
    
    [_formGrid addSubview:findLocationButton];
    

    _description = [[UITextView alloc] init];
    self.detailsPlaceholder = [[UICanuTextField alloc] initWithFrame:CGRectMake(10.0f, self.view.frame.size.height - 57 - 10 - 47 + 15, 300.0f, 24)];
    self.detailsPlaceholder.backgroundColor = [UIColor clearColor];
    self.detailsPlaceholder.placeholder = @"Details";
    self.detailsPlaceholder.delegate = self;
    [self.view addSubview:_detailsPlaceholder];
    if (!self.activity.description || [self.activity.description isEqualToString:@""]) {
        _description.frame = CGRectMake(10.0f, self.view.frame.size.height - 57 - 10 - 47, 300.0f, 47.0);
        _description.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
    } else {
        _formGrid.frame = CGRectMake(10.0, self.view.frame.size.height - 57 - 10 - 47 - 197, _formGrid.frame.size.width, _formGrid.frame.size.height);
        _description.frame = CGRectMake(10.0, self.view.frame.size.height - 57 - 10 - 101.5f, 300.0f, 101.0f);
        _description.backgroundColor = [UIColor colorWithWhite:255.0f alpha:1.0f];
    }
    _description.text = self.activity.description;
    _description.font = [UIFont fontWithName:@"Lato-Regular" size:12.0f];
    _description.textColor = textColor;
    _description.delegate = self;
    _description.returnKeyType = UIReturnKeySend;
    [self.view addSubview:_description];
    [self.view addSubview:_formGrid];
    
    
    // Set the toolbar
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 57, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    //set the create button
   
    if (self.activity) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(194.0f, 10.0f, 116.0f, 36.0f);
        [_saveButton setImage:[UIImage imageNamed:@"edit_save.png"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(67.0f, 10.0f, 116.0f, 36.0f);
        [_deleteButton setImage:[UIImage imageNamed:@"edit_delete.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteActivity:) forControlEvents:UIControlEventTouchUpInside];
    
        [_toolBar addSubview:_saveButton];
        [_toolBar addSubview:_deleteButton];
    } else {
         _createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createButton setImage:[UIImage imageNamed:@"create_active.png"] forState:UIControlStateNormal];
        [_createButton setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _createButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
        [_createButton setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
        [_createButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:_createButton];
    }
    
    // Activity Indicator
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingIndicator.center = CGPointMake(188.5f, 28.5f);
    [_toolBar addSubview:_loadingIndicator];
    
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
    [self presentViewController:findLocations animated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == _name) {
        [_description becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        if (textView.text.length >= 140 && range.length == 0)
            return NO;
    }
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_name resignFirstResponder];
    [_description resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        _formGrid.frame = CGRectMake(10.0, self.view.frame.size.height - 216 - 10 - 47 - 197, _formGrid.frame.size.width, _formGrid.frame.size.height);
        _description.frame = CGRectMake(10.0, self.view.frame.size.height - 10 - 101.5f - 216, 300.0f, 101.0f);
        _description.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([_description hasText]) {
            [UIView animateWithDuration:0.25 animations:^{
                _formGrid.frame = CGRectMake(10.0, self.view.frame.size.height - 57 - 10 - 47 - 197, _formGrid.frame.size.width, _formGrid.frame.size.height);
                _description.frame =CGRectMake(10.0, self.view.frame.size.height - 10 - 101.5f - 57, _description.frame.size.width, 101.0f);
            }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            _formGrid.frame = CGRectMake(10.0, self.view.frame.size.height - 57 - 10 - 47 - 142, _formGrid.frame.size.width, _formGrid.frame.size.height);
            _description.frame =CGRectMake(10.0, self.view.frame.size.height - 57 - 10 - 47, _description.frame.size.width, 47.0f);
            _description.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
        }];
    }

}



- (void)itemMap:(NSNotification*)notification
{
    
    self.location = (MKMapItem *)notification.object;
    self.locationName.text = [[[self.location.placemark addressDictionary] valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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
     _activity = nil;
     _formGrid = nil;
     _name = nil;
     _description = nil;
     _lengthPicker = nil;
     _start = nil;
     _toolBar = nil;
     _backButton = nil;
     _createButton = nil;
     _saveButton = nil;
     _deleteButton = nil;
     _takePictureButton = nil;
     _location = nil;
     _locationName = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
   
    
    [super viewWillDisappear:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
