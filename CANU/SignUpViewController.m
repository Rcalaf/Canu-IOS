//
//  SignUpViewController.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SignUpViewController.h"
#import "AFCanuAPIClient.h"
#import "AppDelegate.h"
#import "UICanuTextField.h"


@interface SignUpViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
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
@synthesize name = _name;
@synthesize lastName = _lastName;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.facebookButton setTitle:@"Unlink Facebook" forState:UIControlStateNormal];
        [self.facebookButton setImage:[UIImage imageNamed:@"facebook_btn_on.png"] forState:UIControlStateNormal];
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 NSString *userInfo = @"";
                 
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Name: %@\n\n",
                              user.first_name]];
                 self.name.text = user.first_name;
                 
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Last Name: %@\n\n",
                              user.last_name]];
                self.name.text = [self.name.text stringByAppendingFormat:@" %@",user.last_name];
                 
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"Email: %@\n\n",
                              [user objectForKey:@"email"]]];
                 self.email.text = [user objectForKey:@"email"];
                 // Display the user info
                // [self authButtonAction:self.authButton];
                 
             }
         }];
    } else {
        [self.facebookButton setTitle:@"Link Facebook" forState:UIControlStateNormal];
    }
}

- (IBAction)authButtonAction:(id)sender {
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
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
    /*
    NSString *alertMessage = @"";
    if([self.name.text isEqualToString: @"name"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                         self.name.text]];
    }
    if([self.email.text isEqualToString: @"email"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                         self.email.text]];
    }
    if([self.userName.text isEqualToString: @"user name"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                         self.userName.text]];
    }
    if([self.password.text isEqualToString: @"password"]){
        alertMessage = [alertMessage
                        stringByAppendingString:
                        [NSString stringWithFormat:@"%@ must be set\n",
                        self.password.text]];
    }
    if(![alertMessage isEqualToString:@""]){
        UIAlertView *signInVerificationErrors = [[UIAlertView alloc] initWithTitle:@"Sign in Verification" message:alertMessage delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [signInVerificationErrors show];
    }*/
    
    
    //Another userName existance verification
    NSArray *objectsArray = [NSArray arrayWithObjects:self.userName.text,self.password.text,self.name.text,self.email.text,nil];
    NSArray *keysArray = [NSArray arrayWithObjects:@"username",@"password",@"first_name",@"email",nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects: objectsArray forKeys: keysArray];
    
    
    [[AFCanuAPIClient sharedClient] postPath:@"users/" parameters:parameters
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         NSLog(@"%@",operation);
                                         NSLog(@"%@",JSON);
                                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //NSLog(@"%@",operation);
                                         NSLog(@"%@",error);
                                     }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (self.userName == textField) {
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    else if (self.password == textField) {
        [textField resignFirstResponder];
        [self.name becomeFirstResponder];
    }
    else if (self.name == textField) {
        [textField resignFirstResponder];
        [self.email becomeFirstResponder];
    }
    else if (self.email == textField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(void) loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"intro_bg.png"]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 403)];
    _scrollView.contentSize = CGSizeMake(320.0, 432.0);
    
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10.0, 137.0, 300.0, 94.5)];
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
    
    container = [[UIView alloc] initWithFrame:CGRectMake(10.0, 298.0, 300.0, 94.5)];
    [container setBackgroundColor:[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1]];
    
    self.name = [[UICanuTextField alloc] initWithFrame:CGRectMake(95, 0.0, 205, 47.0)];
    self.name.placeholder = @"Full name";
    [self.name setReturnKeyType:UIReturnKeyNext];
    self.name.delegate = self;
    [container addSubview:self.name];
    
    self.email = [[UICanuTextField alloc] initWithFrame:CGRectMake(95, 47.5, 205, 47.0)];
    self.email.placeholder = @"E-mail";
    self.email.delegate = self;
    [self.email setReturnKeyType:UIReturnKeyGo];
    [container addSubview:self.email];
    
    _takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_takePictureButton setFrame:CGRectMake(0.0, 0.0, 94.5, 94.5)];
    [_takePictureButton setImage:[UIImage imageNamed:@"icon_userpic.png"] forState:UIControlStateNormal];
    
    [container addSubview:_takePictureButton];
    
    [_scrollView addSubview:container];
    
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookButton setImage:[UIImage imageNamed:@"facebook_btn_off.png"] forState:UIControlStateNormal];
    [self.facebookButton addTarget:self action:@selector(authButtonAction:) forControlEvents:UIControlEventTouchDown];
    self.facebookButton.frame = CGRectMake(10.0, 241.5, 300.0, 47.0);
    [self.facebookButton setTitle:@"Link Facebook" forState:UIControlStateNormal];
    [_scrollView addSubview:self.facebookButton];
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    _toolBar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signInButton setTitle:@"GET GOING" forState:UIControlStateNormal];
    [_signInButton setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
    [_signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signInButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
    [_signInButton setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
    
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
    //self.picture.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    // NSLog(@"%@",[info valueForKey:UIImagePickerControllerEditedImage]);
    [self dismissViewControllerAnimated:YES completion:^{
    }];

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


-(void)viewDidDisappear:(BOOL)animated
{
   /* _userName = nil;
    _password= nil;
    _name= nil;
    _lastName= nil;
    _email= nil;
    _facebookButton= nil;
    _toolBar= nil;
    _backButton= nil;
    _signIn= nil;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
