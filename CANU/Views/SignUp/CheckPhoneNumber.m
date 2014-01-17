//
//  CheckPhoneNumber.m
//  CANU
//
//  Created by Vivien Cormier on 14/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>

#import "CheckPhoneNumber.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "AFCanuAPIClient.h"
#import "UICanuNavigationController.h"
#import "TutorialViewController.h"
#import "ActivitiesFeedViewController.h"
#import "SignInViewController.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface CheckPhoneNumber () <MFMessageComposeViewControllerDelegate>

@property (nonatomic) int countRequest;
@property (nonatomic) UILabel *textButton;
@property (nonatomic) UIButton *check;
@property (nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) SignUpViewController* parentViewController;

@end

@implementation CheckPhoneNumber

- (id)initWithFrame:(CGRect)frame AndParentViewController:(SignUpViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.countRequest = 0;
        
        self.parentViewController = parentViewController;
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 480, self.frame.size.width, 480)];
        background.image = [UIImage imageNamed:@"SignUp_phoneNumber_background"];
        [self addSubview:background];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 40)];
        title.text = NSLocalizedString(@"Phone Check", nil);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont fontWithName:@"Lato-Bold" size:24];
        [self addSubview:title];
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingIndicator.frame = CGRectMake(10, self.frame.size.height - 57 - 10, 300, 57);
        [self  addSubview:_loadingIndicator];
        
        self.check = [[UIButton alloc]initWithFrame:CGRectMake(10, self.frame.size.height - 57 - 10, 300, 57)];
        self.check.backgroundColor = [UIColor whiteColor];
        [self.check addTarget:self action:@selector(sendSms) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.check];
        
        self.textButton = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 57)];
        self.textButton.backgroundColor = [UIColor whiteColor];
        self.textButton.textColor = UIColorFromRGB(0x6d6e7a);
        self.textButton.text = NSLocalizedString(@"Verify my number", nil);
        self.textButton.font = [UIFont fontWithName:@"Lato-Regular" size:13];
        [self.check addSubview:self.textButton];
        
    }
    return self;
}

- (void)sendSms{
    
    if ([AFCanuAPIClient sharedClient].distributionMode) {
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            User *user = appDelegate.user;
            
            NSString *string = [NSString stringWithFormat:@"%icanuGettogether%@",user.userId,user.email];
            
            NSString *token = [self sha1:string];
            
            NSString *text = [NSString stringWithFormat:@"%@ %@#%i",NSLocalizedString(@"I promise that this is my number.", nil),token,user.userId];
            
            controller.body = text;
            controller.recipients = [NSArray arrayWithObjects:@"+46769438333", nil];
            controller.messageComposeDelegate = self;
            [self.parentViewController presentViewController:controller animated:YES completion:nil];
        }
        
    }else{
        
        [self.loadingIndicator startAnimating];
        self.check.hidden = YES;
        [self performSelector:@selector(fakeCheckPhoneValidation) withObject:nil afterDelay:2];
        
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    BOOL messageIsSend = NO;
    
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:@"Error" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
			break;
		case MessageComposeResultSent:
            messageIsSend = YES;
			break;
		default:
			break;
	}
    
	[self.parentViewController dismissViewControllerAnimated:YES completion:^{
        
        if (messageIsSend) {
            
            [self.loadingIndicator startAnimating];
            self.check.hidden = YES;
            [self performSelector:@selector(checkPhoneValidation) withObject:nil afterDelay:1];
            
        }
        
    }];
}

- (void)checkPhoneValidation{
    
    self.countRequest += 1;
    
    if (_countRequest <= 20) {
     
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        User *currentUser = appDelegate.user;
        
        [User userWithToken:currentUser.token andBlock:^(User *user, NSError *error) {
            
            if (error) {
                NSLog(@"Error");
            }else{
                if (user.phoneIsVerified) {
                    NSLog(@"Save New User");
                    [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
                    [self goToFeedViewController];
                }else{
                    NSLog(@"Not Valide");
                    [self performSelector:@selector(checkPhoneValidation) withObject:nil afterDelay:1];
                }
            }
            
        }];
        
    }else{
        
        [self.loadingIndicator stopAnimating];
        self.check.hidden = NO;
        self.countRequest = 0;
        self.textButton.text = NSLocalizedString(@"Reverify my number", nil);
        
    }
    
}

- (void)fakeCheckPhoneValidation{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    User *currentUser = appDelegate.user;
    [[NSUserDefaults standardUserDefaults] setObject:[currentUser serialize] forKey:@"user"];
    
    [self goToFeedViewController];
    
}

- (void)goToFeedViewController{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    appDelegate.canuViewController = [[UICanuNavigationController alloc] initWithActivityFeed:appDelegate.feedViewController];
    [appDelegate.canuViewController pushViewController:appDelegate.feedViewController animated:NO];
    appDelegate.window.rootViewController = appDelegate.canuViewController;
    
    if (!self.parentViewController.isForCheckPhoneNumber) {
        TutorialViewController *tutorial = [[TutorialViewController alloc] init];
        [appDelegate.canuViewController presentViewController:tutorial animated:YES completion:nil];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"User" action:@"SignUp" label:@"Save" value:nil] build]];
        
    }
    
}

-(NSString*) sha1:(NSString*)input{
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

@end