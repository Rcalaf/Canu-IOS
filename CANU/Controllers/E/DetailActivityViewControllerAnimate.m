//
//  DetailActivityViewControllerAnimate.m
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "DetailActivityViewControllerAnimate.h"
#import "AppDelegate.h"
#import "Activity.h"
#import "UICanuNavigationController.h"
#import "UICanuLabelUserName.h"
#import "UICanuLabelDate.h"
#import "UICanuLabelTimeStart.h"
#import "UICanuLabelTimeEnd.h"
#import "UICanuLabelActivityName.h"
#import "UICanuLabelLocation.h"
#import "UICanuLabelDescription.h"
#import "UIImageView+AFNetworking.h"
#import "CreateEditActivityViewController.h"
#import "ChatScrollView.h"
#import "AFCanuAPIClient.h"
#import "AttendeesScrollViewController.h"
#import "LoaderAnimation.h"
#import "UICanuBottomBar.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "UserManager.h"
#import "ProfilePicture.h"
#import "UICanuButton.h"
#import "InvitOthersViewController.h"
#import "ActivitiesFeedViewController.h"
#import "UIActivityViewControllerCustom.h"
#import "Notification.h"
#import "InvitShow.h"

@interface DetailActivityViewControllerAnimate ()<MKMapViewDelegate,UITextViewDelegate,UIScrollViewDelegate,CreateEditActivityViewControllerDelegate,ChatScrollViewDelegate,InvitOthersViewControllerDelegate,UIActivityViewControllerCustomDelegate>

@property (nonatomic) BOOL descriptionIsOpen;
@property (nonatomic) BOOL keyboardIsOpen;
@property (nonatomic) int positionY;
@property (nonatomic) CANUOpenDetailsActivityAfter canuOpenDetailsActivityAfter;
@property (nonatomic) CGRect frame;
@property (nonatomic, strong) UIView *wrapper;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *touchQuitKeyboard;
@property (nonatomic, strong) UIView *wrapperActivity;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) InvitShow *wrapperInvitList;
@property (nonatomic, strong) UIImageView *wrapperActivityDescription;
@property (nonatomic, strong) UIView *wrapperActivityBottom;
@property (nonatomic, strong) UITextView *input;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *counterInvit;
@property (nonatomic, strong) UICanuButton *sendButton;
@property (nonatomic, strong) UICanuButton *bottomButton;
@property (nonatomic, strong) ChatScrollView *chatView;
@property (nonatomic, strong) UICanuBottomBar *bottomBar;
@property (nonatomic, strong) AttendeesScrollViewController *attendeesList;
@property (nonatomic, strong) InvitOthersViewController *addInvit;
@property (nonatomic, strong) UICanuLabelUserName *userName;
@property (nonatomic, strong) UICanuLabelActivityName *nameActivity;
@property (nonatomic, strong) UICanuLabelDate *date;
@property (nonatomic, strong) UICanuLabelLocation *location;

@end

@implementation DetailActivityViewControllerAnimate

#pragma mark - Lifecycle

- (void)loadView{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
}

- (id)initFrame:(CGRect)frame andActivity:(Activity *)activity For:(CANUOpenDetailsActivityAfter)canuOpenDetailsActivityAfter andPosition:(int)positionY{
    
    self = [super init];
    if (self) {
        
        self.canuOpenDetailsActivityAfter = canuOpenDetailsActivityAfter;

        self.frame                        = frame;

        self.activity                     = activity;

        self.positionY                    = positionY;

        self.keyboardIsOpen               = NO;
        self.descriptionIsOpen            = NO;
        self.closeAfterDelete             = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.frame = _frame;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    if (_canuOpenDetailsActivityAfter == CANUOpenDetailsActivityAfterFeedView) {
        self.wrapper.frame = CGRectMake(0, self.positionY - 10, 320, self.view.frame.size.height);
    }
    [self.view addSubview:_wrapper];
    
    self.chatView = [[ChatScrollView alloc]initWithFrame:CGRectMake(10, 10 + 130, 300,self.view.frame.size.height - 10 - 130 - 45 + 2) andActivity:_activity];
    self.chatView.delegate = self;
    [self.wrapper addSubview:_chatView];
    
    self.wrapperActivity = [self initializationWrapperActivity];
    [self.wrapper addSubview:_wrapperActivity];

    // Bottom Bar

    self.bottomBar = [[UICanuBottomBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    if (_canuOpenDetailsActivityAfter == CANUOpenDetailsActivityAfterFeedView) {
        self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 45);
    }
    [self.view addSubview:_bottomBar];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(0.0, 0.0, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    [self.bottomBar addSubview:_backButton];
    
    self.bottomButton = [[UICanuButton alloc]initWithFrame:CGRectMake(45, 4, 320 - 45 * 2, 37) forStyle:UICanuButtonStyleLarge];
    [self.bottomButton setTitle:NSLocalizedString(@"Invite others", nil) forState:UIControlStateNormal];
    [self.bottomButton addTarget:self action:@selector(bottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.bottomButton.alpha = 0;
    [self.bottomBar addSubview:self.bottomButton];
    
    self.sendButton = [[UICanuButton alloc]initWithFrame:CGRectMake(45 + 10, 4, (self.view.frame.size.width - (45 + 10)*2), 37.0) forStyle:UICanuButtonStyleNormal];
    [self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchDown];
    [self.sendButton sizeToFit];
    [self.bottomBar addSubview:_sendButton];
    self.sendButton.frame = CGRectMake(320 - 5 - self.sendButton.frame.size.width, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
    
    self.input = [[UITextView alloc] initWithFrame:CGRectMake(45 + 5, 6, 320 - 45 - 5 - 5 - self.sendButton.frame.size.width - 5, 30)];
    self.input.text = NSLocalizedString(@"Write something nice...", nil);
    self.input.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    self.input.backgroundColor = [UIColor whiteColor];
    self.input.textColor = UIColorFromRGB(0xabb3b7);
    self.input.returnKeyType = UIReturnKeyDefault;
    self.input.delegate = self;
    
    if (IS_OS_7_OR_LATER) {
        [self.input setTintColor:UIColorFromRGB(0x2b4b58)];
    }
    [_bottomBar addSubview:_input];

    UICanuNavigationController *navigation = appDelegate.canuViewController;
    
    if (_canuOpenDetailsActivityAfter == CANUOpenDetailsActivityAfterFeedView) {
        [UIView animateWithDuration:0.4 animations:^{
            [navigation changePosition:1];
            self.wrapper.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 45, 320, 45);
        } completion:^(BOOL finished) {
            navigation.control.hidden = YES;
            self.view.backgroundColor = backgroundColorView;
        }];
    } else if (_canuOpenDetailsActivityAfter == CANUOpenDetailsActivityAfterPush){
        [navigation changePosition:1];
        navigation.control.hidden = YES;
        self.view.backgroundColor = backgroundColorView;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCurrentChat) name:@"reloadCurrentChat" object:nil];
    
    if ([self.activity.notifications count] != 0) {
        [NSThread detachNewThreadSelector:@selector(readNotification) toTarget:self withObject:nil];
    }

}

- (void)viewDidAppear:(BOOL)animated{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Activity Details"];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    
    self.wrapperActivityDescription = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 99, 304, 0)];
    self.wrapperActivityDescription.image = [[UIImage imageNamed:@"E_activity_description"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0f];
    self.wrapperActivityDescription.clipsToBounds = YES;
    self.wrapperActivityDescription.userInteractionEnabled = YES;
    [self.wrapperActivity addSubview:_wrapperActivityDescription];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAttendees)];
    
    self.wrapperInvitList = [[InvitShow alloc]initWithFrame:CGRectMake( 2, 0, 300, 70)];
    self.wrapperInvitList.alpha = 0;
    [self.wrapperInvitList addGestureRecognizer:tap];
    self.wrapperInvitList.activity = _activity;
    
    if (![_activity.description isEqualToString:@""]) {
        
        self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(2 + 10, 10, 280, 0)];
        self.descriptionTextView.frame = CGRectMake(2 + 10, 10, 280, 5);
        self.descriptionTextView.font = [UIFont fontWithName:@"Lato-Regular" size:13];
        self.descriptionTextView.textColor = UIColorFromRGB(0x2b4b58);
        self.descriptionTextView.text = _activity.description;
        self.descriptionTextView.alpha = 0;
        [self.wrapperActivityDescription addSubview:_descriptionTextView];
        
        CGSize textViewSize = [self.descriptionTextView sizeThatFits:CGSizeMake(self.descriptionTextView.frame.size.width, FLT_MAX)];
        
        self.descriptionTextView.frame = CGRectMake(2 + 10, 10, 280, textViewSize.height);
        
        self.wrapperInvitList.frame = CGRectMake(2, 10 + self.descriptionTextView.frame.size.height + 10, 300, 70);
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10 + self.descriptionTextView.frame.size.height + 10, 300, 1)];
        line.image = [UIImage imageNamed:@"E_invit_line"];
        [self.wrapperActivityDescription addSubview:line];
        
    }
    
    [self.wrapperActivityDescription addSubview:_wrapperInvitList];
    
    self.descriptionIsOpen = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        if (![_activity.description isEqualToString:@""]) {
            self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, 10 + self.descriptionTextView.frame.size.height + 10 + self.wrapperInvitList.frame.size.height);
            self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130 + 10 + self.descriptionTextView.frame.size.height + 10 + self.wrapperInvitList.frame.size.height);
            self.wrapperActivityBottom.frame = CGRectMake(0, 100 + 10 + self.descriptionTextView.frame.size.height + 10 + self.wrapperInvitList.frame.size.height, 300, 30);
        } else {
            self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, self.wrapperInvitList.frame.size.height);
            self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130 + self.wrapperInvitList.frame.size.height);
            self.wrapperActivityBottom.frame = CGRectMake(0, 100 + self.wrapperInvitList.frame.size.height, 300, 30);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.descriptionTextView.alpha = 1;
            self.wrapperInvitList.alpha = 1;
        }];
    }];
    
    [self.chatView load];
    
}

#pragma mark - Private

- (UIView *)initializationWrapperActivity{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 130)];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, 304, 105)];
    background.image = [UIImage imageNamed:@"F_activity_background"];
    background.userInteractionEnabled = YES;
    [view addSubview:background];
    
    // Profile picture
    UIImageView *profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
    [profilePicture setImageWithURL:self.activity.user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
    [background addSubview:profilePicture];
    
    // Stroke profile picture
    UIImageView *strokePicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    strokePicture.image = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
    [profilePicture addSubview:strokePicture];
    
    self.userName = [[UICanuLabelUserName alloc] initWithFrame:CGRectMake(55, 18, 200, 17)];
    if ([self.activity.user.firstName mk_isEmpty]) {
        self.userName.text = self.activity.user.userName;
    } else {
        self.userName.text = self.activity.user.firstName;
    }
    [background addSubview:self.userName];
    
    CGSize expectedLabelSize = [self.userName.text sizeWithFont:self.userName.font
                                              constrainedToSize:self.userName.frame.size
                                                  lineBreakMode:self.userName.lineBreakMode];
    
    self.counterInvit = [[UILabel alloc]initWithFrame:CGRectMake( 55 + 5 + expectedLabelSize.width, 18, 70, 17)];
    self.counterInvit.textColor = UIColorFromRGB(0x2b4b58);
    self.counterInvit.alpha = 0.3;
    self.counterInvit.backgroundColor = [UIColor clearColor];
    self.counterInvit.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    if ([_activity.attendeeIds count] != 1) {
        self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[_activity.attendeeIds count] -1];
    }
    [background addSubview:_counterInvit];
    
    self.nameActivity = [[UICanuLabelActivityName alloc]initWithFrame:CGRectMake(10, 57, 280, 25)];
    self.nameActivity.text = _activity.title;
    [background addSubview:self.nameActivity];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.frame = CGRectMake(243.0f, 45, 45, 45);
    [background addSubview:_loadingIndicator];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.frame               = CGRectMake(view.frame.size.width - 10 - 45, 45, 45, 45);
    [self.actionButton addTarget:self action:@selector(eventActionButton) forControlEvents:UIControlEventTouchDown];
    [background addSubview:_actionButton];
    
    if ( _activity.status == UICanuActivityCellGo ) {
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
    } else if ( _activity.status == UICanuActivityCellToGo ) {
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
    } else {
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_edit"] forState:UIControlStateNormal];
        self.actionButton.frame = CGRectMake(view.frame.size.width - 23 - 30, 8, 45, 45);
    }
    
    self.wrapperActivityBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 300, 30)];
    [view addSubview:_wrapperActivityBottom];
    
    UIImageView *backgroundBottom = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -1, 304, 33)];
    backgroundBottom.image = [UIImage imageNamed:@"E_Activity_bottom"];
    [self.wrapperActivityBottom addSubview:backgroundBottom];
    
    self.date = [[UICanuLabelDate alloc]initWithFrame:CGRectMake(view.frame.size.width - 310 -2, -1, 300, 30)];
    [self.date setDate:_activity];
    [self.wrapperActivityBottom addSubview:self.date];
    
    self.location = [[UICanuLabelLocation alloc]initWithFrame:CGRectMake(10, -1, 210, 30)];
    self.location.text = _activity.locationDescription;
    [self.wrapperActivityBottom addSubview:self.location];
    
    CGSize sizeLocation = [self.location.text sizeWithFont:self.location.font
                                         constrainedToSize:self.location.frame.size
                                             lineBreakMode:self.location.lineBreakMode];
    
    CGSize sizeDate = [self.date.text sizeWithFont:self.date.font
                                 constrainedToSize:self.date.frame.size
                                     lineBreakMode:self.date.lineBreakMode];
    
    if (10 + sizeLocation.width+ 10 + sizeDate.width + 10 > 280) {
        int gap = 10 + sizeLocation.width + 10 + sizeDate.width + 10 - 300;
        self.location.frame = CGRectMake(10, -1, sizeLocation.width - gap, 30);
    }
    
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openInMap)];
    [self.wrapperActivityBottom addGestureRecognizer:tapMap];
    
    return view;
    
}

- (void)editActivity{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.counterInvit.alpha = 0;
        self.actionButton.alpha = 0;
        self.wrapperActivityBottom.alpha = 0;
        self.wrapperActivityBottom.frame = CGRectMake(_wrapperActivityBottom.frame.origin.x, _wrapperActivityBottom.frame.origin.y + 100, _wrapperActivityBottom.frame.size.width, _wrapperActivityBottom.frame.size.height);
        self.chatView.frame = CGRectMake(_chatView.frame.origin.x, _chatView.frame.origin.y + 100, _chatView.frame.size.width, _chatView.frame.size.height);
        self.chatView.alpha = 0;
        self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, _bottomBar.frame.origin.y + 45, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
    } completion:^(BOOL finished) {
        CreateEditActivityViewController *editView = [[CreateEditActivityViewController alloc]initForEdit:_activity];
        editView.delegate = self;
        
        [self addChildViewController:editView];
        [self.view addSubview:editView.view];
    }];
    
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (void)readNotification{
    
    [Notification readNotificationsForUser:[UserManager sharedUserManager].currentUser ToActivity:self.activity Block:^(NSError *error) {
        
        if (!error) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            [self.activity deleteNotifications];
            [appDelegate.feedViewController updateActivity:_activity];
        }
        
    }];
    
}

#pragma mark - ChatScrollViewDelegate

- (void)openDesciption{
    if (!_descriptionIsOpen) {
        self.descriptionIsOpen = YES;
        [UIView animateWithDuration:0.2 animations:^{
            if (![_activity.description isEqualToString:@""]) {
                self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, 10 + self.descriptionTextView.frame.size.height + 10 + self.wrapperInvitList.frame.size.height);
                self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130 + 10 + self.descriptionTextView.frame.size.height + 10 + self.wrapperInvitList.frame.size.height);
                self.wrapperActivityBottom.frame = CGRectMake(0, 100 + 10 + self.descriptionTextView.frame.size.height + 10 + self.wrapperInvitList.frame.size.height, 300, 30);
            } else {
                self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, self.wrapperInvitList.frame.size.height);
                self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130 + self.wrapperInvitList.frame.size.height);
                self.wrapperActivityBottom.frame = CGRectMake(0, 100 + self.wrapperInvitList.frame.size.height, 300, 30);
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.descriptionTextView.alpha = 1;
                self.wrapperInvitList.alpha = 1;
            }completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void)closeDescription{
    if (_descriptionIsOpen) {
        self.descriptionIsOpen = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.descriptionTextView.alpha = 0;
            self.wrapperInvitList.alpha = 0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, 0);
                self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130);
                self.wrapperActivityBottom.frame = CGRectMake(0, 100, 300, 30);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark - InvitOthersViewControllerDelegate

-(void)isDone{
    [self.attendeesList forceReload];
    [self goAddInvit];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (!_keyboardIsOpen) {
        
        if ([textView.text isEqualToString:NSLocalizedString(@"Write something nice...", nil)]) {
            textView.text = @"";
            textView.textColor = UIColorFromRGB(0x2b4b58);
        }
        
        self.keyboardIsOpen = YES;
        
        self.touchQuitKeyboard = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216 - 45, 320, 216 + 45)];
        [self.touchQuitKeyboard addTarget:self action:@selector(touchChatView) forControlEvents:UIControlEventTouchDown];
        [self.wrapper addSubview:_touchQuitKeyboard];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(0, - 216, 320, self.view.frame.size.height);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 45 - 216, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height);
        }];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (_keyboardIsOpen) {
        
        if ([textView.text isEqualToString:@""]) {
            textView.text = NSLocalizedString(@"Write something nice...", nil);
            textView.textColor = UIColorFromRGB(0xabb3b7);
        }
        
        self.keyboardIsOpen = NO;
        
        [self.touchQuitKeyboard removeFromSuperview];
        self.touchQuitKeyboard = nil;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 45, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height);
            self.input.frame = CGRectMake(_input.frame.origin.x, _input.frame.origin.y, _input.frame.size.width, 30);
            self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, 4, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
            self.backButton.frame = CGRectMake(0.0, 0, 45, 45);
        }];
        
        [textView resignFirstResponder];
        
    }
    
}

- (BOOL)textViewShouldReturn:(UITextView *)textView{
    
    [self sendMessage];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (_keyboardIsOpen) {
        
        int numberOfLine = (int)textView.contentSize.height / textView.font.lineHeight;
        
        if (numberOfLine > 6) {
            numberOfLine = 6;
        }
        
        self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 216 - 45 - ((numberOfLine - 2) * 15), 320, 45 + ((numberOfLine - 2) * 15));
        self.input.frame = CGRectMake(_input.frame.origin.x, _input.frame.origin.y, _input.frame.size.width, 30 + ((numberOfLine - 2) * 15));
        self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, 4 + (numberOfLine - 2) * 15, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
        self.backButton.frame = CGRectMake(0.0, ((numberOfLine - 2) * 15), 45, 45);
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return ![self stringContainsEmoji:text];
    
}

- (void)sendMessage{
    
    NSString *message = _input.text;
    
    if ([message length] != 0 && ![message isEqualToString:NSLocalizedString(@"Write something nice...", nil)] && ![message isEqualToString:@"\n"]) {
        
        [self.input becomeFirstResponder];
        
        [self.chatView addSendMessage:message];
        
        self.input.text = @"";
        
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 45 - 216, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height);
            self.input.frame = CGRectMake(_input.frame.origin.x, _input.frame.origin.y, _input.frame.size.width, 30);
            self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, 4, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
            self.backButton.frame = CGRectMake(0.0, 0, 45, 45);
        }];
        
        [_activity newMessage:message WithBlock:^(NSError *error){
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                
                [_chatView load];
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Chat" action:@"Send" label:nil value:nil] build]];
                
            }
            
        }];
    } else {
        
        [self.input resignFirstResponder];
        
        self.input.text = NSLocalizedString(@"Write something nice...", nil);
        self.input.textColor = UIColorFromRGB(0xabb3b7);
        
        self.keyboardIsOpen = NO;
        
        [self.touchQuitKeyboard removeFromSuperview];
        self.touchQuitKeyboard = nil;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 45, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height);
            self.input.frame = CGRectMake(_input.frame.origin.x, _input.frame.origin.y, _input.frame.size.width, 30);
            self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, 4, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
            self.backButton.frame = CGRectMake(0.0, 0, 45, 45);
        }];
        
    }
    
}

- (void)touchChatView{
    
    if (_keyboardIsOpen) {
        
        if ([self.input.text isEqualToString:@""]) {
            self.input.text = NSLocalizedString(@"Write something nice...", nil);
            self.input.textColor = UIColorFromRGB(0xabb3b7);
        }
        
        self.keyboardIsOpen = NO;
        
        [self.input resignFirstResponder];
        
        [self.touchQuitKeyboard removeFromSuperview];
        self.touchQuitKeyboard = nil;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 45, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height);
            self.input.frame = CGRectMake(_input.frame.origin.x, _input.frame.origin.y, _input.frame.size.width, 30);
            self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, 4, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
            self.backButton.frame = CGRectMake(0.0, 0, 45, 45);
        }];
    }
    
}

- (void)reloadCurrentChat{
    [self.chatView load];
}

- (void)eventActionButton{
    
    if (self.activity.status == UICanuActivityCellGo) {
        // don't attend
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
        
        [self.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
            } else {
                
                if ([_activity.attendeeIds count] != 1) {
                    self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[self.activity.attendeeIds count] -1];
                } else {
                    self.counterInvit.text = @"";
                }
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                [appDelegate.feedViewController updateActivity:_activity];
                
            }
        }];

    }else if (self.activity.status == UICanuActivityCellEditable){
        [self editActivity];
    }else{
        
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
        
        [self.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
            } else {
                
                if ([_activity.attendeeIds count] != 1) {
                    self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[self.activity.attendeeIds count] -1];
                } else {
                    self.counterInvit.text = @"";
                }
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                [appDelegate.feedViewController updateActivity:_activity];
                
            }
        }];
    }
}

- (void)createEditActivityIsFinish:(Activity *)activity{
    
    self.activity = activity;
    
    if ([self.activity.user.firstName mk_isEmpty]) {
        self.userName.text = self.activity.user.userName;
    } else {
        self.userName.text = self.activity.user.firstName;
    }
    self.nameActivity.text = self.activity.title;
    [self.date setDate:self.activity];
    self.location.text = self.activity.locationDescription;
    
    [UIView animateWithDuration:0.4 delay:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.counterInvit.alpha = 1;
        self.actionButton.alpha = 1;
        self.wrapperActivityBottom.alpha = 1;
        self.wrapperActivityBottom.frame = CGRectMake(_wrapperActivityBottom.frame.origin.x, _wrapperActivityBottom.frame.origin.y - 100, _wrapperActivityBottom.frame.size.width, _wrapperActivityBottom.frame.size.height);
        self.chatView.frame = CGRectMake(_chatView.frame.origin.x, _chatView.frame.origin.y - 100, _chatView.frame.size.width, _chatView.frame.size.height);
        self.chatView.alpha = 1;
        self.bottomBar.frame = CGRectMake(_bottomBar.frame.origin.x, _bottomBar.frame.origin.y - 45, _bottomBar.frame.size.width, _bottomBar.frame.size.height);
    } completion:^(BOOL finished) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        [appDelegate.feedViewController updateActivity:_activity];
    }];
    
}

- (void)currentActivityWasDeleted:(Activity *)activity{
    
    self.closeAfterDelete = YES;
    
    [self backAction];
    
}

- (void)backAction{
    
    if (_attendeesList && !_addInvit) {
        
        [self showAttendees];
        
    } else if (_keyboardIsOpen) {
        
        [self touchChatView];
        
    } else if (_addInvit) {
        
        [self goAddInvit];
        
    } else {
        
        [self animationBack];
        
    }
    
}

- (void)bottomButtonAction{
    
    if (_addInvit) {
        [self.addInvit addPeoples];
    } else {
        [self goAddInvit];
    }
    
}

- (void)animationBack{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    UICanuNavigationController *navigation = appDelegate.canuViewController;
    
    navigation.control.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chatView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.chatView removeFromSuperview];
        self.chatView = nil;
        
        [self.delegate closeDetailActivity:self];
        [UIView animateWithDuration:0.4 animations:^{
            [navigation changePosition:0];
            self.wrapper.frame = CGRectMake(0, _positionY - 10, 320, _wrapper.frame.size.height);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height, 320, 45);
            self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, 0);
            self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130);
            self.wrapperActivityBottom.frame = CGRectMake(0, 100, 300, 30);
            self.descriptionTextView.alpha = 0;
            self.wrapperInvitList.alpha = 0;
            self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:0.0];
        } completion:^(BOOL finished) {
            self.descriptionIsOpen = YES;
        }];
    }];
    
}

- (void)showAttendees{
    
    if (!_attendeesList) {
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Attendees"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        
        self.attendeesList = [[AttendeesScrollViewController alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height - 45) andActivity:_activity];
        [self addChildViewController:self.attendeesList];
        [self.view addSubview:self.attendeesList.view];
        self.attendeesList.view.alpha = 0;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.attendeesList.view.alpha = 1;
            self.wrapper.alpha = 0;
            self.wrapper.frame = CGRectMake(- 320, 0, 320, self.wrapper.frame.size.height);
            self.attendeesList.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 57);
            self.input.alpha = 0;
            self.sendButton.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.bottomButton.alpha = 1;
            }];
        }];
    }else{
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Details"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.bottomButton.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.attendeesList.view.alpha = 0;
                self.wrapper.alpha = 1;
                self.wrapper.frame = CGRectMake(0, 0, 320, self.wrapper.frame.size.height);
                self.attendeesList.view.frame = CGRectMake(320, 0, 320, self.view.frame.size.height - 57);
                self.input.alpha = 1;
                self.sendButton.alpha = 1;
            } completion:^(BOOL finished) {
                [self.attendeesList willMoveToParentViewController:nil];
                [self.attendeesList.view removeFromSuperview];
                [self.attendeesList removeFromParentViewController];
                self.attendeesList = nil;
            }];
        }];
    }
    
}

- (void)goAddInvit{
    
    if (!_addInvit) {
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Invite"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        
        self.addInvit = [[InvitOthersViewController alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height - 45) andActivity:self.activity andInvits:self.attendeesList.invits];
        self.addInvit.delegate = self;
        [self addChildViewController:self.addInvit];
        [self.view addSubview:self.addInvit.view];
        
        self.addInvit.view.alpha = 0;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.attendeesList.view.alpha = 0;
            self.attendeesList.view.frame = CGRectMake(-320, 0, 320, self.view.frame.size.height - 45);
            self.addInvit.view.alpha = 1;
            self.addInvit.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 45);
            self.bottomButton.alpha = 0;
        } completion:^(BOOL finished) {
            [self.bottomButton setTitle:NSLocalizedString(@"Add peoples", nil) forState:UIControlStateNormal];
            [UIView animateWithDuration:0.4 animations:^{
                self.bottomButton.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }else{
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Attendees"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.attendeesList.view.alpha = 1;
            self.attendeesList.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 45);
            self.addInvit.view.alpha = 0;
            self.addInvit.view.frame = CGRectMake(320, 0, 320, self.view.frame.size.height - 45);
            self.bottomButton.alpha = 0;
        } completion:^(BOOL finished) {
            [self.addInvit willMoveToParentViewController:nil];
            if ([self.addInvit.view superview]) {
                [self.addInvit.view removeFromSuperview];
            }
            [self.addInvit removeFromParentViewController];
            self.addInvit = nil;
            [self.bottomButton setTitle:NSLocalizedString(@"Invite others", nil) forState:UIControlStateNormal];
            [UIView animateWithDuration:0.4 animations:^{
                self.bottomButton.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    
}

- (void)openInMap{
    
    NSMutableArray *buttons = [NSMutableArray new];
    [buttons addObject:NSLocalizedString(@"Open in Maps", nil)];
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps-x-callback://"]]) {
        [buttons addObject:NSLocalizedString(@"Open in Google Maps", nil)];
    }
    [buttons addObject:NSLocalizedString(@"Copy adress", nil)];
    
    UIActivityViewControllerCustom *activityView = [[UIActivityViewControllerCustom alloc]initWithUIImage:[UIImage imageNamed:@"D_maps"] andButtons:buttons];
    activityView.delegate = self;
    [activityView show];
    
}

- (void)ActivityAction:(NSString *)action{
    
    if ([action isEqualToString:NSLocalizedString(@"Open in Maps", nil)]) {
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]){
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.activity.coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:self.activity.title];
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                           launchOptions:launchOptions];
        }
    } else if ([action isEqualToString:NSLocalizedString(@"Open in Google Maps", nil)]) {
        NSString *url = [NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=&daddr=%f,%f&center=%f,%f&zoom=20&directionsmode=transit&x-success=secanucanu://?resume=true&x-source=CANU",self.activity.coordinate.latitude,self.activity.coordinate.longitude,self.activity.coordinate.latitude,self.activity.coordinate.longitude];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else if ([action isEqualToString:NSLocalizedString(@"Copy adress", nil)]) {
        NSString *adress;
        if ([self.activity.placeName mk_isEmpty]) {
            adress = [NSString stringWithFormat:@"%@, %@, %@, %@",self.activity.street,self.activity.city, self.activity.zip,self.activity.country];
        } else {
            adress = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",self.activity.placeName,self.activity.street,self.activity.city, self.activity.zip,self.activity.country];
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = adress;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"dealloc Detail Activity");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
