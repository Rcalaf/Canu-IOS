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


- (id)initWithUser:(User *)user andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.profileHidden = YES;
        
        self.height = frame.origin.y;
        
        self.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 1];
        
        self.mask = [[UIView alloc] init];
        self.mask.alpha = 0;
        self.mask.backgroundColor = [UIColor colorWithRed:(241.0 / 255.0) green:(245.0 / 255.0) blue:(245.0 / 255.0) alpha: 0.8f];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeComponents)];
        [self.mask addGestureRecognizer:tap];
        
        UIImageView *hideArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_profile_shadow"]];
        hideArrow.frame = CGRectMake(0, - 4, 320, 4);
        [self addSubview:hideArrow];
        
        self.profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 109, 109)];
        [self.profileImage  setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username"]];
        self.profileImage.userInteractionEnabled = YES;
        [self addSubview:self.profileImage];
        
        UIImageView *editImage = [[UIImageView alloc]initWithFrame:CGRectMake(109 - 16, 109 - 16, 14, 14)];
        editImage.image = [UIImage imageNamed:@"User_image_edit"];
        [self.profileImage addSubview:editImage];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(129, 21, 160, 18)];
        name.text = user.firstName;
        name.font = [UIFont fontWithName:@"Lato-Bold" size:16.0];
        name.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [self addSubview:name];
        
        UILabel *pseudo = [[UILabel alloc]initWithFrame:CGRectMake(129, 45, 160, 12)];
        pseudo.backgroundColor = [UIColor whiteColor];
        pseudo.textColor = UIColorFromRGB(0x2b4b58);
        pseudo.font = [UIFont fontWithName:@"Lato-Bold" size:10.0];
        pseudo.text = user.userName;
        [self addSubview:pseudo];
        
        self.settingsButton  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_settings"]];
        self.settingsButton.frame = CGRectMake(258, 0, 57, 57);
        self.settingsButton.userInteractionEnabled = YES;
        [self addSubview:_settingsButton];
        
    }
    return self;
}

- (void)hideComponents:(BOOL)hide{
    
    if (hide) {
        self.mask.frame = [[UIScreen mainScreen] bounds];
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, _height - 119, 320, 119);
            self.mask.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, _height, 320, 119);
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
