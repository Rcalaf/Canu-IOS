//
//  MessageGhostUser.m
//  CANU
//
//  Created by Vivien Cormier on 21/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "MessageGhostUser.h"
#import "UICanuButtonSignBottomBar.h"
#import "Contact.h"
#import "User.h"
#import "Activity.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

#include <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(NSInteger, CANUG5type) {
    CANUG5 = 0,
    CANUG5Fail = 1,
    CANUG5Failb = 2
};

@interface MessageGhostUser () <MFMessageComposeViewControllerDelegate>

// All
@property (nonatomic) CANUG5type canuG5type;
@property (strong, nonatomic) NSMutableArray *arrayUserSelected;
@property (strong, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) Activity *activity;

// G5
@property (strong, nonatomic) UILabel *textG5;
@property (strong, nonatomic) UIImageView *arrow;
@property (strong, nonatomic) UICanuButtonSignBottomBar *buttonOK;

// G5 Fail

@property (strong, nonatomic) UILabel *textG5Fail;
@property (strong, nonatomic) UIImageView *arrowG5Fail;
@property (strong, nonatomic) UICanuButtonSignBottomBar *yesG5Fail;
@property (strong, nonatomic) UICanuButtonSignBottomBar *noG5Fail;

// G5 Failb

@property (strong, nonatomic) UILabel *textG5Failb;
@property (strong, nonatomic) UIImageView *arrowG5Failb;
@property (strong, nonatomic) UICanuButtonSignBottomBar *yesG5Failb;
@property (strong, nonatomic) UICanuButtonSignBottomBar *noG5Failb;

@end

@implementation MessageGhostUser

- (id)initWithFrame:(CGRect)frame andArray:(NSMutableArray *)usersSelected andParentViewcontroller:(UIViewController *)viewController withActivity:(Activity *)activity{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.activity = activity;
        
        self.canuG5type = CANUG5;
        
        self.parentViewController = viewController;
        
        self.arrayUserSelected = usersSelected;
        
        self.backgroundColor = backgroundColorView;
        
        self.arrow = [[UIImageView alloc]initWithFrame:CGRectMake(46, (self.frame.size.height - 480)/2 + 90, 228, 33)];
        self.arrow.image = [UIImage imageNamed:@"G5_arrow_"];
        [self addSubview:_arrow];
        
        self.textG5 = [[UILabel alloc]initWithFrame:CGRectMake(30, (self.frame.size.height - 480)/2 + 200, 260, 120)];
        self.textG5.textColor = UIColorFromRGB(0x2b4a57);
        self.textG5.numberOfLines = 5;
        self.textG5.textAlignment = NSTextAlignmentCenter;
        self.textG5.backgroundColor = [UIColor clearColor];
        self.textG5.text = NSLocalizedString(@"Those who are not yet on CANU will receive a text message with a link to your activity.", nil);
        self.textG5.font = [UIFont fontWithName:@"Lato-Bold" size:20];
        [self addSubview:_textG5];
        
        self.buttonOK = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(40, (self.frame.size.height - 480)/2 + 400, 240, 37.0) andBlue:YES];
        [self.buttonOK setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        [self.buttonOK addTarget:self action:@selector(openMessage) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_buttonOK];
        
    }
    return self;
}

#pragma mark - Private

- (void)openMessage{
    
    [self.buttonOK removeFromSuperview];
    [self.noG5Fail removeFromSuperview];
    [self.noG5Failb removeFromSuperview];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        
        NSMutableArray *phoneNumber = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [self.arrayUserSelected count]; i++) {
            
            if ([[self.arrayUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
                Contact *contactData = [self.arrayUserSelected objectAtIndex:i];
                [phoneNumber addObject:contactData.convertNumber];
            }
            
        }
        
        NSDateFormatter *formatterMonth = [[NSDateFormatter alloc] init];
        [formatterMonth setDateFormat:@"MMMM"];
        NSString *stringFromMonth = [formatterMonth stringFromDate:_activity.start];
        
        //NSString *string = [NSString stringWithFormat:@"%icanuGettogether%i",_activity.activityId,_activity.user.userId];
        
        //NSString *token = [self sha1:string];
        
        //controller.body = [NSString stringWithFormat:@"%@? ( %@, %i | %i.%i | %@, %@ ) canu.se/i/%i?key=%@",_activity.title,stringFromMonth,[_activity.start mk_day],[_activity.start mk_hour],[_activity.start mk_minutes],_activity.street,_activity.city,_activity.activityId,token];
        controller.body = [NSString stringWithFormat:@"%@? ( %@, %i | %i.%i | %@, %@ ) canu.se/i/%@",_activity.title,stringFromMonth,[_activity.start mk_day],[_activity.start mk_hour],[_activity.start mk_minutes],_activity.street,_activity.city,_activity.invitationToken];
        controller.recipients = phoneNumber;
        controller.messageComposeDelegate = self;
        [self.parentViewController presentViewController:controller animated:YES completion:nil];
        
    }
    
}

- (void)close{
    
    BOOL ifUser = NO;
    
    for (int i = 0; i < [self.arrayUserSelected count]; i++) {
        
        if (i < 3) {
            if ([[self.arrayUserSelected objectAtIndex:i] isKindOfClass:[User class]]) {
                ifUser = YES;
            }
        }
        
    }
    
    if (ifUser) {
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification" action:@"G5 S/F" label:@"Fail" value:nil] build]];
        
        [self.delegate  messageGhostUserWillDisappear];
    } else {
        [self disappearG5Fail];
        [self appearG5failb];
    }
    
}

- (void)closeAndDelete{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification" action:@"G5 S/F" label:@"Fail" value:nil] build]];
    
    [self.delegate messageGhostUserWillDisappearForDeleteActivity];
    
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

#pragma mark -- G5

- (void)disappearG5{
    
    [self.arrow removeFromSuperview];
    [self.textG5 removeFromSuperview];
    [self.buttonOK removeFromSuperview];
    
}

#pragma mark -- G5 fail

- (void)appearG5Fail{
    
    self.canuG5type = CANUG5Fail;
    
    NSString *namePeople = @"";
    
    int othersPeople = 0;
    
    for (int i = 0; i < [self.arrayUserSelected count]; i++) {
        
        if (i < 3) {
            if ([[self.arrayUserSelected objectAtIndex:i] isKindOfClass:[Contact class]]) {
                Contact *contactData = [self.arrayUserSelected objectAtIndex:i];
                namePeople = [NSString stringWithFormat:@"%@ %@,",namePeople,contactData.fullName];
            }
        } else {
            othersPeople++;
        }
        
    }
    
    self.arrowG5Fail = [[UIImageView alloc]initWithFrame:CGRectMake(46, (self.frame.size.height - 480)/2 + 90, 223, 72)];
    self.arrowG5Fail.image = [UIImage imageNamed:@"G5_Fail_arrow_broke"];
    [self addSubview:_arrowG5Fail];
    
    self.textG5Fail = [[UILabel alloc]initWithFrame:CGRectMake(30, (self.frame.size.height - 480)/2 + 200, 260, 145)];
    self.textG5Fail.textColor = UIColorFromRGB(0x2b4a57);
    self.textG5Fail.numberOfLines = 7;
    self.textG5Fail.textAlignment = NSTextAlignmentCenter;
    self.textG5Fail.backgroundColor = [UIColor clearColor];
    if (othersPeople == 0) {
        self.textG5Fail.text = [NSString stringWithFormat:@"%@ %@",namePeople,NSLocalizedString(@"will not be invited if you cancel. \n\nAre you sure?", nil)];
    } else if (othersPeople == 1) {
        self.textG5Fail.text = [NSString stringWithFormat:@"%@ %@ %i %@",namePeople,NSLocalizedString(@"and", nil),othersPeople,NSLocalizedString(@"other will not be invited if you cancel. \n\nAre you sure?", nil)];
    } else {
        self.textG5Fail.text = [NSString stringWithFormat:@"%@ %@ %i %@",namePeople,NSLocalizedString(@"and", nil),othersPeople,NSLocalizedString(@"others will not be invited if you cancel. \n\nAre you sure?", nil)];
    }
    
    self.textG5Fail.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    [self addSubview:_textG5Fail];
    
    self.yesG5Fail = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(40, (self.frame.size.height - 480)/2 + 400, 115, 37.0) andBlue:NO];
    [self.yesG5Fail setTitle:NSLocalizedString(@"YES", nil) forState:UIControlStateNormal];
    [self.yesG5Fail addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_yesG5Fail];
    
    self.noG5Fail = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(165, (self.frame.size.height - 480)/2 + 400, 115, 37.0) andBlue:YES];
    [self.noG5Fail setTitle:NSLocalizedString(@"NO", nil) forState:UIControlStateNormal];
    [self.noG5Fail addTarget:self action:@selector(openMessage) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_noG5Fail];
    
}

- (void)disappearG5Fail{
    
    [self.arrowG5Fail removeFromSuperview];
    [self.textG5Fail removeFromSuperview];
    [self.yesG5Fail removeFromSuperview];
    [self.noG5Fail removeFromSuperview];
    
}

#pragma mark - G5 failb

- (void)appearG5failb{
    
    self.canuG5type = CANUG5Failb;
    
    self.arrowG5Failb = [[UIImageView alloc]initWithFrame:CGRectMake(46, (self.frame.size.height - 480)/2 + 90, 223, 72)];
    self.arrowG5Failb.image = [UIImage imageNamed:@"G5_Fail_arrow_broke"];
    [self addSubview:_arrowG5Failb];
    
    self.textG5Failb = [[UILabel alloc]initWithFrame:CGRectMake(30, (self.frame.size.height - 480)/2 + 200, 260, 120)];
    self.textG5Failb.textColor = UIColorFromRGB(0x2b4a57);
    self.textG5Failb.numberOfLines = 6;
    self.textG5Failb.textAlignment = NSTextAlignmentCenter;
    self.textG5Failb.backgroundColor = [UIColor clearColor];
    self.textG5Failb.text = NSLocalizedString(@"None of whom you've selected is on CANU - yet. \n\nAre you sure you want to delete this activity?", nil);
    self.textG5Failb.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    [self addSubview:_textG5Failb];
    
    self.yesG5Failb = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(40, (self.frame.size.height - 480)/2 + 400, 115, 37.0) andBlue:NO];
    [self.yesG5Failb setTitle:NSLocalizedString(@"DELETE", nil) forState:UIControlStateNormal];
    [self.yesG5Failb addTarget:self action:@selector(closeAndDelete) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_yesG5Failb];
    
    self.noG5Failb = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(165, (self.frame.size.height - 480)/2 + 400, 115, 37.0) andBlue:YES];
    [self.noG5Failb setTitle:NSLocalizedString(@"NO", nil) forState:UIControlStateNormal];
    [self.noG5Failb addTarget:self action:@selector(openMessage) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_noG5Failb];
    
}

- (void)disappearG5Failb{
    
    [self.arrowG5Failb removeFromSuperview];
    [self.textG5Failb removeFromSuperview];
    [self.yesG5Failb removeFromSuperview];
    [self.noG5Failb removeFromSuperview];
    
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    BOOL messageIsSend = NO;
    
	switch (result) {
		case MessageComposeResultCancelled:
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
    
    [self disappearG5];
    [self disappearG5Fail];
    [self disappearG5Failb];
    
    if (!messageIsSend) {
        [self appearG5Fail];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification" action:@"G5 S/F" label:@"Succes" value:nil] build]];
        
        if (self.canuG5type == CANUG5) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification" action:@"G5 Succes" label:@"G5" value:nil] build]];
        } else if (self.canuG5type == CANUG5Fail) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification" action:@"G5 Succes" label:@"G5 Fail" value:nil] build]];
        } else if (self.canuG5type == CANUG5Failb) {
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Notification" action:@"G5 Succes" label:@"G5 Failb" value:nil] build]];
        }
        
    }
    
	[self.parentViewController dismissViewControllerAnimated:YES completion:^{
        
        if (messageIsSend) {
            
            [self.delegate  messageGhostUserWillDisappear];
            
        }
        
    }];
    
}

@end
