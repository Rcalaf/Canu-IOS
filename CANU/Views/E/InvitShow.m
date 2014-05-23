//
//  InvitShow.m
//  CANU
//
//  Created by Vivien Cormier on 20/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "InvitShow.h"

#import "Activity.h"
#import "UIImageView+AFNetworking.h"
#import "ProfilePicture.h"
#import "User.h"

@interface InvitShow ()

@property (strong, nonatomic) UILabel *text;
@property (strong, nonatomic) NSArray *attendees;
@property (strong, nonatomic) NSArray *invitationUser;
@property (strong, nonatomic) NSArray *invitationGhostuser;
@property (strong, nonatomic) NSMutableArray *profilsPictures;

@end

@implementation InvitShow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 280, 12)];
        self.text.textColor = UIColorFromRGB(0x829096);
        self.text.textAlignment = NSTextAlignmentCenter;
        self.text.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        [self addSubview:_text];
        
        self.profilsPictures = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)setActivity:(Activity *)activity{
    
    _activity = activity;
    
    [self.activity attendees:^(NSArray *attendees, NSArray *invitationUser, NSArray *invitationGhostuser, NSError *error) {
        
        if (error) {
            
        } else {
            
            _attendees = attendees;
            _invitationUser = invitationUser;
            _invitationGhostuser = invitationGhostuser;
            
            [self showInvits];
            
        }
        
    }];
    
}

- (void)showInvits{
    
    for (int i = 0; i < [self.profilsPictures count]; i++) {
        
        UIImageView *profilePicture = [self.profilsPictures objectAtIndex:i];
        [profilePicture removeFromSuperview];
        profilePicture = nil;
        
    }
    
    [self.profilsPictures removeAllObjects];
    
    NSString *text = @"";
    
    NSInteger numberPeople = 0;
    
    for (int i = 0; i < [self.attendees count]; i++) {
        
        User *user = [self.attendees objectAtIndex:i];
        
        if (user.userId != self.activity.user.userId) {
            if (numberPeople < 7) {
                
                if (numberPeople < 2) {
                    
                    NSString *name = @"";
                    
                    if ([user.firstName mk_isEmpty]) {
                        name = user.userName;
                    } else {
                        name = user.firstName;
                    }
                    
                    if (numberPeople == 0) {
                        text = name;
                    } else {
                        text = [NSString stringWithFormat:@"%@, %@",text,name];
                    }
                    
                }
                
                UIImageView *profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10 + numberPeople * ( 6 + 35), 10, 35, 35)];
                profilePicture.alpha = 1;
                [profilePicture setImageWithURL:user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
                [self addSubview:profilePicture];
                
                UIImageView *strokePicture            = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
                strokePicture.image                   = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
                [profilePicture addSubview:strokePicture];
                
                [self.profilsPictures addObject:profilePicture];
                
                numberPeople++;
                
            } else {
                return;
            }
        }
    
    }
    
    for (int i = 0; i < [self.invitationUser count]; i++) {
        
        User *user = [self.invitationUser objectAtIndex:i];
        
        if (numberPeople < 7) {
            
            if (numberPeople < 2) {
                
                NSString *name = @"";
                
                if ([user.firstName mk_isEmpty]) {
                    name = user.userName;
                } else {
                    name = user.firstName;
                }
                
                if (numberPeople == 0) {
                    text = name;
                } else {
                    text = [NSString stringWithFormat:@"%@, %@",text,name];
                }
                
            }
            
            UIImageView *profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10 + numberPeople * ( 6 + 35), 10, 35, 35)];
            profilePicture.alpha = 0.3;
            [profilePicture setImageWithURL:user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
            [self addSubview:profilePicture];
            
            UIImageView *strokePicture            = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            strokePicture.image                   = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
            [profilePicture addSubview:strokePicture];
            
            [self.profilsPictures addObject:profilePicture];
            
            numberPeople++;
            
        } else {
            return;
        }
        
    }
    
    if (numberPeople != 0) {
        
        NSInteger restPeople = 0;
        
        if (numberPeople <= 2) {
            restPeople = [self.invitationGhostuser count];
        } else {
            restPeople = numberPeople - 2 + [self.invitationGhostuser count];
        }
        
        NSString *inviteWord = NSLocalizedString(@"are invited", nil);
        
        if (numberPeople + [self.invitationGhostuser count] <= 1) {
            inviteWord = NSLocalizedString(@"is invited", nil);
        }
        
        if (restPeople == 0) {
            text = [NSString stringWithFormat:@"%@ %@",text,inviteWord];
        } else {
            
            NSString *otherWord = NSLocalizedString(@"others", nil);
            
            if ([self.invitationGhostuser count] > 1) {
                otherWord = NSLocalizedString(@"other", nil);
            }
            
            text = [NSString stringWithFormat:@"%@ %@ %u %@ %@",text,NSLocalizedString(@"and", nil),restPeople,otherWord,inviteWord];
        }
        
    } else {
        
        if ([self.invitationGhostuser count] == 0) {
            text = NSLocalizedString(@"No people invited yet", nil);
        } else if ([self.invitationGhostuser count] == 0) {
            text = [NSString stringWithFormat:@"1 %@ %@",NSLocalizedString(@"people", nil),NSLocalizedString(@"is invited", nil)];
        } else {
            text = [NSString stringWithFormat:@"%u %@ %@",[self.invitationGhostuser count],NSLocalizedString(@"people", nil),NSLocalizedString(@"are invited", nil)];
        }
        
    }
    
    for (int i = 0; i < [self.invitationGhostuser count]; i++) {
        
        if (numberPeople < 7) {
            
            UIImageView *profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10 + numberPeople * ( 6 + 35), 10, 35, 35)];
            profilePicture.alpha = 0.3;
            profilePicture.image = [ProfilePicture defaultProfilePicture35];
            [self addSubview:profilePicture];
            
            UIImageView *strokePicture            = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            strokePicture.image                   = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
            [profilePicture addSubview:strokePicture];
            
            [self.profilsPictures addObject:profilePicture];
            
            numberPeople++;
            
        } else {
            return;
        }
        
    }
    
    if (numberPeople < 5) {
        for (int i = numberPeople; i < 5; i++) {
            
            UIImageView *profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10 + numberPeople * ( 6 + 35), 10, 35, 35)];
            profilePicture.backgroundColor = UIColorFromRGB(0xf1f5f5);
            [self addSubview:profilePicture];
            
            UIImageView *strokePicture            = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            strokePicture.image                   = [UIImage imageNamed:@"All_stroke_profile_picture_35_without_stroke"];
            [profilePicture addSubview:strokePicture];
            
            [self.profilsPictures addObject:profilePicture];
            
            numberPeople++;
            
        }
    }
    
    self.text.text = text;
    
}

@end
