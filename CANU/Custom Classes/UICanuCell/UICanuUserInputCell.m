//
//  UICanuUserInputCell.m
//  CANU
//
//  Created by Vivien Cormier on 20/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuUserInputCell.h"
#import "Contact.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ProfilePicture.h"

@interface UICanuUserInputCell ()

@property (strong, nonatomic) UIImageView *selectedImage;

@end

@implementation UICanuUserInputCell

- (id)initWithFrame:(CGRect)frame WithContact:(Contact *)contact AndUser:(User *)user{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.user = user;
        self.contact = contact;
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        avatar.image = [ProfilePicture defaultProfilePicture35];
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        avatar.clipsToBounds = YES;
        [self addSubview:avatar];
        
        UIImageView *strokePicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        strokePicture.image = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
        [avatar addSubview:strokePicture];
        
        if (user) {
            [avatar setImageWithURL:user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
        } else {
            if (contact.profilePicture) {
                avatar.image = contact.profilePicture;
            }
        }
        
        self.selectedImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        self.selectedImage.image = [UIImage imageNamed:@"All_stroke_profile_picture_35_selected"];
        self.selectedImage.alpha = 0;
        [self addSubview:_selectedImage];
        
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    
    _isSelected = isSelected;
    
    if (isSelected) {
        self.selectedImage.alpha = 1;
    } else {
        self.selectedImage.alpha = 0;
    }
    
}

@end
