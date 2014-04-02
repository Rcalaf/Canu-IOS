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

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@interface DetailActivityViewControllerAnimate ()<MKMapViewDelegate,UITextViewDelegate,UIScrollViewDelegate,CreateEditActivityViewControllerDelegate,ChatScrollViewDelegate>

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
@property (nonatomic, strong) UIImageView *wrapperActivityDescription;
@property (nonatomic, strong) UIView *wrapperActivityBottom;
@property (nonatomic, strong) UITextView *input;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *counterInvit;
@property (nonatomic, strong) UICanuButton *sendButton;
@property (nonatomic, strong) ChatScrollView *chatView;
@property (nonatomic, strong) UICanuBottomBar *bottomBar;
@property (nonatomic, strong) AttendeesScrollViewController *attendeesList;

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
        
        self.frame           = frame;

        self.activity        = activity;

        self.positionY       = positionY;

        self.keyboardIsOpen  = NO;
        self.descriptionIsOpen = NO;
        self.closeAfterDelete= NO;
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
//    if (_canuOpenDetailsActivityAfter == CANUOpenDetailsActivityAfterFeedView) {
//        self.chatView.frame = CGRectMake(10, 10 + 130 + 50, 300,self.view.frame.size.height - 10 - 130 - 45 + 2);
//    }
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
    [self.input setReturnKeyType:UIReturnKeySend];
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
//            self.chatView.alpha = 1;
//            self.chatView.frame = CGRectMake(10, 10 + 130, 300,self.view.frame.size.height - 10 - 130 - 45 + 2);
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

}

- (void)viewDidAppear:(BOOL)animated{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Activity Details"];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    
    self.wrapperActivityDescription = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 99, 304, 0)];
    self.wrapperActivityDescription.image = [[UIImage imageNamed:@"E_activity_description"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0f];
    self.wrapperActivityDescription.clipsToBounds = YES;
    [self.wrapperActivity addSubview:_wrapperActivityDescription];
    
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(2 + 10, 10, 280, 5)];
    self.descriptionTextView.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    self.descriptionTextView.textColor = UIColorFromRGB(0xbfc9cd);
    self.descriptionTextView.text = _activity.description;
    self.descriptionTextView.alpha = 0;
    [self.wrapperActivityDescription addSubview:_descriptionTextView];
    
    CGSize textViewSize = [self.descriptionTextView sizeThatFits:CGSizeMake(self.descriptionTextView.frame.size.width, FLT_MAX)];
    
    self.descriptionTextView.frame = CGRectMake(2 + 10, 10, 280, textViewSize.height);
    
    if (![_activity.description isEqualToString:@""]) {
        [UIView animateWithDuration:0.4 animations:^{
            self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, 10 + textViewSize.height + 10);
            self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130 + 10 + textViewSize.height + 10);
            self.wrapperActivityBottom.frame = CGRectMake(0, 100 + 10 + textViewSize.height + 10, 300, 30);
        } completion:^(BOOL finished) {
            self.descriptionIsOpen = YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.descriptionTextView.alpha = 1;
            }];
        }];
    }
    
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
    
    UICanuLabelUserName *userName = [[UICanuLabelUserName alloc] initWithFrame:CGRectMake(55, 18, 200, 17)];
    userName.text = self.activity.user.userName;
    [background addSubview:userName];
    
    CGSize expectedLabelSize = [userName.text sizeWithFont:userName.font
                                              constrainedToSize:userName.frame.size
                                                  lineBreakMode:userName.lineBreakMode];
    
    self.counterInvit = [[UILabel alloc]initWithFrame:CGRectMake( 55 + 5 + expectedLabelSize.width, 18, 70, 17)];
    self.counterInvit.textColor = UIColorFromRGB(0x2b4b58);
    self.counterInvit.alpha = 0.3;
    self.counterInvit.backgroundColor = [UIColor clearColor];
    self.counterInvit.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    if ([_activity.attendeeIds count] != 1) {
        self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[_activity.attendeeIds count] -1];
    }
    [background addSubview:_counterInvit];
    
    UICanuLabelActivityName *nameActivity = [[UICanuLabelActivityName alloc]initWithFrame:CGRectMake(10, 57, 280, 25)];
    nameActivity.text = _activity.title;
    [background addSubview:nameActivity];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingIndicator.frame = CGRectMake(243.0f, 45, 45, 45);
    [background addSubview:_loadingIndicator];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionButton.frame               = CGRectMake(view.frame.size.width - 10 - 45, 45, 45, 45);
    [self.actionButton addTarget:self action:@selector(eventActionButton) forControlEvents:UIControlEventTouchDown];
    [background addSubview:_actionButton];
    
    if ( _activity.status == UICanuActivityCellGo ) {
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
    } else if ( _activity.status == UICanuActivityCellToGo ){
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
    } else {
        [self.actionButton setImage:[UIImage imageNamed:@"feed_action_edit"] forState:UIControlStateNormal];
        self.actionButton.frame = CGRectMake(view.frame.size.width - 23 - 18, 17, 18, 18);
    }
    
    self.wrapperActivityBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 300, 30)];
    [view addSubview:_wrapperActivityBottom];
    
    UIImageView *backgroundBottom = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -1, 304, 33)];
    backgroundBottom.image = [UIImage imageNamed:@"E_Activity_bottom"];
    backgroundBottom.userInteractionEnabled = YES;
    [self.wrapperActivityBottom addSubview:backgroundBottom];
    
    UICanuLabelLocation *location = [[UICanuLabelLocation alloc]initWithFrame:CGRectMake(10, -1, 210, 30)];
    location.text = _activity.locationDescription;
    [self.wrapperActivityBottom addSubview:location];
    
    UICanuLabelDate *date = [[UICanuLabelDate alloc]initWithFrame:CGRectMake(view.frame.size.width - 310 -2, -1, 300, 30)];
    [date setDate:_activity];
    [self.wrapperActivityBottom addSubview:date];
    
    return view;
    
}

#pragma mark - ChatScrollViewDelegate

- (void)openDesciption{
    if (!_descriptionIsOpen && ![_activity.description isEqualToString:@""]) {
        self.descriptionIsOpen = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, 10 + self.descriptionTextView.frame.size.height + 10);
            self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130 + 10 + self.descriptionTextView.frame.size.height + 10);
            self.wrapperActivityBottom.frame = CGRectMake(0, 100 + 10 + self.descriptionTextView.frame.size.height + 10, 300, 30);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.descriptionTextView.alpha = 1;
            }completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void)closeDescription{
    if (_descriptionIsOpen && ![_activity.description isEqualToString:@""]) {
        self.descriptionIsOpen = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.descriptionTextView.alpha = 0;
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

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (!_keyboardIsOpen) {
        
        if ([textView.text isEqualToString:NSLocalizedString(@"Write something nice...", nil)]) {
            textView.text = @"";
            textView.textColor = UIColorFromRGB(0x2b4b58);
        }
        
        self.keyboardIsOpen = YES;
        
        self.touchQuitKeyboard = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216 - 57, 320, 216 + 57)];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (_keyboardIsOpen) {
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
        }
        
        int numberOfLine = (int)textView.contentSize.height / textView.font.lineHeight;
        
        if (numberOfLine > 6) {
            numberOfLine = 6;
        }
        
        self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 216 - 45 - ((numberOfLine - 2) * 15), 320, 45);
        self.input.frame = CGRectMake(_input.frame.origin.x, _input.frame.origin.y, _input.frame.size.width, 30 + ((numberOfLine - 2) * 15));
        self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, 4 + (numberOfLine - 2) * 15, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
        self.backButton.frame = CGRectMake(0.0, ((numberOfLine - 2) * 15), 45, 45);
    }
    
    return YES;
}

- (void)sendMessage{
    
    [self.input resignFirstResponder];
    
    NSString *message = _input.text;
    if ([message length] != 0 && ![message isEqualToString:NSLocalizedString(@"Write something nice...", nil)]) {
        [self.chatView addSendMessage:message];
        [_activity newMessage:message WithBlock:^(NSError *error){
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                
                [_chatView load];
                
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Chat" action:@"Send" label:nil value:nil] build]];
            }
            
        }];
    }
    
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

- (void)eventActionButton{
    
    if (self.activity.status == UICanuActivityCellGo) {
        // don't attend
        [self.loadingIndicator startAnimating];
        self.actionButton.hidden = YES;
        
        [self.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                self.actionButton.hidden = NO;
            } else {
                
                [_actionButton setImage:[UIImage imageNamed:@"feed_action_go"] forState:UIControlStateNormal];
                if ([_activity.attendeeIds count] != 1) {
                    self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[self.activity.attendeeIds count] -1];
                }
                self.actionButton.hidden = NO;
                
            }
        }];

    }else if (self.activity.status == UICanuActivityCellEditable){
        // edit
        CreateEditActivityViewController *editView = [[CreateEditActivityViewController alloc]initForEdit:self.activity];
        editView.delegate = self;
        [self presentViewController:editView animated:YES completion:nil];
    }else{
        [self.loadingIndicator startAnimating];
        self.actionButton.hidden = YES;
        
        [self.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                self.actionButton.hidden = NO;
            } else {
                
                [_actionButton setImage:[UIImage imageNamed:@"feed_action_yes"] forState:UIControlStateNormal];
                
                if ([_activity.attendeeIds count] != 1) {
                    self.counterInvit.text = [NSString stringWithFormat:@"&%lu",(unsigned long)[self.activity.attendeeIds count] -1];
                }
                self.actionButton.hidden = NO;
                
            }
        }];
    }
}

- (void)currentActivityWasDeleted{
    
    self.closeAfterDelete = YES;
    
    [self backAction];
    
}

- (void)backAction{
    
    if (_attendeesList != nil) {
        
        [self showAttendees];
        
    }else if (_keyboardIsOpen){
        
        [self touchChatView];
        
    }else{
        
        [self animationBack];
        
    }
    
}

- (void)animationBack{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    UICanuNavigationController *navigation = appDelegate.canuViewController;
    
    navigation.control.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chatView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.delegate closeDetailActivity:self];
        [UIView animateWithDuration:0.4 animations:^{
            [navigation changePosition:0];
            self.wrapper.frame = CGRectMake(0, _positionY - 10, 320, _wrapper.frame.size.height);
            self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height, 320, 45);
            self.wrapperActivityDescription.frame = CGRectMake(-2, 99, 304, 0);
            self.wrapperActivity.frame = CGRectMake(10, 10, 300, 130);
            self.wrapperActivityBottom.frame = CGRectMake(0, 100, 300, 30);
            self.descriptionTextView.alpha = 0;
            self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:0.0];
        } completion:^(BOOL finished) {
            self.descriptionIsOpen = YES;
        }];
    }];
    
}

- (void)showAttendees{
    
    if (_attendeesList == nil) {
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Attendees"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        
        self.attendeesList = [[AttendeesScrollViewController alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height - 57) andActivity:_activity];
        [self addChildViewController:self.attendeesList];
        [self.view addSubview:self.attendeesList.view];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.wrapper.frame = CGRectMake(- 320, 0, 320, self.wrapper.frame.size.height);
            self.attendeesList.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 57);
            self.actionButton.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Details"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, 320, self.wrapper.frame.size.height);
            self.attendeesList.view.frame = CGRectMake(320, 0, 320, self.view.frame.size.height - 57);
            self.actionButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.attendeesList willMoveToParentViewController:nil];
            [self.attendeesList.view removeFromSuperview];
            [self.attendeesList removeFromParentViewController];
            self.attendeesList = nil;
        }];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    if(annotation != mapView.userLocation) {
        
        annotationView.image = [UIImage imageNamed:@"map_pin"];
        
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
    
}

- (void)openInMap{
    
    NSLog(@"openInMap");
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]){
        // Create an MKMapItem to pass to the Maps app
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_activity.coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:_activity.title];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"dealloc Detail Activity");
    
}

@end
