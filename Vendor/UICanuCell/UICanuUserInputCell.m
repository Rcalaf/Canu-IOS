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

@interface UICanuUserInputCell ()

@property (strong, nonatomic) UIImageView *selectedImage;

@end

@implementation UICanuUserInputCell

- (id)initWithFrame:(CGRect)frame WithContact:(Contact *)contact AndUser:(User *)user{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.user = user;
        self.contact = contact;
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 47, 47)];
        avatar.image = [UIImage imageNamed:@"icon_username.png"];
        avatar.contentMode = UIViewContentModeScaleAspectFill;
        avatar.clipsToBounds = YES;
        [self addSubview:avatar];
        
        if (user) {
            [avatar setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        } else {
            if (contact.profilePicture) {
                avatar.image = contact.profilePicture;
            }
        }
        
        self.selectedImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 47, 47)];
        self.selectedImage.image = [UIImage imageNamed:@"F5_inputCell_selected"];
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
