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
#import "UIImageView+AFNetworking.h"
#import "ChatScrollView.h"
#import "AFCanuAPIClient.h"
#import "NewActivityViewController.h"
#import "AttendeesScrollViewController.h"
#import "LoaderAnimation.h"
#import <MapKit/MapKit.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@interface DetailActivityViewControllerAnimate ()<MKMapViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic) int positionY;
@property (nonatomic) Activity *activity;
@property (nonatomic) UIView *wrapper;
@property (nonatomic) UIView *wrapperName;
@property (nonatomic) UIView *wrapperMap;
@property (nonatomic) UIView *wrapperDescription;
@property (nonatomic) UIView *wrapperBottomBar;
@property (nonatomic) UIView *wrapperInput;
@property (nonatomic) UIImageView *actionButtonImage;
@property (nonatomic) ChatScrollView *chatView;
@property (nonatomic) MKMapView *mapView;
@property (nonatomic) UIButton *actionButton;
@property (nonatomic) UIButton *attendeesButton;
@property (nonatomic) UIButton *touchArea;
@property (nonatomic) UIButton *touchQuitKeyboard;
@property (nonatomic) UILabel *numberOfAssistents;
@property (nonatomic) BOOL chatIsOpen;
@property (nonatomic) UIImageView *shadow;
@property (nonatomic) UITextField *input;
@property (nonatomic) BOOL keyboardIsOpen;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) BOOL animationFolder;
@property (nonatomic) AttendeesScrollViewController *attendeesList;
@property (nonatomic) CGRect frame;

@end

@implementation DetailActivityViewControllerAnimate

- (void)loadView{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

- (id)initFrame:(CGRect)frame andActivity:(Activity *)activity andPosition:(int)positionY{
    
    self = [super init];
    if (self) {
        NSLog(@"Start Init");
        
        self.frame = frame;
        
        self.activity = activity;
        
        self.positionY = positionY;
        
        self.chatIsOpen = NO;
        self.keyboardIsOpen = NO;
        self.animationFolder = NO;
        
        NSLog(@"End Init");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Start viewDidLoad");
    
    self.view.frame = _frame;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, self.positionY - 10, 320, self.view.frame.size.height)];
    [self.view addSubview:_wrapper];
    
    self.chatView = [[ChatScrollView alloc]initWithFrame:CGRectMake(10, 130, 300,0) andActivity:_activity andMaxHeight:self.view.frame.size.height - 130 - 57 andMinHeight:self.view.frame.size.height - 340 - 57];
    [self.wrapper addSubview:_chatView];
    
    // User
    
    UIView *wrapperUser = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 166, 34)];
    wrapperUser.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [self.wrapper addSubview:wrapperUser];
    
    UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    [avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,_activity.user.profileImageUrl]] placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    [wrapperUser addSubview:avatar];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(37.0f, 5.0f, 128.0f, 25.0f)];
    userName.text = self.activity.user.userName;
    userName.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
    userName.backgroundColor = UIColorFromRGB(0xf9f9f9);
    userName.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
    [wrapperUser addSubview:userName];
    
    UIView *wrapperTime = [[UIView alloc]initWithFrame:CGRectMake(177, 10, 133, 34)];
    wrapperTime.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [self.wrapper addSubview:wrapperTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat = @"d MMM";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 33, 34)];
    day.text = [dateFormatter stringFromDate:self.activity.start];
    day.font = [UIFont fontWithName:@"Lato-Regular" size:10.0];
    day.backgroundColor = UIColorFromRGB(0xf9f9f9);
    day.textColor = UIColorFromRGB(0x2b4b58);
    [wrapperTime addSubview:day];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
    timeFormatter.dateFormat = @"HH:mm";
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    UILabel *timeStart = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 44, 34)];
    timeStart.text = [timeFormatter stringFromDate:self.activity.start];
    timeStart.font = [UIFont fontWithName:@"Lato-Bold" size:11.0];
    timeStart.backgroundColor = UIColorFromRGB(0xf9f9f9);
    timeStart.textColor = UIColorFromRGB(0x2b4b58);
    [wrapperTime addSubview:timeStart];
    
    UILabel *timeEnd = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 44, 34)];
    timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:self.activity.end]];
    timeEnd.font = [UIFont fontWithName:@"Lato-Italic" size:11.0];
    timeEnd.backgroundColor = UIColorFromRGB(0xf9f9f9);
    timeEnd.textColor = UIColorFromRGB(0x2b4b58);
    timeEnd.alpha = 0.5;
    [wrapperTime addSubview:timeEnd];
    
    // Map
    
    self.wrapperMap = [[UIView alloc]initWithFrame:CGRectMake(10, 45, 300, 0)];
    self.wrapperMap.clipsToBounds = YES;
    self.wrapperMap.backgroundColor = [UIColor whiteColor];
    [self.wrapper addSubview:_wrapperMap];
    
    // Description
    
    self.wrapperDescription = [[UIView alloc]initWithFrame:CGRectMake(10, 130, 300, 0)];
    self.wrapperDescription.backgroundColor = [UIColor whiteColor];
    self.wrapperDescription.clipsToBounds = YES;
    [self.wrapper addSubview:_wrapperDescription];
    
    // Name
    self.wrapperName = [[UIView alloc]initWithFrame:CGRectMake(10, 45, 300, 85)];
    self.wrapperName.backgroundColor = [UIColor whiteColor];
    [self.wrapper addSubview:_wrapperName];
    
    UILabel *nameActivity = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, 210, 28)];
    nameActivity.font = [UIFont fontWithName:@"Lato-Bold" size:22.0];
    nameActivity.backgroundColor = [UIColor whiteColor];
    nameActivity.textColor = UIColorFromRGB(0x2b4b58);
    nameActivity.text = _activity.title;
    [_wrapperName addSubview:nameActivity];
    
    UILabel *location = [[UILabel alloc]initWithFrame:CGRectMake(16, 52, 210, 16)];
    location.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
    location.backgroundColor = [UIColor whiteColor];
    location.textColor = UIColorFromRGB(0x2b4b58);
    location.text = _activity.locationDescription;
    [_wrapperName addSubview:location];
    
    self.actionButtonImage = [[UIImageView alloc]initWithFrame:CGRectMake(243, 19, 47, 47)];
    [self.wrapperName addSubview:_actionButtonImage];
    
    if ( _activity.status == UICanuActivityCellGo ) {
        self.actionButtonImage.image = [UIImage imageNamed:@"feed_action_yes"];
    } else if ( _activity.status == UICanuActivityCellToGo ){
        self.actionButtonImage.image = [UIImage imageNamed:@"feed_action_go.png"];
    } else {
        self.actionButtonImage.image = [UIImage imageNamed:@"feed_action_edit.png"];
    }
    
    self.shadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 85, 300, 4)];
    self.shadow.image = [UIImage imageNamed:@"feed_shadow_name"];
    self.shadow.alpha = 0;
    [self.wrapperName addSubview:_shadow];
    
    // ScrollView
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 195, 300, 145)];
    self.scrollView.contentSize = CGSizeMake(300, 145 + 1);
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.wrapper addSubview:_scrollView];
    
    // Touch Area
    
    self.touchArea = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.touchArea addTarget:self action:@selector(folderAnimation) forControlEvents:UIControlEventTouchDown];
    [self.wrapper addSubview:_touchArea];
    
    // Bottom Bar
    
    self.wrapperBottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 57)];
    self.wrapperBottomBar.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [self.view addSubview:_wrapperBottomBar];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 57)];
    [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    [self.wrapperBottomBar addSubview:backButton];
    
    self.attendeesButton = [[UIButton alloc]initWithFrame:CGRectMake(67, 10, 116, 37)];
    [self.attendeesButton setImage:[UIImage imageNamed:@"fullview_action_ppl"] forState:UIControlStateNormal];
    [self.attendeesButton setImage:[UIImage imageNamed:@"fullview_action_ppl"] forState:UIControlStateHighlighted];
    [self.attendeesButton addTarget:self action:@selector(showAttendees) forControlEvents:UIControlEventTouchDown];
    [self.wrapperBottomBar addSubview:_attendeesButton];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.actionButton addTarget:self action:@selector(eventActionButton) forControlEvents:UIControlEventTouchDown];
    [_actionButton setFrame:CGRectMake(194, 10, 116, 37)];
    
    if (appDelegate.user.userId == self.activity.user.userId) [_actionButton setImage:[UIImage imageNamed:@"fullview_action_edit.png"] forState:UIControlStateNormal];
    else if ([self.activity.attendeeIds indexOfObject:[NSNumber numberWithUnsignedInteger:appDelegate.user.userId]] == NSNotFound) [_actionButton setImage:[UIImage imageNamed:@"fullview_action_go.png"] forState:UIControlStateNormal];
    else [_actionButton setImage:[UIImage imageNamed:@"fullview_action_yes.png"] forState:UIControlStateNormal];
    
    [self.wrapperBottomBar addSubview:_actionButton];
    
    UIView *lineBottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, -1, 320, 1)];
    lineBottomBar.backgroundColor = UIColorFromRGB(0xd4e0e0);
    [self.wrapperBottomBar addSubview:lineBottomBar];
    
    UICanuNavigationController *navigation = appDelegate.canuViewController;
    
    [UIView animateWithDuration:0.4 animations:^{
        [navigation changePosition:1];
        self.wrapper.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        self.actionButtonImage.alpha = 0;
        self.wrapperMap.frame = CGRectMake(10, 45, 300, 150);
        self.wrapperName.frame = CGRectMake(10, 195, 300, 85);
        self.wrapperDescription.frame = CGRectMake(10, 280, 300, 60);
        self.chatView.frame = CGRectMake(10, 340, 300, self.view.frame.size.height - 340 - 57);
        self.touchArea.frame = CGRectMake(10, 340, 300, self.view.frame.size.height - 340 - 57);
        self.wrapperBottomBar.frame = CGRectMake(0, self.view.frame.size.height - 57, 320, 57);
        self.shadow.alpha = 1;
        self.shadow.frame = CGRectMake(0, 85 + 60, 300, 4);
    } completion:^(BOOL finished) {
        navigation.control.hidden = YES;
        self.view.backgroundColor = backgroundColorView;
    }];
    
    NSLog(@"End viewDidLoad");
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"Start viewDidAppear");
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Activity Details"];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    
    [self.chatView load];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.activity.coordinate, 400, 400);
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 10, 280, 140)];
    self.mapView.delegate = self;
    [self.mapView addAnnotation:self.activity.location.placemark];
    self.mapView.region = viewRegion;
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self.wrapperMap addSubview:_mapView];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 268, 40)];
    description.text = self.activity.description;
    description.font = [UIFont fontWithName:@"Lato-Regular" size:12.0];
    description.numberOfLines = 2;
    description.textColor = UIColorFromRGB(0x2b4b58);
    description.backgroundColor = [UIColor whiteColor];
    [self.wrapperDescription addSubview:description];
    
    self.numberOfAssistents = [[UILabel alloc]initWithFrame:CGRectMake(68, 0, 44, 37)];
    self.numberOfAssistents.text = [NSString stringWithFormat:@"%i",[self.activity.attendeeIds count]];
    self.numberOfAssistents.textColor = UIColorFromRGB(0x2b4b58);
    self.numberOfAssistents.font = [UIFont fontWithName:@"Lato-Bold" size:16.0];
    self.numberOfAssistents.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.0f];
    [_attendeesButton.imageView addSubview:_numberOfAssistents];
    
    // Input Bar
    self.wrapperInput = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 57)];
    self.wrapperInput.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [self.view addSubview:_wrapperInput];
    
    UIView *inputBackground = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 37)];
    inputBackground.backgroundColor = [UIColor whiteColor];
    [self.wrapperInput addSubview:inputBackground];
    
    self.input = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 220, 32)];
    self.input.placeholder = @"Write something nice...";
    self.input.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    self.input.backgroundColor = [UIColor whiteColor];
    self.input.textColor = UIColorFromRGB(0x6d6e7a);
    [self.input setReturnKeyType:UIReturnKeySend];
    self.input.delegate = self;
    [inputBackground addSubview:_input];
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.input.frame = CGRectMake(10, 8, 220, 20);
    }
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(237, 2, 61, 33)];
    [sendButton setImage:[UIImage imageNamed:@"chat_send"] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"chat_send"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchDown];
    [inputBackground addSubview:sendButton];
    
    UIView *lineInputBar = [[UIView alloc]initWithFrame:CGRectMake(0, -1, 320, 1)];
    lineInputBar.backgroundColor = UIColorFromRGB(0xd4e0e0);
    [self.wrapperInput addSubview:lineInputBar];
    NSLog(@"End viewDidAppear");
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!_animationFolder) {
        if (scrollView.contentOffset.y >= 65) {
            [self folderAnimation];
            self.scrollView.userInteractionEnabled = NO;
            self.scrollView.scrollEnabled = NO;
            [self killScroll];
        }else if (scrollView.contentOffset.y <= 0) {
            self.mapView.frame = CGRectMake(10, 10, 280, 140);
            self.wrapperMap.frame = CGRectMake(10, 45, 300, 150);
            self.wrapperName.frame = CGRectMake(10, 195, 300, 85);
            self.wrapperDescription.frame = CGRectMake(10, 280, 300, 60);
            self.chatView.frame = CGRectMake(10, 340, 300, self.view.frame.size.height - 340 - 57);
            [self.chatView scrollAnimationFolderFor:0];
        }else{
            self.mapView.frame = CGRectMake(10, 10 - scrollView.contentOffset.y, 280, 140);
            self.wrapperMap.frame = CGRectMake(10, 45, 300, 150 - scrollView.contentOffset.y);
            self.wrapperName.frame = CGRectMake(10, 195 - scrollView.contentOffset.y, 300, 85);
            self.wrapperDescription.frame = CGRectMake(10, 280 - scrollView.contentOffset.y, 300, 60);
            self.chatView.frame = CGRectMake(10, 340 - scrollView.contentOffset.y, 300, self.view.frame.size.height - 340 - 57 + scrollView.contentOffset.y);
            [self.chatView scrollAnimationFolderFor:scrollView.contentOffset.y];
        }
    } 
    
}

- (void)folderAnimation{
    
    if (!_animationFolder) {
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Details"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
        
        self.animationFolder = YES;
        
        self.chatView.loaderAnimation.alpha = 0;
        
        [self.chatView killScroll];
        
        if (_chatIsOpen) {
            [UIView animateWithDuration:0.4 animations:^{
                [self.chatView scrollToLastMessage];
                self.mapView.frame = CGRectMake(10, 10, 280, 140);
                self.wrapperMap.frame = CGRectMake(10, 45, 300, 150);
                self.wrapperName.frame = CGRectMake(10, 195, 300, 85);
                self.wrapperDescription.frame = CGRectMake(10, 280, 300, 60);
                self.chatView.frame = CGRectMake(10, 340, 300, self.view.frame.size.height - 340 - 57);
                self.touchArea.frame = CGRectMake(10, 340, 300, self.view.frame.size.height - 340 - 57);
                self.wrapperInput.frame = CGRectMake(0, self.view.frame.size.height, 320, 57);
                self.scrollView.frame = CGRectMake(10, 195, 300, 145);
                self.shadow.frame = CGRectMake(0, 85 + 60, 300, 4);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.wrapperBottomBar.frame = CGRectMake(0, self.view.frame.size.height - 57, 320, 57);
                } completion:^(BOOL finished) {
                    [self.chatView scrollToLastMessage];
                    self.animationFolder = NO;
                    self.scrollView.scrollEnabled = YES;
                    self.scrollView.userInteractionEnabled = YES;
                    self.chatView.loaderAnimation.alpha = 1;
                }];
            }];
            
        }else{
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker set:kGAIScreenName value:@"Activity Chat"];
            [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
            
            if ([_chatView.arrayCell count] == 0) {
                self.keyboardIsOpen = YES;
                [self.input becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.4 animations:^{
                [self.chatView scrollToBottom];
                if ([_chatView.arrayCell count] == 0) {
                    self.wrapper.frame = CGRectMake(0, - 216, 320, self.view.frame.size.height);
                }
                self.mapView.frame = CGRectMake(10, - 140, 280, 140);
                self.wrapperMap.frame = CGRectMake(10, 45, 300, 0);
                self.wrapperName.frame = CGRectMake(10, 45, 300, 85);
                self.wrapperDescription.frame = CGRectMake(10, 130, 300, 0);
                self.chatView.frame = CGRectMake(10, 130, 300, self.view.frame.size.height - 130 - 57);
                self.touchArea.frame = CGRectMake(10, 10, 300, 120);
                self.wrapperBottomBar.frame = CGRectMake(0, self.view.frame.size.height, 320, 57);
                self.scrollView.frame = CGRectMake(10, 45, 300, 85);
                self.shadow.frame = CGRectMake(0, 85, 300, 4);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    if ([_chatView.arrayCell count] == 0) {
                        self.wrapperInput.frame = CGRectMake(0, self.view.frame.size.height - 57 - 216, 320, 57);
                    }else{
                        self.wrapperInput.frame = CGRectMake(0, self.view.frame.size.height - 57, 320, 57);
                    }
                } completion:^(BOOL finished) {
                    self.animationFolder = NO;
                    self.scrollView.scrollEnabled = YES;
                    self.scrollView.userInteractionEnabled = YES;
                    self.chatView.loaderAnimation.alpha = 1;
                    if ([_chatView.arrayCell count] == 0) {
                        self.touchQuitKeyboard = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216 - 57, 320, 216 + 57)];
                        [self.touchQuitKeyboard addTarget:self action:@selector(touchChatView) forControlEvents:UIControlEventTouchDown];
                        [self.wrapper addSubview:_touchQuitKeyboard];
                    }
                }];
            }];
            
        }
        
        self.chatIsOpen = !_chatIsOpen;
        
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!_keyboardIsOpen) {
        self.keyboardIsOpen = YES;
        
        self.touchQuitKeyboard = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 216 - 57, 320, 216 + 57)];
        [self.touchQuitKeyboard addTarget:self action:@selector(touchChatView) forControlEvents:UIControlEventTouchDown];
        [self.wrapper addSubview:_touchQuitKeyboard];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(0, - 216, 320, self.view.frame.size.height);
            self.wrapperInput.frame = CGRectMake(0, self.view.frame.size.height - 57 - 216, 320, 57);
        }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self sendMessage];
    
    return YES;
}

- (void)killScroll{
    CGPoint offset = self.scrollView.contentOffset;
    [self.scrollView setContentOffset:offset animated:NO];
}

- (void)sendMessage{
    NSLog(@"sendMessage");
    [self.input resignFirstResponder];
    
    NSString *message = _input.text;
    self.input.text = @"";
    if ([message length] != 0) {
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
    
    self.keyboardIsOpen = NO;
    
    [self.touchQuitKeyboard removeFromSuperview];
    self.touchQuitKeyboard = nil;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.wrapper.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        self.wrapperInput.frame = CGRectMake(0, self.view.frame.size.height - 57, 320, 57);
    }];
    
}

- (void)touchChatView{
    NSLog(@"touchChatView");
    if (_keyboardIsOpen) {
        
        self.keyboardIsOpen = NO;
        
        [self.input resignFirstResponder];
        
        [self.touchQuitKeyboard removeFromSuperview];
        self.touchQuitKeyboard = nil;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            self.wrapperInput.frame = CGRectMake(0, self.view.frame.size.height - 57, 320, 57);
        }];
    }
    
}

- (void)eventActionButton{
    NSLog(@"eventActionButton");
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.user.userId == self.activity.user.userId){
        // edit
        NewActivityViewController *eac = [[NewActivityViewController alloc] init];
        eac.activity = self.activity;
        [self presentViewController:eac animated:YES completion:nil];
    }else if ([self.activity.attendeeIds indexOfObject:[NSNumber numberWithUnsignedInteger:appDelegate.user.userId]] == NSNotFound){
        // attend
        _actionButton.hidden = YES;
//        _loadingIndicator.hidden = NO;
//        [_loadingIndicator startAnimating];
        [self.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _numberOfAssistents.text = [NSString stringWithFormat:@"%u",[self.activity.attendeeIds count]];
                [_actionButton setImage:[UIImage imageNamed:@"fullview_action_yes.png"] forState:UIControlStateNormal];
                //[_grid addSubview:_chatButton];
                
            }
            
//            _loadingIndicator.hidden = YES;
//            [_loadingIndicator stopAnimating];
            _actionButton.hidden = NO;
        }];
    }else{
        // don't attend
        _actionButton.hidden = YES;
//        _loadingIndicator.hidden = NO;
//        [_loadingIndicator startAnimating];
        [self.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _numberOfAssistents.text = [NSString stringWithFormat:@"%u",[self.activity.attendeeIds count]];
                [_actionButton setImage:[UIImage imageNamed:@"fullview_action_go.png"] forState:UIControlStateNormal];
                //[_chatButton removeFromSuperview];
            }
//            _loadingIndicator.hidden = YES;
//            [_loadingIndicator stopAnimating];
            _actionButton.hidden = NO;
        }];
    }
    
}

- (void)backAction{
    NSLog(@"backAction");
    if (_attendeesList != nil) {
        
        [self showAttendees];
        
    }else{
        
        if (_chatIsOpen) {
            
            [self folderAnimation];
            
            [self performSelector:@selector(animationBack) withObject:nil afterDelay:0.8];
            
        }else{
            [self animationBack];
        }
        
    }
    
}

- (void)animationBack{
    NSLog(@"animationBack");
    [self.delegate closeDetailActivity:self];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    UICanuNavigationController *navigation = appDelegate.canuViewController;
    
    navigation.control.hidden = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:0.0];
    
    [UIView animateWithDuration:0.4 animations:^{
        [navigation changePosition:0];
        self.wrapper.frame = CGRectMake(0, _positionY - 10, 320, _wrapper.frame.size.height);
        self.actionButtonImage.alpha = 1;
        self.wrapperMap.frame = CGRectMake(10, 45, 300, 0);
        self.wrapperName.frame = CGRectMake(10, 45, 300, 85);
        self.wrapperDescription.frame = CGRectMake(10, 130, 300, 0);
        self.chatView.frame = CGRectMake(10, 130, 300,0);
        self.chatView.alpha = 0;
        self.touchArea.frame = CGRectMake(0, 0, 0, 0);
        self.wrapperBottomBar.frame = CGRectMake(0, self.view.frame.size.height, 320, 57);
        self.shadow.alpha = 0;
        self.shadow.frame = CGRectMake(0, 85, 300, 4);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)showAttendees{
    NSLog(@"showAttendees");
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
            self.attendeesButton.alpha = 0;
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
            self.attendeesButton.alpha = 1;
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
    NSLog(@"lskdjflsdkjflsdkfjlsdkfj");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"dealloc Detail Activity");
    
}

@end
