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
#import "AppDelegate.h"
#import "UICanuNavigationController.h"
#import "UserSettingsViewController.h"
#import "UserManager.h"
#import "ProfilePicture.h"
#import <QuartzCore/QuartzCore.h>

@class ActivitiesFeedViewController;

@interface UIProfileView () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) UIImageView *settingsButton;
@property (strong, nonatomic) UILabel *pseudo;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UICanuNavigationController *navigation;

@end

@implementation UIProfileView


- (id)initWithFrame:(CGRect)frame User:(User *)user{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        AppDelegate *appDelegate                   = [[UIApplication sharedApplication]delegate];

        self.profileImage                          = [[UIImageView alloc] initWithFrame:CGRectMake(113, 10, 95, 95)];
        [self.profileImage setImageWithURL:user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture95]];
        self.profileImage.userInteractionEnabled   = YES;
        self.profileImage.clipsToBounds            = YES;
        [self setRoundedView:_profileImage];
        [self addSubview:self.profileImage];

        UIImageView *strokeProfile                 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 95, 95)];
        strokeProfile.image                        = [UIImage imageNamed:@"All_stroke_profile_picture_95"];
        [self.profileImage addSubview:strokeProfile];

        self.pseudo                                = [[UILabel alloc] initWithFrame:CGRectMake((320 - 160)/2, 110, 160, 18)];
        self.pseudo.text                           = user.userName;
        self.pseudo.textAlignment                  = NSTextAlignmentCenter;
        self.pseudo.font                           = [UIFont fontWithName:@"Lato-Bold" size:14.0];
        self.pseudo.textColor                      = [UIColor whiteColor];
        self.pseudo.backgroundColor                = [UIColor clearColor];
        [self addSubview:_pseudo];

        self.name                                  = [[UILabel alloc]initWithFrame:CGRectMake((320 - 160)/2, 135, 160, 12)];
        self.name.backgroundColor                  = [UIColor clearColor];
        self.name.textAlignment                    = NSTextAlignmentCenter;
        self.name.textColor                        = [UIColor whiteColor];
        self.name.alpha                            = 0.3;
        self.name.font                             = [UIFont fontWithName:@"Lato-Regular" size:10.0];
        self.name.text                             = user.firstName;
        [self addSubview:_name];
        
        if (!user.firstName) {
            
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Add name", nil)];
            [attributeString addAttribute:NSUnderlineStyleAttributeName
                                    value:[NSNumber numberWithInt:1]
                                    range:(NSRange){0,[attributeString length]}];
            
            self.name.attributedText = attributeString;
            
            UITapGestureRecognizer *tapRecognizerName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings)];
            [self.name addGestureRecognizer:tapRecognizerName];
            
        }

        self.navigation                            = appDelegate.canuViewController;

        self.settingsButton                        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_settings"]];
        self.settingsButton.frame                  = CGRectMake(0, -10, 57, 57);
        self.settingsButton.userInteractionEnabled = YES;
        [self addSubview:_settingsButton];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings)];
        [self.settingsButton addGestureRecognizer:tapRecognizer];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic)];
        [self.profileImage addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

- (void)animationProfileViewWithScroll:(float)offset{
    
    float value = fabsf(offset) / 2;
    
    self.settingsButton.frame = CGRectMake(0, -10 + value * 0.2f, 57, 57);
    self.profileImage.frame = CGRectMake(113, 10 + value * 0.6f, 95, 95);
    self.pseudo.frame = CGRectMake((320 - 160)/2, 110 + value * 0.8f, 160, 18);
    self.name.frame = CGRectMake((320 - 160)/2, 135 + value * 0.85f, 160, 12);
    
}

- (void)forEmptyFeed:(BOOL)isEmptyFeed{
    
    if (isEmptyFeed) {
        self.name.textColor = [UIColor whiteColor];
        self.pseudo.textColor = [UIColor whiteColor];
    } else {
        self.name.textColor = UIColorFromRGB(0x2b4b58);
        self.pseudo.textColor = UIColorFromRGB(0x2b4b58);
    }
    
}

- (void)showSettings{
    
    UserSettingsViewController *us = [[UserSettingsViewController alloc] init];
    
    UIViewController *viewController = (UIViewController *)self.navigation.activityFeed;
    [viewController presentViewController:us animated:YES completion:nil];
    
}

- (void)takePic{
    
    UIViewController *viewController = (UIViewController *)self.navigation.activityFeed;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose an existing one",@"Take a picture", nil];
    [actionSheet showInView:viewController.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIViewController *viewController = (UIViewController *)self.navigation.activityFeed;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [viewController presentViewController:imagePicker animated:YES completion:nil];
    } else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [viewController presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIViewController *viewController = (UIViewController *)self.navigation.activityFeed;
    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [[[UserManager sharedUserManager] currentUser] editUserProfilePicture:newImage Block:^(User *user, NSError *error) {
        if (!error) {
            self.profileImage.image = newImage;
            [[UserManager sharedUserManager] updateUser:user];
        }
    }];
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    UIViewController *viewController = (UIViewController *)self.navigation.activityFeed;
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

-(void)setRoundedView:(UIImageView *)roundedView{
    
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, roundedView.frame.size.width, roundedView.frame.size.width);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = roundedView.frame.size.width / 2.0;
    roundedView.center = saveCenter;
    
}

- (void)dealloc{
    
    NSLog(@"Dealloc ProfileView");
    
}

@end
