//
//  DetailActivityViewControllerAnimate.m
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "DetailActivityViewControllerAnimate.h"

#import "Activity.h"

#import "UIImageView+AFNetworking.h"

#import "ChatScrollView.h"

#import "AFCanuAPIClient.h"
#import <MapKit/MapKit.h>

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@interface DetailActivityViewControllerAnimate ()<MKMapViewDelegate>

@property (strong, nonatomic) Activity *activity;
@property (nonatomic) UIView *wrapper;
@property (nonatomic) UIView *wrapperName;
@property (nonatomic) UIView *wrapperMap;
@property (nonatomic) UIView *wrapperDescription;
@property (nonatomic) UIImageView *actionButton;
@property (nonatomic) ChatScrollView *chatView;
@property (nonatomic) MKMapView *mapView;

@end

@implementation DetailActivityViewControllerAnimate

- (id)initFrame:(CGRect)frame andActivity:(Activity *)activity andPosition:(int)positionY{
    self = [super init];
    if (self) {
        
        self.view.frame = frame;
        
        self.activity = activity;
        
        UITapGestureRecognizer *tapWrapper1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(folderAnimation)];
        UITapGestureRecognizer *tapWrapper2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(folderAnimation)];
        UITapGestureRecognizer *tapWrapper3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(folderAnimation)];
        
        self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, positionY - 10, 320, frame.size.height)];
        [self.view addSubview:_wrapper];
        
        self.chatView = [[ChatScrollView alloc]initWithFrame:CGRectMake(10, 130, 300,0)];
        [self.wrapper addSubview:_chatView];
        
        // User
        
        UIView *wrapperUser = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 166, 34)];
        wrapperUser.backgroundColor = UIColorFromRGB(0xf9f9f9);
        [wrapperUser addGestureRecognizer:tapWrapper1];
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
        [wrapperTime addGestureRecognizer:tapWrapper2];
        [self.wrapper addSubview:wrapperTime];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"d MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 33, 34)];
        day.text = [dateFormatter stringFromDate:self.activity.start];
        day.font = [UIFont fontWithName:@"Lato-Regular" size:10.0];
        day.backgroundColor = UIColorFromRGB(0xf9f9f9);
        day.textColor = UIColorFromRGB(0x6d6e7a);
        [wrapperTime addSubview:day];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        UILabel *timeStart = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 44, 34)];
        timeStart.text = [timeFormatter stringFromDate:self.activity.start];
        timeStart.font = [UIFont fontWithName:@"Lato-Bold" size:11.0];
        timeStart.backgroundColor = UIColorFromRGB(0xf9f9f9);
        timeStart.textColor = UIColorFromRGB(0x6d6e7a);
        [wrapperTime addSubview:timeStart];
        
        UILabel *timeEnd = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 44, 34)];
        timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:self.activity.end]];
        timeEnd.font = [UIFont fontWithName:@"Lato-Italic" size:11.0];
        timeEnd.backgroundColor = UIColorFromRGB(0xf9f9f9);
        timeEnd.textColor = UIColorFromRGB(0x6d6e7a);
        [wrapperTime addSubview:timeEnd];
        
        // Map
        
        self.wrapperMap = [[UIView alloc]initWithFrame:CGRectMake(10, 45, 300, 0)];
        self.wrapperMap.clipsToBounds = YES;
        self.wrapperMap.backgroundColor = [UIColor whiteColor];
        [self.wrapper addSubview:_wrapperMap];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.activity.coordinate, 400, 400);
        
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 10, 280, 140)];
        self.mapView.delegate = self;
        [self.mapView addAnnotation:self.activity.location.placemark];
        self.mapView.region = viewRegion;
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        [self.wrapperMap addSubview:_mapView];
        
        // Description
        
        self.wrapperDescription = [[UIView alloc]initWithFrame:CGRectMake(10, 130, 300, 0)];
        self.wrapperDescription.backgroundColor = [UIColor whiteColor];
        self.wrapperDescription.clipsToBounds = YES;
        [self.wrapper addSubview:_wrapperDescription];
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 268, 40)];
        description.text = self.activity.description;
        description.font = [UIFont fontWithName:@"Lato-Regular" size:12.0];
        description.numberOfLines = 2;
        description.textColor = UIColorFromRGB(0x6d6e7a);
        description.backgroundColor = [UIColor whiteColor];
        [self.wrapperDescription addSubview:description];
        
        // Name
        
        self.wrapperName = [[UIView alloc]initWithFrame:CGRectMake(10, 45, 300, 85)];
        self.wrapperName.backgroundColor = [UIColor whiteColor];
        [self.wrapperName addGestureRecognizer:tapWrapper3];
        [self.wrapper addSubview:_wrapperName];
        
        UILabel *nameActivity = [[UILabel alloc]initWithFrame:CGRectMake(16, 15, 210, 28)];
        nameActivity.font = [UIFont fontWithName:@"Lato-Bold" size:22.0];
        nameActivity.backgroundColor = [UIColor whiteColor];
        nameActivity.textColor = UIColorFromRGB(0x6d6e7a);
        nameActivity.text = _activity.title;
        [_wrapperName addSubview:nameActivity];
        
        UILabel *location = [[UILabel alloc]initWithFrame:CGRectMake(16, 52, 210, 16)];
        location.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
        location.backgroundColor = [UIColor whiteColor];
        location.textColor = UIColorFromRGB(0x6d6e7a);
        location.text = _activity.locationDescription;
        [_wrapperName addSubview:location];
        
        self.actionButton = [[UIImageView alloc]initWithFrame:CGRectMake(243, 19, 47, 47)];
        [self.wrapperName addSubview:_actionButton];
        
        if ( _activity.status == UICanuActivityCellGo ) {
            self.actionButton.image = [UIImage imageNamed:@"feed_action_yes"];
        } else if ( _activity.status == UICanuActivityCellToGo ){
            self.actionButton.image = [UIImage imageNamed:@"feed_action_go.png"];
        } else {
            self.actionButton.image = [UIImage imageNamed:@"feed_action_edit.png"];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            self.wrapper.frame = CGRectMake(0, 0, 320, frame.size.height);
            self.actionButton.alpha = 0;
            self.wrapperMap.frame = CGRectMake(10, 45, 300, 150);
            self.wrapperName.frame = CGRectMake(10, 195, 300, 85);
            self.wrapperDescription.frame = CGRectMake(10, 280, 300, 60);
            self.chatView.frame = CGRectMake(10, 340, 300, frame.size.height - 340 - 57);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    return self;
}

- (void)folderAnimation{
    
    NSLog(@"Touch");
    
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
