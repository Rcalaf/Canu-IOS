//
//  UIProfileView.m
//  CANU
//
//  Created by Roger Calaf on 16/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UIProfileView.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@implementation UIProfileView

@synthesize profileImage = _profileImage;
@synthesize mask =  _mask;

@synthesize name = _name;
@synthesize settingsButton = _settingsButton;
@synthesize hideArrow = _hideArrow;
@synthesize hideTag = _hideTag;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithUser:(User *)user
{
    self = [super initWithFrame:CGRectMake(0.0, 460.0 + KIphone5Margin, 320.0, 114.0)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 1];
        
        self.mask = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.mask.backgroundColor = [UIColor colorWithWhite:255.0f alpha:0.4f];
       // self.mask.hidden = YES;
       
        
        self.hideTag = [[UILabel alloc] initWithFrame:CGRectMake(145.5f, 5.5f, 70.0f, 10.0f)];
        //self.hideTag.backgroundColor = [UIColor redColor];
        self.hideTag.text = @"My Profile";
        self.hideTag.font =[UIFont fontWithName:@"Lato-Regular" size:8.0];
        self.hideTag.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
        [self addSubview:self.hideTag];
        
        self.hideArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bringup_profile_arrow.png"]];
        self.hideArrow.frame = CGRectMake(0.0, -12.0, self.hideArrow.frame.size.width, self.hideArrow.frame.size.height);
        [self addSubview:self.hideArrow];
        
        
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 94.0, 94.0)];
        self.profileImage.image = user.profileImage;
//      [self.profileImage  setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
       
        //self.profileImage.backgroundColor = [UIColor redColor];
        [self addSubview:self.profileImage];
        self.profileImage.userInteractionEnabled = YES;
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(118.5f, 21.0f, 160.5f, 18.5)];
        self.name.text = [NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName];
        self.name.font = [UIFont fontWithName:@"Lato-Bold" size:12.0];
        self.name.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [self addSubview:_name];
        
        self.settingsButton  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings.png"]];
        
        CGRect imageframe = self.settingsButton.frame;
        self.settingsButton.frame = CGRectMake(282.0f, 20.0f, imageframe.size.width, imageframe.size.height);
        [self addSubview:_settingsButton];
        self.settingsButton.userInteractionEnabled = YES;
        [self hideComponents:YES];
        
    }
    return self;
}

- (void)hideComponents:(BOOL)hide{
    if (hide){
        self.hideTag.hidden = NO;
        self.profileImage.hidden = YES;
        self.name.hidden = YES;
        self.settingsButton.hidden = YES;
      //  self.hideArrow.image = [UIImage imageNamed:@"bringup_profile_with_arrow.png"];
    }else{
        self.hideTag.hidden = YES;
        self.profileImage.hidden = NO;
        self.name.hidden = NO;
        self.settingsButton.hidden = NO;
        self.mask.hidden = NO;
        
      //  self.hideArrow.image = [UIImage imageNamed:@"bringup_profile_arrow.png"];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
