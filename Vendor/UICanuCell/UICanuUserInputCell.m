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

@implementation UICanuUserInputCell

- (id)initWithFrame:(CGRect)frame WithContact:(Contact *)contact AndUser:(User *)user{
    
    self = [super initWithFrame:frame];
    if (self) {
        
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
        
    }
    return self;
}

@end
