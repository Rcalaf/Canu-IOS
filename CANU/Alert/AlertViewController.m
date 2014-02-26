//
//  AlertViewController.m
//  CANU
//
//  Created by Vivien Cormier on 24/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "AlertViewController.h"
#import "UICanuButtonSignBottomBar.h"

@interface AlertViewController ()

@property (strong, nonatomic) UIView *wrapperBlack;
@property (strong, nonatomic) UIView *wrapperAlert;
@property (strong, nonatomic) UILabel *titleError;
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
    [self.view addSubview:_wrapperAlert];
    
    self.wrapperAlert = [[UIView alloc]initWithFrame:CGRectMake((320 - 250)/2, (self.view.frame.size.height - 300)/2, 250, 300)];
    self.wrapperAlert.backgroundColor = [UIColor whiteColor];
    self.wrapperAlert.alpha = 0;
    [self.view addSubview:_wrapperAlert];
    
    self.titleError = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 230, 20)];
    self.titleError.backgroundColor = [UIColor clearColor];
    self.titleError.textColor = UIColorFromRGB(0x16a1bf);
    self.titleError.textAlignment = NSTextAlignmentCenter;
    self.titleError.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    self.titleError.text = @"Server down";
    [self.wrapperAlert addSubview:_titleError];
    
    self.descriptionError = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 230, 270)];
    self.descriptionError.backgroundColor = [UIColor clearColor];
    self.descriptionError.textColor = UIColorFromRGB(0x16a1bf);
    self.descriptionError.textAlignment = NSTextAlignmentCenter;
    self.descriptionError.font = [UIFont fontWithName:@"Lato-Light" size:15];
    self.descriptionError.text = @"Server down";
    self.descriptionError.numberOfLines = 5;
    [self.wrapperAlert addSubview:_descriptionError];
    
    if (_canuError == CANUErrorNoInternetConnection) {
        self.titleError.text = @"No internet";
        self.descriptionError.text = @"Please turn on your wifi";
    } else if (_canuError == CANUErrorServerDown) {
        self.titleError.text = @"Server down";
        self.descriptionError.text = @"Our best chimpanzee Didirk works on this trouble";
    } else if (_canuError == CANUErrorUnknown) {
        self.titleError.text = @"Server broken";
        self.descriptionError.text = @"Our best chimpanzee Didirk works on this trouble";
    }
    
    self.buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(10, 250 - 37 - 10, self.wrapperAlert.frame.size.width - 20, 37.0) andBlue:YES];
    [self.buttonAction setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [self.buttonAction addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.wrapperAlert  addSubview:_buttonAction];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.wrapperBlack.alpha = 0.5;
        self.wrapperAlert.alpha = 1;
    }];
    
}

- (void)back{
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
