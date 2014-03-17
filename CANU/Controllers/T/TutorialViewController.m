//
//  TutorialViewController.m
//  CANU
//
//  Created by Vivien Cormier on 20/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

typedef enum {
    NavBoxLocal = 2,
    NavBoxTribes = 129,
    NavBoxProfil = 255,
} NavBoxPosition;

#import "TutorialViewController.h"

#import "TutorialStepStart.h"
#import "TutorialStepLocal.h"
#import "TutorialStepTribes.h"
#import "TutorialStepProfile.h"
#import "TutorialStepFinal.h"
#import "AppDelegate.h"
#import "AlertViewController.h"

@interface TutorialViewController () <TutorialStepStartDelegate,TutorialStepFinalDelegate>

@property (strong, nonatomic) UIView *wrapperStep;
@property (strong, nonatomic) UIImageView *line;
@property (strong, nonatomic) UIImageView *navBox;
@property (strong, nonatomic) TutorialStepStart *tutorialStepStart;
@property (strong, nonatomic) TutorialStepLocal *tutorialStepLocal;
@property (strong, nonatomic) TutorialStepTribes *tutorialStepTribes;
@property (strong, nonatomic) TutorialStepProfile *tutorialStepProfile;
@property (strong, nonatomic) TutorialStepFinal *tutorialStepFinal;

@end

@implementation TutorialViewController

#pragma mark - Lifecycle

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = backgroundColorView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.wrapperStep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:_wrapperStep];
    
    self.line = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 480, 320, 480)];
    self.line.alpha = 0;
    [self.view addSubview:_line];
    
    UISwipeGestureRecognizer *swipeTribes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(stepTribes:)];
    swipeTribes.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.navBox = [[UIImageView alloc]initWithFrame:CGRectMake(2.0, 415.0 + KIphone5Margin, 63.0, 63.0)];
    self.navBox.image = [UIImage imageNamed:@"navmenu_local.png"];
    self.navBox.alpha = 0;
    self.navBox.userInteractionEnabled = YES;
    [self.navBox addGestureRecognizer:swipeTribes];
    [self.view addSubview:_navBox];
    
    [NSThread detachNewThreadSelector:@selector(stepStart) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)stepStart{
    self.tutorialStepStart = [[TutorialStepStart alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.tutorialStepStart.delegate = self;
    self.tutorialStepStart.alpha = 0;
    [self.wrapperStep addSubview:_tutorialStepStart];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.tutorialStepStart.alpha = 1;
    } completion:nil];
    
}

- (void)stepLocal{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.backgroundColor = UIColorFromRGB(0x84d0d4);
    } completion:^(BOOL finished) {
        [self.tutorialStepStart removeFromSuperview];
        self.tutorialStepStart = nil;
        
        self.tutorialStepLocal = [[TutorialStepLocal alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        [self.wrapperStep addSubview:_tutorialStepLocal];
        
        self.line.image = [UIImage imageNamed:@"Tutorial_Step1_line"];
        
        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.line.alpha = 1;
            self.navBox.alpha = 1;
        } completion:nil];
    }];
    
}

- (void)stepTribes:(UIGestureRecognizer *)sender{
    
    [self.tutorialStepLocal animationEnd];
    
    self.tutorialStepTribes = [[TutorialStepTribes alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.wrapperStep addSubview:_tutorialStepTribes];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.navBox.frame = CGRectMake(NavBoxTribes, 415.0 + KIphone5Margin, 63.0, 63.0);
        self.line.alpha = 0;
    } completion:^(BOOL finished) {
        self.navBox.image = [UIImage imageNamed:@"NavBox_Tribes"];
        
        [self.tutorialStepLocal removeFromSuperview];
        self.tutorialStepLocal = nil;
        
        self.line.image = [UIImage imageNamed:@"Tutorial_Step2_line"];
        
        [self.navBox removeGestureRecognizer:sender];
        
        UISwipeGestureRecognizer *swipeProfile = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeProfile:)];
        swipeProfile.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self.navBox addGestureRecognizer:swipeProfile];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.line.alpha = 1;
        } completion:nil];
        
    }];
}

- (void)swipeProfile:(UIGestureRecognizer *)sender{
    
    [self.tutorialStepTribes animationEnd];
    
    self.tutorialStepProfile = [[TutorialStepProfile alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.wrapperStep addSubview:_tutorialStepProfile];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.navBox.frame = CGRectMake(NavBoxProfil, 415.0 + KIphone5Margin, 63.0, 63.0);
        self.line.alpha = 0;
    } completion:^(BOOL finished) {
        self.navBox.image = [UIImage imageNamed:@"navmenu_me"];
        
        self.line.image = [UIImage imageNamed:@"Tutorial_Step5_line"];
        
        [self.tutorialStepLocal removeFromSuperview];
        self.tutorialStepLocal = nil;
        
        [self.navBox removeGestureRecognizer:sender];
        
        UISwipeGestureRecognizer *goCreate = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCreate:)];
        goCreate.direction = UISwipeGestureRecognizerDirectionUp;
        
        [self.navBox addGestureRecognizer:goCreate];
        
        [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.line.alpha = 1;
        } completion:nil];
        
    }];
    
}

- (void)swipeCreate:(UIGestureRecognizer *)sender{
    
    [self.navBox removeGestureRecognizer:sender];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.navBox.frame = CGRectMake(NavBoxProfil, 215.0 + KIphone5Margin, 63.0, 63.0);
        self.line.alpha = 0;
        self.tutorialStepProfile.alpha = 0;
        self.navBox.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.tutorialStepProfile removeFromSuperview];
        self.tutorialStepProfile = nil;
        
        self.tutorialStepFinal = [[TutorialStepFinal alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        self.tutorialStepFinal.alpha = 0;
        self.tutorialStepFinal.delegate = self;
        [self.wrapperStep addSubview:_tutorialStepFinal];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.view.backgroundColor = backgroundColorView;
            self.tutorialStepFinal.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

#pragma mark - TutorialStepStartDelegate

- (void)tutorialStepStartNext{
    
    [self.tutorialStepStart removeFromSuperview];
    self.tutorialStepStart = nil;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.view.backgroundColor = UIColorFromRGB(0x84d0d4);
    } completion:^(BOOL finished) {
        [self stepLocal];
    }];
}

#pragma mark - TutorialStepFinalDelegate

- (void)tutorialStepFinalEnd{
    
    [self dismissViewControllerAnimated:NO completion:^{
        // Add notification for the push
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
    }];
    
}

@end
