//
//  AlertViewController.m
//  CANU
//
//  Created by Vivien Cormier on 24/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "AlertViewController.h"
#import "UICanuButtonSignBottomBar.h"
#import "ErrorManager.h"

@interface AlertViewController ()

@property (strong, nonatomic) UIView *wrapperBlack;
@property (strong, nonatomic) UIView *wrapperAlert;
@property (strong, nonatomic) UIImageView *illustration;
@property (strong, nonatomic) UILabel *descriptionError;
@property (strong, nonatomic) UICanuButtonSignBottomBar *buttonAction;

@end

@implementation AlertViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.wrapperBlack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.wrapperBlack.backgroundColor = [UIColor blackColor];
    self.wrapperBlack.alpha = 0;
    [self.view addSubview:_wrapperBlack];
    
    self.wrapperAlert = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.wrapperAlert.backgroundColor = backgroundColorView;
    self.wrapperAlert.alpha = 0;
    [self.view addSubview:_wrapperAlert];
    
    self.illustration = [[UIImageView alloc]initWithFrame:CGRectMake((320 - 209)/2, (self.view.frame.size.height - 480)/3 + 40, 209, 142)];
    self.illustration.backgroundColor = [UIColor clearColor];
    [self.wrapperAlert addSubview:_illustration];
    
    self.descriptionError = [[UILabel alloc]initWithFrame:CGRectMake(30, (self.view.frame.size.height - 480)/2 + 190, 260, 210)];
    self.descriptionError.backgroundColor = [UIColor clearColor];
    self.descriptionError.textColor = UIColorFromRGB(0x2b4a57);
    self.descriptionError.textAlignment = NSTextAlignmentCenter;
    self.descriptionError.font = [UIFont fontWithName:@"Lato-Bold" size:19];
    self.descriptionError.text = @"Error";
    self.descriptionError.numberOfLines = 5;
    [self.wrapperAlert addSubview:_descriptionError];
    
    if (_canuError == CANUErrorNoInternetConnection) {
        self.descriptionError.text = NSLocalizedString(@"No Internet Connection", nil);
        self.illustration.image = [UIImage imageNamed:@"G1_pipe"];
    } else if (_canuError == CANUErrorServerDown) {
        self.descriptionError.text = NSLocalizedString(@"Internal Error", nil);
        self.illustration.image = [UIImage imageNamed:@"G1_pipe"];
    } else if (_canuError == CANUErrorUnknown) {
        self.descriptionError.text = NSLocalizedString(@"Internal Error", nil);
        self.illustration.image = [UIImage imageNamed:@"G1_pipe"];
    } else if (_canuError == CANUErrorPhoneBookRestricted) {
        self.illustration.frame = CGRectMake(0, (self.view.frame.size.height - 480)/3 + 40, 271, 226);
        self.illustration.image = [UIImage imageNamed:@"G2_fail_hand"];
        self.descriptionError.frame = CGRectMake((320 - 315)/2, (self.view.frame.size.height - 480)/2 + 230, 315, 170);
        self.descriptionError.text = NSLocalizedString(@"Settings > Privacy > Contacts", nil);
    } else if (_canuError == CANUErrorLocationRestricted) {
        self.illustration.frame = CGRectMake((320 - 85)/2, (self.view.frame.size.height - 480)/3 + 30, 85, 221);
        self.illustration.image = [UIImage imageNamed:@"G4Fail_eagle"];
        self.descriptionError.frame = CGRectMake((320 - 315)/2, (self.view.frame.size.height - 480)/2 + 230, 315, 170);
        self.descriptionError.text = NSLocalizedString(@"Settings > Privacy > Location", nil);
    }
    
    self.buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height - 77, 240, 37.0) andBlue:YES];
    [self.buttonAction setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [self.buttonAction addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.wrapperAlert  addSubview:_buttonAction];
    
    self.wrapperAlert.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapperBlack.alpha = 0.5;
        self.wrapperAlert.alpha = 1;
        self.wrapperAlert.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)back{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapperBlack.alpha = 0;
        self.wrapperAlert.alpha = 0;
        self.wrapperAlert.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [[ErrorManager sharedErrorManager] deleteError:_canuError];
        [self.view removeFromSuperview];
        [self willMoveToParentViewController:nil];
        if (self.parentViewController) {
            [self removeFromParentViewController];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
