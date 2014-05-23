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
#import "Contact.h"

#import "ProfilePicture.h"

@interface UICanuAttendeeCellScroll ()

@property (nonatomic) User *user;

@end

@implementation UICanuAttendeeCellScroll

- (id)initWithFrame:(CGRect)frame andUser:(User *)user orContact:(Contact *)contact{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.user = user;
        
        self.tribeMode = NO;
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 55)];
        background.image = [UIImage imageNamed:@"F_location_cell"];
        [self addSubview:background];
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
        avatar.image = [ProfilePicture defaultProfilePicture35];
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        avatar.clipsToBounds = YES;
        [self addSubview:avatar];
        
        UIImageView *strokePicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        strokePicture.image = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
        [avatar addSubview:strokePicture];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(55, 9, 233, 20)];
        name.font = [UIFont fontWithName:@"Lato-Bold" size:14];
        name.textColor = UIColorFromRGB(0x2b4b58);
        name.text = contact.fullName;
        [self addSubview:name];
        
        UILabel *adress = [[UILabel alloc]initWithFrame:CGRectMake(55, 31, 233, 11)];
        adress.font = [UIFont fontWithName:@"Lato-Italic" size:10];
        adress.textColor = UIColorFromRGB(0x2b4b58);
        adress.text = contact.convertNumber;
        [self addSubview:adress];
        
        if (user) {
            self.user = user;
            if (![user.firstName mk_isEmpty]) {
                name.text = user.firstName;
            } else if (!contact){
                [adress removeFromSuperview];
                adress = nil;
                name.text = user.userName;
                name.frame = CGRectMake(55, 17, 233, 20);
            }
            adress.text = user.userName;
            [avatar setImageWithURL:user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
        } else {
            if (contact.profilePicture) {
                avatar.image = contact.profilePicture;
            }
        }
    
    }
    return self;
}

- (void)setTribeMode:(BOOL)tribeMode{
    
    _tribeMode = tribeMode;
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(300 - 45 - 5, 5, 45, 45)];
    [deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
//    [deleteButton addTarget:self action:@selector(deleteActivity) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setImage:[UIImage imageNamed:@"F_delete"] forState:UIControlStateNormal];
    [self addSubview:deleteButton];
    
}

@end
