//
//  UIProfileView.m
//  CANU
//
//  Created by Roger Calaf on 16/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AFCanuAPIClient.h"
#import "UIProfileView.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@interface UIProfileView ()

@property (nonatomic, readwrite) int height;

@end

@implementation UIProfileView

@synthesize profileImage = _profileImage;
@synthesize mask =  _mask;

@synthesize name = _name;
@synthesize settingsButton = _settingsButton;
@synthesize hideArrow = _hideArrow;


- (id)initWithUser:(User *)user andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.profileHidden = YES;
        
        self.height = frame.origin.y;
        
        self.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 1];
        
        self.mask = [[UIView alloc] init];
        self.mask.alpha = 0;
        self.mask.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeComponents)];
        [self.mask addGestureRecognizer:tap];
        
        self.hideArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bringup_profile_arrow.png"]];
        self.hideArrow.frame = CGRectMake(0.0, -12.0, self.hideArrow.frame.size.width, self.hideArrow.frame.size.height);
        [self addSubview:self.hideArrow];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,user.profileImageUrl]];
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 94.0, 94.0)];
        [self.profileImage  setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        [self addSubview:self.profileImage];
        self.profileImage.userInteractionEnabled = YES;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(118.5f, 21.0f, 160.5f, 18.5)];
        self.name.text = [NSString stringWithFormat:@"%@",user.firstName];
        self.name.font = [UIFont fontWithName:@"Lato-Bold" size:12.0];
        self.name.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [self addSubview:_name];
        
        self.settingsButton  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings.png"]];
        
        self.settingsButton.frame = CGRectMake(275.0f, 15.0f, self.settingsButton.frame.size.width, self.settingsButton.frame.size.height);
        [self addSubview:_settingsButton];
        self.settingsButton.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)hideComponents:(BOOL)hide{
    
    if (hide) {
        self.mask.frame = [[UIScreen mainScreen] bounds];
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0.0f, _height - 114, 320.0f, 114.0f);
            self.mask.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0.0f, _height, 320.0f, 114.0f);
            self.mask.alpha = 0;
        } completion:^(BOOL finished) {
            self.mask.frame = CGRectMake(0, 0, 0, 0);
        }];
    }
    
    self.profileHidden = !hide;
    
}

- (void)closeComponents{
    
    [self hideComponents:NO];
    
}

@end
