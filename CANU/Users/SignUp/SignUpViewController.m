//
//  SignUpViewController.m
//  CANU
//
//  Created by Vivien Cormier on 13/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "SignUpViewController.h"

#import "SignUpStep1.h"
#import "SignUpStep2.h"
#import "UICanuButtonSignBottomBar.h"
#import "UICanuTextField.h"
#import "User.h"
#import "CheckPhoneNumber.h"
#import "AppDelegate.h"

@interface SignUpViewController () <SignUpStep1Delegate,SignUpStep2Delegate>

@property (nonatomic) UIView *wrapper;
@property (nonatomic) BOOL isForCheckPhoneNumber;
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
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_wrapper];
    
    UIView *bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 57, self.view.frame.size.width, 57)];
    bottomBar.backgroundColor = UIColorFromRGB(0xf4f4f4);
    [self.wrapper addSubview:bottomBar];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchDown];
    [bottomBar addSubview:self.backButton];
    
    if (!_isForCheckPhoneNumber) {
        
        self.buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0) andBlue:YES];
        [self.buttonAction setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
        [self.buttonAction addTarget:self action:@selector(signUpStep1CheckUsername) forControlEvents:UIControlEventTouchDown];
        [bottomBar addSubview:_buttonAction];
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.frame = CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0);
        [bottomBar addSubview:_loadingIndicator];
        
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
        
        if (!_checkPhoneNumber) {
            self.checkPhoneNumber = [[CheckPhoneNumber alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) AndParentViewController:self];
            [self.wrapper addSubview:_checkPhoneNumber];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.checkPhoneNumber.frame = CGRectMake(0, _checkPhoneNumber.frame.origin.y, _checkPhoneNumber.frame.size.width, _checkPhoneNumber.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

- (void)backHome{
    
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
        [self.backButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchDown];
        
        [self.buttonAction setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
        [self.buttonAction removeTarget:self action:@selector(signUpUser) forControlEvents:UIControlEventTouchDown];
        [self.buttonAction addTarget:self action:@selector(checkUsername) forControlEvents:UIControlEventTouchDown];
        
    }];
    
}

- (void)signUpStep1CheckUsername{
    
    [self checkUsername];
    
}

- (void)checkUsername{
    
//    [User CheckUsername:self.step1.userName.text Block:^(NSError *error) {
//        if (!error) {
//            [self gotToStep2];
//            self.step1.userName.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
//            self.step1.userName.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
//        }else{
//            self.step1.userName.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
//        }
//    }];
    [self gotToStep2];
}

- (void)gotToStep2{
    
    [self.backButton removeTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchDown];
    [self.backButton addTarget:self action:@selector(goToStep1) forControlEvents:UIControlEventTouchDown];
    
    [self.buttonAction setTitle:NSLocalizedString(@"DONE", nil) forState:UIControlStateNormal];
    [self.buttonAction removeTarget:self action:@selector(checkUsername) forControlEvents:UIControlEventTouchDown];
    [self.buttonAction addTarget:self action:@selector(signUpUser) forControlEvents:UIControlEventTouchDown];
    
    [self.step2.name becomeFirstResponder];
    
    if (!_step2) {
        self.step2 = [[SignUpStep2 alloc]initWithFrame:CGRectMake(320, self.view.frame.size.height - 185 - 57, self.view.frame.size.width, 185) AndParentViewController:self];
        self.step2.alpha = 0;
        self.step2.delegate = self;
        [self.wrapper addSubview:_step2];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.step1.frame = CGRectMake(-320, _step1.frame.origin.y, _step1.frame.size.width, _step1.frame.size.height);
        self.step1.alpha = 0;
        self.step2.frame = CGRectMake(0, _step2.frame.origin.y, _step2.frame.size.width, _step2.frame.size.height);
        self.step2.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)signUpUser{
    
    UIImage *profileImage = [self.step2.takePictureButton.imageView.image isEqual:[UIImage imageNamed:@"icon_userpic.png"]] ? nil : self.step2.takePictureButton.imageView.image;
    
    self.buttonAction.hidden = YES;
    [self.loadingIndicator startAnimating];
    
    [User SignUpWithUserName:self.step1.userName.text Password:self.step1.password.text FirstName:self.step2.name.text LastName:@"" Email:self.step2.email.text ProfilePicture:profileImage Block:^(User *user, NSError *error) {
        
        NSLog(@"%@",[[error localizedRecoverySuggestion] componentsSeparatedByString:@"\""]);
        
        if (error) {
            if ([[error localizedRecoverySuggestion] rangeOfString:@"email"].location != NSNotFound || self.step2.email.text == nil) {
                self.step2.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
            }else{
                self.step2.email.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
            }
            if ([[error localizedRecoverySuggestion] rangeOfString:@"first_name"].location != NSNotFound || self.step2.name.text == nil) {
                self.step2.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bad.png"]];
            }else{
                self.step2.name.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_good.png"]];
            }
            
            self.buttonAction.hidden = NO;
            [self.loadingIndicator stopAnimating];
            
        }else{
            if (user){
                AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
                [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
                
                [user updateDeviceToken:appDelegate.device_token Block:^(NSError *error){
                    
                    if (error) {
                        NSLog(@"Request Failed with Error: %@", [error.userInfo valueForKey:@"NSLocalizedRecoverySuggestion"]);
                    }else{
                        NSLog(@"lsdkjflsdkfjlsdkfjsldkfj");
                    }
                    
                    [self goToPhoneNumber];
                    
                    [self.loadingIndicator stopAnimating];
                    
                }];
                
            }
        }
        
    }];
    
}

-(void)goToPhoneNumber{
    
    if (!_checkPhoneNumber) {
        
        self.checkPhoneNumber = [[CheckPhoneNumber alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) AndParentViewController:self];
        [self.wrapper addSubview:_checkPhoneNumber];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.step2.frame = CGRectMake(-320, _step2.frame.origin.y, _step2.frame.size.width, _step2.frame.size.height);
        self.step2.alpha = 0;
        self.checkPhoneNumber.frame = CGRectMake(0, _checkPhoneNumber.frame.origin.y, _checkPhoneNumber.frame.size.width, _checkPhoneNumber.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
