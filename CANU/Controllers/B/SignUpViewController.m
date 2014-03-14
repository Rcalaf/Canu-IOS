//
//  SignUpViewController.m
//  CANU
//
//  Created by Vivien Cormier on 13/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "SignUpViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import "SignUpStep1.h"
#import "SignUpStep2.h"
#import "UICanuButtonSignBottomBar.h"
#import "UICanuTextField.h"
#import "User.h"
#import "CheckPhoneNumber.h"
#import "AppDelegate.h"
#import "PrivacyPolicyViewController.h"
#import "UserManager.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SignUpViewController () <SignUpStep1Delegate,SignUpStep2Delegate>

@property (nonatomic) UIView *bottomBar;
@property (nonatomic) UIView *wrapper;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) SignUpStep1 *step1;
@property (nonatomic) SignUpStep2 *step2;
@property (nonatomic) UICanuButtonSignBottomBar *buttonAction;
@property (nonatomic) CheckPhoneNumber *checkPhoneNumber;

@end

@implementation SignUpViewController

- (id)initForCheckPhonenumber:(BOOL)isForCheckPhoneNumber
{
    self = [super init];
    if (self) {
        self.isForCheckPhoneNumber = isForCheckPhoneNumber;
    }
    return self;
}

- (void)loadView{
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, result.width, result.height)];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:FBSessionStateChangedNotification
                                               object:nil];
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_wrapper];
    
    self.bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 57, self.view.frame.size.width, 57)];
    self.bottomBar .backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.wrapper addSubview:self.bottomBar ];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
    [self.bottomBar  addSubview:self.backButton];
    
    if (!_isForCheckPhoneNumber) {
        
        self.buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0) andBlue:YES];
        [self.buttonAction setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
        [self.buttonAction addTarget:self action:@selector(signUpStep1CheckUsername) forControlEvents:UIControlEventTouchDown];
        [self.bottomBar  addSubview:_buttonAction];
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.frame = CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0);
        [self.bottomBar  addSubview:_loadingIndicator];
        
        // Step1
        
        self.step1 = [[SignUpStep1 alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185)];
        self.step1.delegate = self;
        [self.wrapper addSubview:self.step1];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self.step1 openAnimation];
            [UIView animateWithDuration:0.3 animations:^{
                self.wrapper.frame = CGRectMake(0, - 216, self.view.frame.size.width, self.view.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }else{
        
        self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 57);
        
        self.checkPhoneNumber = [[CheckPhoneNumber alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) AndParentViewController:self];
        [self.wrapper addSubview:_checkPhoneNumber];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.checkPhoneNumber.frame = CGRectMake(0, _checkPhoneNumber.frame.origin.y, _checkPhoneNumber.frame.size.width, _checkPhoneNumber.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

#pragma mark - Animation Step

- (void)goToHome{
    
    [self.step1.userName resignFirstResponder];
    [self.step1.password resignFirstResponder];
    
    [self.step2.name resignFirstResponder];
    [self.step2.email resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        [self.delegate signUpGoBackHome];
    }];
    
}

- (void)goToStep1{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.step1.frame = CGRectMake(0, _step1.frame.origin.y, _step1.frame.size.width, _step1.frame.size.height);
        self.step1.alpha = 1;
        self.step2.frame = CGRectMake(320, _step2.frame.origin.y, _step2.frame.size.width, _step2.frame.size.height);
        self.step2.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.step1.userName becomeFirstResponder];
        [self.step1.password resignFirstResponder];
        
        [self.step2.name resignFirstResponder];
        [self.step2.email resignFirstResponder];
        
        [self.backButton removeTarget:self action:@selector(goToStep1) forControlEvents:UIControlEventTouchDown];
        [self.backButton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
        
        [self.buttonAction setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
        [self.buttonAction removeTarget:self action:@selector(signUpUser) forControlEvents:UIControlEventTouchDown];
        [self.buttonAction addTarget:self action:@selector(signUpStep1CheckUsername) forControlEvents:UIControlEventTouchDown];
        
    }];
    
}

- (void)gotToStep2{
    
    [self.backButton removeTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(goToStep1) forControlEvents:UIControlEventTouchDown];
    
    [self.buttonAction setTitle:NSLocalizedString(@"DONE", nil) forState:UIControlStateNormal];
    [self.buttonAction removeTarget:self action:@selector(signUpStep1CheckUsername) forControlEvents:UIControlEventTouchDown];
    [self.buttonAction addTarget:self action:@selector(signUpUser) forControlEvents:UIControlEventTouchDown];
    
    [self.step2.name becomeFirstResponder];
    
    [self.delegate checkPhoneNumberDidDisappear];
    
    if (!_step2) {
        self.step2 = [[SignUpStep2 alloc]initWithFrame:CGRectMake(320, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185) AndParentViewController:self];
        self.step2.alpha = 0;
        self.step2.delegate = self;
        [self.wrapper addSubview:_step2];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"Step2" value:nil] build]];
        
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.step1.frame = CGRectMake(-320, _step1.frame.origin.y, _step1.frame.size.width, _step1.frame.size.height);
        self.step1.alpha = 0;
        self.step2.frame = CGRectMake(0, _step2.frame.origin.y, _step2.frame.size.width, _step2.frame.size.height);
        self.step2.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)goToPhoneNumber{
    
    if (!_checkPhoneNumber) {
        self.checkPhoneNumber = [[CheckPhoneNumber alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) AndParentViewController:self];
        [self.wrapper addSubview:_checkPhoneNumber];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"checkNumber" value:nil] build]];
        if (self.step2.facebookGrapgUsed) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"FacebookGraph" label:@"YES" value:nil] build]];
        } else {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"FacebookGraph" label:@"NO" value:nil] build]];
        }
        
    }
    
    [self.backButton removeTarget:self action:@selector(goToStep1) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
    
    [self.delegate checkPhoneNumberDidAppear];
    
    [self.step1.userName resignFirstResponder];
    [self.step1.password resignFirstResponder];
    
    [self.step2.name resignFirstResponder];
    [self.step2.email resignFirstResponder];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 57);
        self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.step2.frame = CGRectMake(-320, _step2.frame.origin.y, _step2.frame.size.width, _step2.frame.size.height);
        self.step2.alpha = 0;
        self.checkPhoneNumber.frame = CGRectMake(0, _checkPhoneNumber.frame.origin.y, _checkPhoneNumber.frame.size.width, _checkPhoneNumber.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

# pragma mark - Check Sign Up

- (void)signUpStep1CheckUsername{
    
    if ([self.step1.password.text isEqualToString:@""] || self.step1.password.text  == nil || [self.step1.userName.text isEqualToString:@""] || self.step1.userName.text  == nil) {
        
        if ([self.step1.userName.text isEqualToString:@""] || self.step1.userName.text  == nil) self.step1.userName.valueValide = NO;
        else  self.step1.userName.rightView = nil;
        if ([self.step1.password.text isEqualToString:@""] || self.step1.password.text  == nil) self.step1.password.valueValide = NO;
        else  self.step1.password.rightView = nil;
        
        return;
        
    }
    
    self.buttonAction.hidden = YES;
    [self.loadingIndicator startAnimating];
    
    [User checkUsername:self.step1.userName.text Block:^(NSError *error) {
        if (!error) {
            
            [self gotToStep2];
            self.step1.userName.valueValide = YES;
            self.step1.password.valueValide = YES;
            
        }else{
            self.step1.userName.valueValide = NO;
        }
        
        self.buttonAction.hidden = NO;
        [self.loadingIndicator stopAnimating];
        
    }];
    
}

- (void)signUpUser{
    
    UIImage *profileImage = [self.step2.takePictureButton.imageView.image isEqual:[UIImage imageNamed:@"icon_userpic.png"]] ? nil : self.step2.takePictureButton.imageView.image;
    
    self.buttonAction.hidden = YES;
    [self.loadingIndicator startAnimating];
    
    [User SignUpWithUserName:self.step1.userName.text Password:self.step1.password.text FirstName:self.step2.name.text LastName:@"" Email:self.step2.email.text ProfilePicture:profileImage Block:^(User *user, NSError *error) {
        
        if (error) {
            if ([[error localizedRecoverySuggestion] rangeOfString:@"email"].location != NSNotFound || self.step2.email.text == nil) {
                self.step2.email.valueValide = NO;
            }else{
                self.step2.email.valueValide = YES;
            }
            if ([[error localizedRecoverySuggestion] rangeOfString:@"first_name"].location != NSNotFound || self.step2.name.text == nil) {
                self.step2.name.valueValide = NO;
            }else{
                self.step2.name.valueValide = YES;
            }
            
            self.buttonAction.hidden = NO;
            [self.loadingIndicator stopAnimating];
            
        }else{
            if (user){
                
                AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [[UserManager sharedUserManager] updateUser:user];
                
                [user updateDeviceToken:appDelegate.device_token Block:^(NSError *error){
                    
                    if (error) {
                        NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                    }
                    
                    [self goToPhoneNumber];
                    
                    [self.loadingIndicator stopAnimating];
                    
                }];
                
            }
        }
        
    }];
    
}

#pragma Mark - Facebook Grab

- (void)facebookGrab{
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
        [appDelegate openSessionWithAllowLoginUI:YES];
    } else {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
    
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 
                 NSString *firstName = @"";
                 NSString *lastName = @"";
                 NSString *username = @"";
                 NSString *mail = @"";
                 
                 if ([user objectForKey:@"first_name"] != [NSNull null] && [user objectForKey:@"first_name"] != nil) {
                     firstName = [user objectForKey:@"first_name"];
                 }
                 
                 if ([user objectForKey:@"last_name"] != [NSNull null] && [user objectForKey:@"last_name"] != nil) {
                     lastName = [user objectForKey:@"last_name"];
                 }
                 
                 if ([user objectForKey:@"username"] != [NSNull null] && [user objectForKey:@"username"] != nil) {
                     username = [user objectForKey:@"username"];
                 }
                 
                 if ([user objectForKey:@"email"] != [NSNull null] && [user objectForKey:@"email"] != nil) {
                     mail = [user objectForKey:@"email"];
                 }
                 
                 self.step2.name.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
                 
                 self.step2.email.text = mail;
                 
                 NSURL *facebookGraphUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",username]];

                 UIImage *myImage = [self imageCroppedSquare:[UIImage imageWithData:
                                                             [NSData dataWithContentsOfURL:facebookGraphUrl]]];
                 
                 [self.step2.takePictureButton setImage:myImage forState:UIControlStateNormal];
                 
             }
         }];
    }
    
}

- (UIImage *)imageCroppedSquare:(UIImage *)image{

    double minSize = image.size.height;
    
    if (minSize > image.size.width) {
        minSize = image.size.width;
    }
    
    double x = (image.size.width - minSize) / 2.0;
    double y = (image.size.height - minSize) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, minSize, minSize);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

#pragma mark - Keyboard

-(void)signUpStep1textFieldShouldAppear{
    if (self.wrapper.frame.origin.y == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(0, -216, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void)signUpStep2textFieldShouldAppear{
    if (self.wrapper.frame.origin.y == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(0, -216, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void)signUpStep2textFieldShouldDisappear{
    if (self.wrapper.frame.origin.y == -216) {
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

#pragma Mark - Terms & Pricavy Policy

- (void)openPrivacyPolicy{
    PrivacyPolicyViewController *privacy = [[PrivacyPolicyViewController alloc]initForTerms:NO];
    [self presentViewController:privacy animated:YES completion:^{
        if (self.wrapper.frame.origin.y == -216) {
            [UIView animateWithDuration:0.3 animations:^{
                self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }];
}

- (void)openTerms{
    PrivacyPolicyViewController *privacy = [[PrivacyPolicyViewController alloc]initForTerms:YES];
    [self presentViewController:privacy animated:YES completion:^{
        if (self.wrapper.frame.origin.y == -216) {
            [UIView animateWithDuration:0.3 animations:^{
                self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
