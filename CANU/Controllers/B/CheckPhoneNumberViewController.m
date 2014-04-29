//
//  CheckPhoneNumberViewController.m
//  CANU
//
//  Created by Vivien Cormier on 10/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "CheckPhoneNumberViewController.h"
#import "User.h"
#import "MCC.h"
#import "UICanuTextFieldLine.h"
#import "UICanuScrollPicker.h"
#import "AFCanuAPIClient.h"
#import "UserManager.h"
#import "AppDelegate.h"
#import "UICanuNavigationController.h"
#import "TutorialViewController.h"
#import "ActivitiesFeedViewController.h"
#import "AlertViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface CheckPhoneNumberViewController ()<UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic) NSInteger code;
@property (nonatomic) BOOL isForceVerified;
@property (strong, nonatomic) UIImageView *arrow;
@property (strong, nonatomic) UIPickerView *pickViewCountry;
@property (strong, nonatomic) UILabel *titlePhoneCheck;
@property (strong, nonatomic) UILabel *textPhoneCheck;
@property (strong, nonatomic) UIView *wrapperFieldCountryCode;
@property (strong, nonatomic) UIView *wrapperPhoneNumber;
@property (strong, nonatomic) UIView *wrapperCodePhone;
@property (strong, nonatomic) UILabel *coutry;
@property (strong, nonatomic) UILabel *countryCode;
@property (strong, nonatomic) UILabel *codeShowDev;
@property (strong, nonatomic) UICanuTextFieldLine *phoneNumber;
@property (strong, nonatomic) UITextField *codePhone;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) MCC *mcc;

@property (strong, nonatomic) UILabel *code1;
@property (strong, nonatomic) UILabel *code2;
@property (strong, nonatomic) UILabel *code3;
@property (strong, nonatomic) UILabel *code4;

@end

@implementation CheckPhoneNumberViewController

- (instancetype)initForUser:(User *)user ForceVerified:(BOOL)isForceVerified
{
    self = [super init];
    if (self) {
        self.user = user;
        self.isForceVerified = isForceVerified;
        self.viewType = CheckPhoneNumberViewControllerViewPhoneNumber;
    }
    return self;
}

- (void)loadView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(320, 0, 320, [[UIScreen mainScreen] bounds].size.height - 216 - 45)];
    self.view = view;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mcc = [[MCC alloc]init];
    
    self.titlePhoneCheck = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 30)];
    self.titlePhoneCheck.text = NSLocalizedString(@"Phone check", nil);
    self.titlePhoneCheck.textAlignment = NSTextAlignmentCenter;
    self.titlePhoneCheck.textColor = UIColorFromRGB(0x2b4b58);
    self.titlePhoneCheck.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [self.view addSubview:_titlePhoneCheck];
    
    self.textPhoneCheck = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 320, 30)];
    self.textPhoneCheck.text = NSLocalizedString(@"Please confirm your country code \nand enter your phone number", nil);
    self.textPhoneCheck.numberOfLines = 2;
    self.textPhoneCheck.textAlignment = NSTextAlignmentCenter;
    self.textPhoneCheck.textColor = UIColorFromRGB(0x2b4b58);
    self.textPhoneCheck.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    [self.view addSubview:_textPhoneCheck];
    
    self.wrapperFieldCountryCode = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 300, 45)];
    [self.view addSubview:_wrapperFieldCountryCode];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickCountryCode)];
    [self.wrapperFieldCountryCode addGestureRecognizer:tap];
    
    UIImageView *backgroundField = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 49)];
    backgroundField.image = [UIImage imageNamed:@"B_FieldCodeCountry"];
    [self.wrapperFieldCountryCode addSubview:backgroundField];
    
    self.coutry = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 290, 43)];
    self.coutry.text = self.mcc.country;
    self.coutry.textColor = UIColorFromRGB(0x2b4b58);
    self.coutry.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    [self.wrapperFieldCountryCode addSubview:_coutry];
    
    self.wrapperPhoneNumber = [[UIView alloc]initWithFrame:CGRectMake(10, _wrapperFieldCountryCode.frame.origin.y + _wrapperFieldCountryCode.frame.size.height + 15, 300, 45)];
    [self.view addSubview:_wrapperPhoneNumber];
    
    self.countryCode = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 45)];
    self.countryCode.textColor = UIColorFromRGB(0x2b4b58);
    self.countryCode.text = self.mcc.callingCode;
    self.countryCode.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [self.wrapperPhoneNumber addSubview:_countryCode];
    
    [self.countryCode sizeToFit];
    self.countryCode.frame = CGRectMake(10, 0, _countryCode.frame.size.width, 45);
    
    self.phoneNumber = [[UICanuTextFieldLine alloc]initWithFrame:CGRectMake(10 + _countryCode.frame.size.width + 5, 0, 300 - (10 + _countryCode.frame.size.width + 5) - 10, 45)];
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumber.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [self.phoneNumber becomeFirstResponder];
    self.phoneNumber.placeholder = @"667732101";
    self.phoneNumber.disablePlaceHolderAnimate = YES;
    [self.wrapperPhoneNumber addSubview:_phoneNumber];
    
    // Second step
    
    self.arrow = [[UIImageView alloc]initWithFrame:CGRectMake(60, -26, 200, 26)];
    self.arrow.image = [UIImage imageNamed:@"B_Arrow"];
    [self.view addSubview:_arrow];
    
    self.wrapperCodePhone = [[UIView alloc]initWithFrame:CGRectMake(320, 100 + 45 + 15, 320, 45)];
    [self.view addSubview:_wrapperCodePhone];
    
    self.codePhone = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 320, 45)];
    self.codePhone.delegate = self;
    self.codePhone.hidden = YES;
    self.codePhone.keyboardType = UIKeyboardTypeNumberPad;
    [self.wrapperCodePhone addSubview:_codePhone];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(115, 40, 90, 1)];
    line.backgroundColor = UIColorFromRGB(0xd1dadc);
    [self.wrapperCodePhone addSubview:line];
    
    UILabel *showCode = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 110, 45)];
    showCode.text = @"●   ●   ●   ●";
    showCode.textColor = UIColorFromRGB(0x2b4b58);
    showCode.alpha = 0.3f;
    showCode.font = [UIFont fontWithName:@"Lato-Regular" size:22];
    showCode.textAlignment = NSTextAlignmentCenter;
    [self.wrapperCodePhone addSubview:showCode];
    
    self.code1 = [[UILabel alloc]initWithFrame:CGRectMake(105, 9, 27, 24)];
    self.code1.textColor = UIColorFromRGB(0x2b4b58);
    self.code1.alpha = 0;
    self.code1.textAlignment = NSTextAlignmentCenter;
    self.code1.backgroundColor = backgroundColorView;
    self.code1.font = [UIFont fontWithName:@"Lato-Regular" size:22];
    [self.wrapperCodePhone addSubview:_code1];
    
    self.code2 = [[UILabel alloc]initWithFrame:CGRectMake(105 + 27*1, 9, 27, 24)];
    self.code2.textColor = UIColorFromRGB(0x2b4b58);
    self.code2.alpha = 0;
    self.code2.textAlignment = NSTextAlignmentCenter;
    self.code2.backgroundColor = backgroundColorView;
    self.code2.font = [UIFont fontWithName:@"Lato-Regular" size:22];
    [self.wrapperCodePhone addSubview:_code2];
    
    self.code3 = [[UILabel alloc]initWithFrame:CGRectMake(105 + 27*2, 9, 27, 24)];
    self.code3.textColor = UIColorFromRGB(0x2b4b58);
    self.code3.alpha = 0;
    self.code3.textAlignment = NSTextAlignmentCenter;
    self.code3.backgroundColor = backgroundColorView;
    self.code3.font = [UIFont fontWithName:@"Lato-Regular" size:22];
    [self.wrapperCodePhone addSubview:_code3];
    
    self.code4 = [[UILabel alloc]initWithFrame:CGRectMake(105 + 27*3, 9, 27, 24)];
    self.code4.textColor = UIColorFromRGB(0x2b4b58);
    self.code4.alpha = 0;
    self.code4.textAlignment = NSTextAlignmentCenter;
    self.code4.backgroundColor = backgroundColorView;
    self.code4.font = [UIFont fontWithName:@"Lato-Regular" size:22];
    [self.wrapperCodePhone addSubview:_code4];
    
    if (![AFCanuAPIClient sharedClient].distributionMode) {
        self.codeShowDev = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 45)];
        [self.wrapperCodePhone addSubview:_codeShowDev];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (void)checkPhoneCode{
    
    if (!_isForceVerified) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"TryPhoneCode" value:nil] build]];
    }
    
    NSString *codeString = [NSString stringWithFormat:@"%u",(unsigned)_code];
    
    if ([codeString isEqualToString:_codePhone.text]) {
        
        NSString *phonenumber = [NSString stringWithFormat:@"%@%@",self.countryCode.text,self.phoneNumber.text];
        
        [self.user phoneNumber:phonenumber isVerifiedBlock:^(User *user, NSError *error) {
            
            if (error) {
                NSLog(@"Error");
            }else{
                
                self.user = user;
                
                if (_isForceVerified) {
                    [[UserManager sharedUserManager] updateUser:user];
                } else {
                    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"Finish" value:nil] build]];
                    [[UserManager sharedUserManager] logIn:user];
                }
                
                [self goToFeedViewController];
                
            }
            
        }];
        
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self shakeCodePhone];
    }
    
}

- (void)checkPhoneNumber{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"PhoneCode" value:nil] build]];
    
    self.nextButton.buttonStatus = UICanuButtonStatusDisable;
    
    self.code = arc4random() % 10 + (arc4random() % 10) * 10 + (arc4random() % 10) * 100 + ((arc4random() % 9) + 1) * 1000;
    
    if ([AFCanuAPIClient sharedClient].distributionMode) {
        
        NSString *phonenumber = [NSString stringWithFormat:@"%@%@",self.countryCode.text,self.phoneNumber.text];
        
        phonenumber = [phonenumber substringFromIndex:1];
        if ([self.coutry.text isEqualToString:@"United Kingdom"]) {
            phonenumber = [NSString stringWithFormat:@"00%@",phonenumber];
        }
        
        NSString *text = [NSString stringWithFormat:@"Your code : %u",(unsigned)_code];
        
        NSString *url = [NSString stringWithFormat:@"https://rest.nexmo.com/sms/json?api_key=a86782bd&api_secret=68a115a0&from=CANU&to=%@&text=%@",phonenumber,text];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.wrapperFieldCountryCode.frame = CGRectMake(-310, 100, 300, 45);
                self.wrapperPhoneNumber.frame = CGRectMake(-310, 100 + 45 + 15, 300, 45);
                self.wrapperCodePhone.frame = CGRectMake(0, 100 + 45 + 5, 320, 45);
                self.textPhoneCheck.alpha = 0;
            } completion:^(BOOL finished) {
                self.textPhoneCheck.text = NSLocalizedString(@"Check the sms that has been send to you", nil);
                self.backButton.hidden = NO;
                [UIView animateWithDuration:0.4 animations:^{
                    self.titlePhoneCheck.frame = CGRectMake(0, 85, 320, 30);
                    self.textPhoneCheck.frame = CGRectMake(0, 115, 320, 30);
                    self.textPhoneCheck.alpha = 1;
                    self.arrow.frame = CGRectMake(60, 30, 200, 26);
                    self.backButton.alpha = 1;
                } completion:^(BOOL finished) {
                    [self.codePhone becomeFirstResponder];
                    self.nextButton.buttonStatus = UICanuButtonStatusDisable;
                    self.viewType = CheckPhoneNumberViewControllerViewPhoneCode;
                }];
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.nextButton.buttonStatus = UICanuButtonStatusNormal;
        }];
        
    } else {
        
        self.codeShowDev.text = [NSString stringWithFormat:@"%u",(unsigned)_code];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.wrapperFieldCountryCode.frame = CGRectMake(-310, 100, 300, 45);
            self.wrapperPhoneNumber.frame = CGRectMake(-310, 100 + 45 + 15, 300, 45);
            self.wrapperCodePhone.frame = CGRectMake(0, 100 + 45 + 5, 320, 45);
            self.textPhoneCheck.alpha = 0;
        } completion:^(BOOL finished) {
            self.textPhoneCheck.text = NSLocalizedString(@"Check the sms that has been send to you", nil);
            self.backButton.hidden = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.titlePhoneCheck.frame = CGRectMake(0, 85, 320, 30);
                self.textPhoneCheck.frame = CGRectMake(0, 115, 320, 30);
                self.textPhoneCheck.alpha = 1;
                self.arrow.frame = CGRectMake(60, 30, 200, 26);
                self.backButton.alpha = 1;
            } completion:^(BOOL finished) {
                [self.codePhone becomeFirstResponder];
                self.nextButton.buttonStatus = UICanuButtonStatusDisable;
                self.viewType = CheckPhoneNumberViewControllerViewPhoneCode;
            }];
        }];
        
    }
    
}

- (void)goBackPhoneNumber{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.titlePhoneCheck.frame = CGRectMake(0, 20, 320, 30);
        self.textPhoneCheck.frame = CGRectMake(0, 50, 320, 30);
        self.textPhoneCheck.alpha = 0;
        self.arrow.frame = CGRectMake(60, -26, 200, 26);
        self.backButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.backButton.hidden = YES;
        self.textPhoneCheck.text = NSLocalizedString(@"Please confirm your country code \nand enter your phone number", nil);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.wrapperFieldCountryCode.frame = CGRectMake(10, 100, 300, 45);
            self.wrapperPhoneNumber.frame = CGRectMake(10, 100 + 45 + 15, 300, 45);
            self.wrapperCodePhone.frame = CGRectMake(320, 100 + 45 + 15, 320, 45);
            self.textPhoneCheck.alpha = 1;
        } completion:^(BOOL finished) {
            [self.phoneNumber becomeFirstResponder];
            self.nextButton.buttonStatus = UICanuButtonStatusNormal;
            self.viewType = CheckPhoneNumberViewControllerViewPhoneNumber;
        }];
    }];
    
}

- (void)selectCountry{
    
    self.coutry.text = [self.mcc.countryName_CallingCode_Array objectAtIndex:[self.pickViewCountry selectedRowInComponent:0]];
    
    self.countryCode.text = [self.mcc callingCodeWithCountryName:self.coutry.text];
    
    [self.countryCode sizeToFit];
    self.countryCode.frame = CGRectMake(10, 0, _countryCode.frame.size.width, 45);
    self.phoneNumber.frame = CGRectMake(10 + _countryCode.frame.size.width + 5, 0, 300 - (10 + _countryCode.frame.size.width + 5) - 10, 45);
    
    [self hiddenPickCountryCode];
    
}

- (void)hiddenPickCountryCode{
    
    self.viewType = CheckPhoneNumberViewControllerViewPhoneNumber;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickViewCountry.alpha = 0;
        self.pickViewCountry.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.nextButton.alpha = 0;
        self.backButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.backButton.hidden = NO;
        [self.nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.wrapperPhoneNumber.frame = CGRectMake(10, 100 + 45 + 15, 300, 45);
            self.nextButton.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.wrapperFieldCountryCode.frame = CGRectMake(10, 100, 300, 45);
        } completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.titlePhoneCheck.frame = CGRectMake(0, 20, 320, 30);
            self.textPhoneCheck.frame = CGRectMake(0, 50, 320, 30);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

- (bool)isNumeric:(NSString*) hexText{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    NSNumber* number = [numberFormatter numberFromString:hexText];
    
    if (number != nil) {
        return true;
    }
    
    return false;
}

#pragma mark - Private

- (void)goToFeedViewController{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.canuViewController = [[UICanuNavigationController alloc] initWithActivityFeed:appDelegate.feedViewController];
    [appDelegate.canuViewController pushViewController:appDelegate.feedViewController animated:NO];
    appDelegate.window.rootViewController = appDelegate.canuViewController;
    
    if (!_isForceVerified) {
        appDelegate.feedViewController.activeTutorial = YES;
    } else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types & UIRemoteNotificationTypeAlert){
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            
        } else {
            
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            
            AlertViewController *alert = [[AlertViewController alloc]init];
            alert.canuAlertViewType = CANUAlertViewPopIn;
            alert.canuError = CANUErrorPushNotDetermined;
            
            [appDelegate.window addSubview:alert.view];
            [appDelegate.window.rootViewController addChildViewController:alert];
            
        }
    }
    
}

- (void)showPickCountryCode{
    
    self.viewType = CheckPhoneNumberViewControllerViewChooseCountry;
    
    NSInteger gap = [[UIScreen mainScreen] bounds].size.height - 216 - 45;
    
    if (!_pickViewCountry) {
        self.pickViewCountry = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 10, 300, gap - 10)];
        self.pickViewCountry.alpha = 0;
        self.pickViewCountry.delegate = self;
        self.pickViewCountry.showsSelectionIndicator = YES;
        self.pickViewCountry.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_pickViewCountry];
        
        self.pickViewCountry.frame = CGRectMake(10, gap - 10 - _pickViewCountry.frame.size.height, 300, _pickViewCountry.frame.size.height);
        self.pickViewCountry.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
    }
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.titlePhoneCheck.frame = CGRectMake(0, 20 - gap, 320, 30);
        self.textPhoneCheck.frame = CGRectMake(0, 50 - gap, 320, 30);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.wrapperFieldCountryCode.frame = CGRectMake(10, 100 - gap, 300, 45);
    } completion:^(BOOL finished) {
        
    }];
    
    self.backButton.hidden = NO;
    
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.wrapperPhoneNumber.frame = CGRectMake(10, 100 + 45 + 15 - gap, 300, 45);
        self.nextButton.alpha = 0;
        self.backButton.alpha = 1;
    } completion:^(BOOL finished) {
        [self.nextButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.pickViewCountry.alpha = 1;
            self.pickViewCountry.transform = CGAffineTransformMakeScale(1, 1);
            self.nextButton.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

-(void)shakeCodePhone{
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.05];
    [shake setRepeatCount:5];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(_wrapperCodePhone.center.x - 5,_wrapperCodePhone.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(_wrapperCodePhone.center.x + 5, _wrapperCodePhone.center.y)]];
    [_wrapperCodePhone.layer addAnimation:shake forKey:@"position"];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSUInteger numRows = [self.mcc.countryName_CallingCode_Array count];
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [self.mcc.countryName_CallingCode_Array objectAtIndex:row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    CGFloat heiht = 40;
    
    return heiht;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length > 4) {
        return NO;
    }
    
    if ([self isNumeric:string] || ([string length] == 0 && range.length > 0)) {
        
        self.code1.text = @"";
        self.code1.alpha = 0;
        
        self.code2.text = @"";
        self.code2.alpha = 0;
        
        self.code3.text = @"";
        self.code3.alpha = 0;
        
        self.code4.text = @"";
        self.code4.alpha = 0;
        
        self.nextButton.buttonStatus = UICanuButtonStatusDisable;
        
        for (int i=0; i < [newString length]; i++) {
            
            NSString *ichar  = [NSString stringWithFormat:@"%c", [newString characterAtIndex:i]];
            
            if (i == 0) {
                self.code1.text = ichar;
                self.code1.alpha = 1;
            } else if (i == 1) {
                self.code2.text = ichar;
                self.code2.alpha = 1;
            } else if (i == 2) {
                self.code3.text = ichar;
                self.code3.alpha = 1;
            } else if (i == 3) {
                self.code4.text = ichar;
                self.code4.alpha = 1;
                self.nextButton.buttonStatus = UICanuButtonStatusNormal;
            }
        }
        
        return YES;
    } else {
        return NO;
    }
    
    
    
}

@end
