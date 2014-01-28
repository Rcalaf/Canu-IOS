//
//  UICanuAttendeeCellScroll.m
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuAttendeeCellScroll.h"

#import "AFCanuAPIClient.h"
#import "UIImageView+AFNetworking.h"

#import "User.h"

@interface UICanuAttendeeCellScroll ()

@property (nonatomic) User *user;

@end

@implementation UICanuAttendeeCellScroll

- (id)initWithFrame:(CGRect)frame andUser:(User *)user{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.user = user;
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 37, 37)];
        [avatar setImageWithURL:_user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        [self addSubview:avatar];
        
        UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(57, 12, 200, 15)];
        username.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
        username.backgroundColor = [UIColor whiteColor];
        username.textColor = UIColorFromRGB(0x1a8d9e);
        username.text = [NSString stringWithFormat:@"%@ %@",_user.firstName,_user.lastName];
        [self addSubview:username];
        
        UILabel *nickname = [[UILabel alloc]initWithFrame:CGRectMake(57, 34, 200, 10)];
        nickname.font = [UIFont fontWithName:@"Lato-Bold" size:8.0];
        nickname.backgroundColor = [UIColor whiteColor];
        nickname.textColor = UIColorFromRGB(0x6d6e7a);
        nickname.text = _user.userName;
        [self addSubview:nickname];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openProfileView)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)openProfileView{
    
    [self.delegate attendeeCellEventProfileView:_user];
    
}

@end
