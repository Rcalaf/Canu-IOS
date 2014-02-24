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

@implementation UICanuContactCell

- (id)initWithFrame:(CGRect)frame WithContact:(Contact *)contact AndUser:(User *)user{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.contact = contact;
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 37, 37)];
        avatar.image = [UIImage imageNamed:@"icon_username.png"];
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        avatar.clipsToBounds = YES;
        [self addSubview:avatar];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(47, 6, 186, 20)];
        name.font = [UIFont fontWithName:@"Lato-Bold" size:13];
        name.textColor = UIColorFromRGB(0x1a8d9e);
        name.text = contact.fullName;
        [self addSubview:name];
        
        UILabel *adress = [[UILabel alloc]initWithFrame:CGRectMake(47, 26, 186, 10)];
        adress.font = [UIFont fontWithName:@"Lato-Regular" size:8];
        adress.textColor = UIColorFromRGB(0x2b4b58);
        adress.text = contact.convertNumber;
        [self addSubview:adress];
        
        if (user) {
            self.user = user;
            name.text = user.firstName;
            adress.text = user.userName;
            [avatar setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        } else {
            if (contact.profilePicture) {
                avatar.image = contact.profilePicture;
            }
        }
        
        self.square = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 28 - 10, (frame.size.height - 27)/2, 28, 27)];
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
