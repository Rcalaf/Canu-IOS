//
//  SignUpViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SignUpViewController.h"
#import "UICanuNavigationController.h"
//#import "UserProfileViewController.h"
#import "TutorialViewController.h"
#import "ActivitiesFeedViewController.h"
#import "AFCanuAPIClient.h"
#import "AppDelegate.h"
#import "UICanuTextField.h"
#import "User.h"

#define kTakeUserPic [UIImage imageNamed:@"icon_userpic.png"] 
#define kNoUserPic [UIImage imageNamed:@"icon_username.png"] 

@interface SignUpViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *toolBar;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *signInButon;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;

- (void)sessionStateChanged:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;


@end

@implementation SignUpViewController 

@synthesize userName = _userName;
@synthesize password = _password;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize name = _name;
@synthesize email = _email;
@synthesize facebookButton = _facebookButton;
@synthesize toolBar = _toolBar;
@synthesize backButton = _backButton;
@synthesize signInButon = _signInButton;
@synthesize scrollView = _scrollView;
@synthesize takePictureButton = _takePictureButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        // Custom initialization
    }
    return self;
}

-(IBAction)back:(id)sender
{
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.facebookButton setImage:[UIImage imageNamed:@"facebook_btn_on.png"] forState:UIControlStateNormal];
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 self.firstName = user.first_name;
                 self.lastName = user.last_name;
                 
                 self.name.text = [self.firstName stringByAppendingFormat:@" %@",self.lastName];
                 
                 self.email.text = [user objectForKey:@"email"];

                 NSURL *facebookGraphUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@.%@/picture?type=large",user.first_name,user.last_name]];
                 
                 UIImage* myImage = [UIImage imageWithData:
                                     [NSData dataWithContentsOfURL:facebookGraphUrl]];

                 [_takePictureButton setImage:myImage forState:UIControlStateNormal];
                 
                 //NSLog(@"%@",myImage);
             }
         }];
    } else {
        [self.facebookButton setTitle:@"Link Facebook" forState:UIControlStateNormal];
    }
}

- (IBAction)authButtonAction:(id)sender {
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [self.facebookButton setImage:[UIImage imageNamed:@"facebook_btn_off.png"] forState:UIControlStateNormal];
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}

- (IBAction)performSingUp:(id)sender
{
    
    
    UIImage *profileImage = [_takePictureButton.imageView.image isEqual:kTakeUserPic] ? nil : _takePictureButton.imageView.image;
    
    [User SignUpWithUserName:self.userName.text Password:self.password.text FirstName:self.name.text LastName:self.lastName Email:self.email.text ProfilePicture:profileImage Block:^(User *user, NSError *error) {
        
       /* if (error != nil) {
         [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
         message:[error localizedDescription]
         delegate:nil
         cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
         return;
         }*/
        
        NSLog(@"%@",[[error localizedRecoverySuggestion] componentsSeparatedByString:@"\""]);
        
        if ([[error localizedRecoverySuggestion] rangeOfString:@"email"].location != NSNotFound || self.email.text == nil) {
            self.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
        }else{
            self.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
        }
        if ([[error localizedRecoverySuggestion] rangeOfString:@"password"].location != NSNotFound || self.password.text == nil) {
            self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
        }else{
            self.password.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
        }
        if ([[error localizedRecoverySuggestion] rangeOfString:@"user_name"].location != NSNotFound || self.userName.text == nil) {
            self.userName.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
        }else{
            self.userName.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
        }
        if ([[error localizedRecoverySuggestion] rangeOfString:@"first_name"].location != NSNotFound || self.name.text == nil) {
            self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
        }else{
            self.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
        }
       
        if (user){
            AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
            [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];            
            
            UICanuNavigationController *nvc = [[UICanuNavigationController alloc] init];
            ActivitiesFeedViewController *avc = appDelegate.publicFeedViewController;
            [nvc addChildViewController:avc];
            appDelegate.window.rootViewController = nvc;
            
            TutorialViewController *tutorial = [[TutorialViewController alloc] init];
            [nvc presentViewController:tutorial animated:YES completion:nil];
            
        }
    }];

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint offset;
    //textField.backgroundColor = [UIColor redColor];
    if (self.userName == textField) {
        offset = CGPointMake(0.0, 0.0);
    }
    else if (self.password == textField) {
        offset = CGPointMake(0.0, 0.0);
    }
    else if (self.name == textField) {
        offset = CGPointMake(0.0, 159.0);
    }
    else if (self.email == textField) {
        offset = CGPointMake(0.0, 159.0);
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 159.0);
    
    [UIView animateWithDuration:0.25 animations:^{
        [_scrollView setContentOffset:offset animated:YES];
    }];
    return YES;
}


-(void) loadView
{
    [super loadView];
    
    if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hello_bg-568h.png"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hello_bg.png"]];
    }

    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 403 + KIphone5Margin)];
    _scrollView.contentSize = CGSizeMake(320.0, 432.0);
    
   // _scrollView.delegate = self;
    
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10.0, 137.0 + KIphone5Margin, 300.0, 94.5)];
    [container setBackgroundColor:[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1]];
    
    UIView *userIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 47.0, 47.0)];
    UIView *lockerIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 47.5, 47.0, 47.0)];
    userIconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_username.png"]];
    lockerIconView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_password.png"]];
    
    [container addSubview:userIconView];
    [container addSubview:lockerIconView];
    
    
    
    
    
    self.userName = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 0.0, 252.5, 47.0)];
    self.userName.placeholder = @"Username";
    [self.userName setReturnKeyType:UIReturnKeyNext];
    self.userName.delegate = self;
    [container addSubview:self.userName];
    
    self.password = [[UICanuTextField alloc] initWithFrame:CGRectMake(47.5, 47.5, 252.5, 47.0)];
    self.password.placeholder = @"Password";
    [self.password setReturnKeyType:UIReturnKeyNext];
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [container addSubview:self.password];
    
    
    [_scrollView addSubview:container];
    
    container = [[UIView alloc] initWithFrame:CGRectMake(10.0, 298.0 + KIphone5Margin, 300.0, 94.5)];
    [container setBackgroundColor:[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1]];
    
    self.name = [[UICanuTextField alloc] initWithFrame:CGRectMake(95, 0.0, 205, 47.0)];
    self.name.placeholder = @"Full name";
    [self.name setReturnKeyType:UIReturnKeyNext];
    self.name.delegate = self;
    [container addSubview:self.name];
    
    self.email = [[UICanuTextField alloc] initWithFrame:CGRectMake(95, 47.5, 205, 47.0)];
    self.email.placeholder = @"E-mail";
    self.email.delegate = self;
    self.email.keyboardType = UIKeyboardTypeEmailAddress;
    [self.email setReturnKeyType:UIReturnKeyGo];
    [container addSubview:self.email];
    
    _takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_takePictureButton setFrame:CGRectMake(0.0, 0.0, 94.5, 94.5)];
    [_takePictureButton setImage:[UIImage imageNamed:@"icon_userpic.png"] forState:UIControlStateNormal];
    
    [container addSubview:_takePictureButton];
    
    [_scrollView addSubview:container];
    
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (FBSession.activeSession.isOpen) {
        [self.facebookButton setImage:[UIImage imageNamed:@"facebook_btn_on.png"] forState:UIControlStateNormal]; 
    }else{
        [self.facebookButton setImage:[UIImage imageNamed:@"facebook_btn_off.png"] forState:UIControlStateNormal];
    }
    [self.facebookButton addTarget:self action:@selector(authButtonAction:) forControlEvents:UIControlEventTouchDown];
    self.facebookButton.frame = CGRectMake(10.0, 241.5 + KIphone5Margin, 300.0, 47.0);
    [self.facebookButton setTitle:@"Link Facebook" forState:UIControlStateNormal];
    [_scrollView addSubview:self.facebookButton];
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5 + KIphone5Margin, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signInButton setTitle:@"GET GOING" forState:UIControlStateNormal];
    [_signInButton setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
    [_signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signInButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_signInButton setBackgroundColor:[UIColor colorWithRed:(28.0 / 255.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
    
    [_toolBar addSubview:_signInButton];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    
    [_toolBar addSubview:_backButton];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_toolBar];
    

   
}

-(IBAction)takePic:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose an existing one",@"Take a picutre", nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"Done");
        }];
    } else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePicker animated:YES completion:^{
                NSLog(@"Done");
            }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
 //   NSLog(@"%@",[info valueForKey:UIImagePickerControllerEditedImage]);
    
    //self.picture.image = [info valueForKey:UIImagePickerControllerEditedImage];
    [_takePictureButton setImage:[info valueForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGPoint offset;
    if ([self.userName isFirstResponder]) {
        offset = CGPointMake(0.0, 0.0);
    }
    else if ([self.password isFirstResponder]) {
        offset = CGPointMake(0.0, 0.0);
    }
    else if ([self.name isFirstResponder]) {
        offset = CGPointMake(0.0, 159.0);
    }
    else if ([self.email isFirstResponder]) {
        offset = CGPointMake(0.0, 159.0);
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 159.0);

    [UIView animateWithDuration:0.25 animations:^{
        [_scrollView setContentOffset:offset animated:YES];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{    
    [UIView animateWithDuration:0.25 animations:^{
        [_scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      //self.navigationController.navigationBarHidden = NO;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_takePictureButton addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
    [_signInButton addTarget:self action:@selector(performSingUp:) forControlEvents:UIControlEventTouchUpInside];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:FBSessionStateChangedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"sign up" style:UIBarButtonItemStyleBordered target:self action:@selector(performSingUp:)];
	// Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    _userName = nil;
    _password= nil;
    _name= nil;
    _lastName= nil;
    _email= nil;
    _facebookButton= nil;
    _toolBar= nil;
    _backButton= nil;
    _signInButton= nil;
    _takePictureButton = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
