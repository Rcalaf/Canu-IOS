//
//  CheckPhoneNumber.m
//  CANU
//
//  Created by Vivien Cormier on 14/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "CheckPhoneNumber.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "SignUpViewController.h"
#include <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "User.h"

@interface CheckPhoneNumber () <MFMessageComposeViewControllerDelegate>

@property (nonatomic) SignUpViewController* parentViewController;

@end

@implementation CheckPhoneNumber

- (id)initWithFrame:(CGRect)frame AndParentViewController:(SignUpViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.parentViewController = parentViewController;
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 480, self.frame.size.width, 480)];
        background.image = [UIImage imageNamed:@"SignUp_phoneNumber_background"];
        [self addSubview:background];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        title.text = NSLocalizedString(@"Phone Check", nil);
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont fontWithName:@"Lato-Bold" size:24];
        [self addSubview:title];
        
        UIButton *check = [[UIButton alloc]initWithFrame:CGRectMake(10, self.frame.size.height - 57 - 10 -57, 300, 57)];
        check.backgroundColor = [UIColor whiteColor];
        [check setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [check setTitle:@"Verify by sms" forState:UIControlStateNormal];
        [check addTarget:self action:@selector(sendSms) forControlEvents:UIControlEventTouchDown];
        [self addSubview:check];
        
    }
    return self;
}

- (void)sendSms{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        User *user = appDelegate.user;
        
        NSString *string = [NSString stringWithFormat:@"%icanuGettogether%@",user.userId,user.email];
        
        NSString *token = [self sha1:string];
        
        NSString *text = [NSString stringWithFormat:@"%@#%i",token,user.userId];
        NSLog(@"%@",text);
		controller.body = text;
		controller.recipients = [NSArray arrayWithObjects:@"+46769438333", nil];
		controller.messageComposeDelegate = self;
        [self.parentViewController presentViewController:controller animated:YES completion:^{
            NSLog(@"Done");
        }];
	}
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:@"Error" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self.parentViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(NSString*) sha1:(NSString*)input
{
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
