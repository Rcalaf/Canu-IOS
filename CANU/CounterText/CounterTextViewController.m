//
//  CounterTextViewController.m
//  CANU
//
//  Created by Vivien Cormier on 03/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "CounterTextViewController.h"
#import "UICanuButtonSignBottomBar.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@interface CounterTextViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation CounterTextViewController

- (id)initForEarlyBird:(BOOL)isEarlyBird
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = backgroundColorView;
        
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 57)];
        webView.scalesPageToFit = YES;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.canu.se/lockdown"]]];
        [self.view addSubview:webView];
        
        UIView *bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 57, self.view.frame.size.width, 57)];
        bottomBar.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [self.view addSubview:bottomBar];
        
        UIView *lineBottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, -1, 320, 1)];
        lineBottomBar.backgroundColor = UIColorFromRGB(0xd4e0e0);
        [bottomBar addSubview:lineBottomBar];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
        [backButton setImage:[UIImage imageNamed:@"back_cross"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backToFeed) forControlEvents:UIControlEventTouchDown];
        [bottomBar addSubview:backButton];
        
        if (isEarlyBird) {
            UICanuButtonSignBottomBar *buttonAction = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(57 + 10, 10.0, self.view.frame.size.width - 57 - 20, 37.0) andBlue:YES];
            [buttonAction setTitle:NSLocalizedString(@"BECOME AN EARLY BIRD", nil) forState:UIControlStateNormal];
            [buttonAction addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchDown];
            [bottomBar addSubview:buttonAction];
        }
        
    }
    return self;
}

- (void)backToFeed{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)sendMail{
    
    if ([MFMailComposeViewController canSendMail]){
        
        AppDelegate *appDeleate = [[UIApplication sharedApplication] delegate];
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        [[mailer navigationBar] setTintColor:[UIColor blackColor]];
        [[mailer navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], UITextAttributeTextShadowColor,
                                                        [UIColor blackColor], UITextAttributeTextColor,
                                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                        [UIFont fontWithName:@"HelveticaNeue" size:18.0], UITextAttributeFont,
                                                        nil]];
        
        mailer.mailComposeDelegate = self;
        [mailer setToRecipients:[NSArray arrayWithObjects:@"gettogether@canu.se", nil]];
        [mailer setSubject:[NSString stringWithFormat:@"Early Bird %@",appDeleate.user.userName]];
        [mailer setMessageBody:@"I'll be a kick-ass early bird because ..." isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Email us at gettogether@canu.se"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
