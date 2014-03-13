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

@class ActivitiesFeedViewController;

@interface UIProfileView () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UIView *wrapper;
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) UIImageView *settingsButton;
@property (strong, nonatomic) UICanuNavigationController *navigation;

@end

@implementation UIProfileView


- (id)initWithFrame:(CGRect)frame User:(User *)user{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        AppDelegate *appDelegate    = [[UIApplication sharedApplication]delegate];
        
        self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        self.wrapper.backgroundColor = [UIColor whiteColor];
        [self addSubview:_wrapper];

        UIImageView *shadow         = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_profile_shadow"]];
        shadow.frame                = CGRectMake(0, - 4, 320, 4);
        [self.wrapper addSubview:shadow];

        self.profileImage                        = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 109, 109)];
        [self.profileImage setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username"]];
        self.profileImage.userInteractionEnabled = YES;
        [self.wrapper addSubview:self.profileImage];

        UIImageView *editImage               = [[UIImageView alloc]initWithFrame:CGRectMake(109 - 16, 109 - 16, 14, 14)];
        editImage.image                      = [UIImage imageNamed:@"User_image_edit"];
        [self.profileImage addSubview:editImage];
        
        UILabel *name          = [[UILabel alloc] initWithFrame:CGRectMake(129, 21, 160, 18)];
        name.text              = user.firstName;
        name.font              = [UIFont fontWithName:@"Lato-Bold" size:16.0];
        name.textColor         = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [self.wrapper addSubview:name];

        UILabel *pseudo        = [[UILabel alloc]initWithFrame:CGRectMake(129, 45, 160, 12)];
        pseudo.backgroundColor = [UIColor whiteColor];
        pseudo.textColor       = UIColorFromRGB(0x2b4b58);
        pseudo.font            = [UIFont fontWithName:@"Lato-Bold" size:10.0];
        pseudo.text            = user.userName;
        [self.wrapper addSubview:pseudo];
        
        self.navigation = appDelegate.canuViewController;
        
        self.settingsButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_settings"]];
        self.settingsButton.frame = CGRectMake(258, 0, 57, 57);
        self.settingsButton.userInteractionEnabled = YES;
        [self.wrapper addSubview:_settingsButton];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings)];
        [self.settingsButton addGestureRecognizer:tapRecognizer];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic)];
        [self.profileImage addGestureRecognizer:tapRecognizer];
        
    }
    return self;
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController *viewController = (UIViewController *)self.navigation.activityFeed;
    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [appDelegate.user editUserProfilePicture:newImage Block:^(User *user, NSError *error) {
        if (!error) {
            self.profileImage.image = newImage;
            [[NSUserDefaults standardUserDefaults] setObject:[user serialize] forKey:@"user"];
            appDelegate.user = nil;
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

- (void)dealloc{
    
    NSLog(@"Dealloc ProfileView");
    
}

@end
