//
//  UICanuContactCell.m
//  CANU
//
//  Created by Vivien Cormier on 20/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuContactCell.h"
#import "Contact.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ProfilePicture.h"

@implementation UICanuContactCell

- (id)initWithFrame:(CGRect)frame WithContact:(Contact *)contact AndUser:(User *)user{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 55)];
        background.image = [UIImage imageNamed:@"F_location_cell"];
        [self addSubview:background];
        
        self.contact = contact;
        
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
            name.text = user.firstName;
            adress.text = user.userName;
            [avatar setImageWithURL:user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
        } else {
            if (contact.profilePicture) {
                avatar.image = contact.profilePicture;
            }
        }
        
        self.square = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 28 - 15, (frame.size.height - 27)/2, 28, 27)];
        self.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location"];
        [self addSubview:_square];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellIsTouched)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)cellIsTouched{
    
    [self.delegate cellLocationIsTouched:self];
    
}

@end
