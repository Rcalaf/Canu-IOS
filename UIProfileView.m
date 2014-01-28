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

@property (nonatomic) BOOL isNavigationChangement;
@property (nonatomic) BOOL isBottomBar;
@property (nonatomic) CGRect rect;
@property (strong, nonatomic) UIView *mask;
@property (strong, nonatomic) UIView *wrapper;
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) UIImageView *settingsButton;
@property (strong, nonatomic) UICanuNavigationController *navigation;

@end

@implementation UIProfileView


- (id)initWithUser:(User *)user WithBottomBar:(BOOL)bottomBar AndNavigationchangement:(BOOL)navigationChangement{
    
    CGRect rectZero = CGRectMake(0, 0, 0, 0);
    
    self = [super initWithFrame:rectZero];
    if (self) {
        
        self.clipsToBounds          = YES;
        
        AppDelegate *appDelegate    = [[UIApplication sharedApplication]delegate];
        
        CGSize result               = [[UIScreen mainScreen] bounds].size;

        self.rect                   = CGRectMake(0, 0, result.width, result.height);

        BOOL isCurrentUser          = YES;
        self.isBottomBar            = bottomBar;
        self.isNavigationChangement = navigationChangement;
        
        if (appDelegate.user.userId != user.userId) {
            isCurrentUser           = NO;
        }

        self.profileHidden          = YES;
        
        self.mask                   = [[UIView alloc] init];
        self.mask.alpha             = 0;
        self.mask.backgroundColor   = [UIColor colorWithRed:(241.0 / 255.0) green:(245.0 / 255.0) blue:(245.0 / 255.0) alpha: 0.8f];
        [self addSubview:_mask];

        self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(0, _rect.size.height, result.width, 119 + 57)];
        self.wrapper.backgroundColor = [UIColor whiteColor];
        [self addSubview:_wrapper];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeComponents)];
        [self.mask addGestureRecognizer:tap];

        UIImageView *shadow         = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_profile_shadow"]];
        shadow.frame                = CGRectMake(0, - 4, 320, 4);
        [self.wrapper addSubview:shadow];

        self.profileImage                        = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 109, 109)];
        [self.profileImage setImageWithURL:user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username"]];
        self.profileImage.userInteractionEnabled = YES;
        [self.wrapper addSubview:self.profileImage];

        if (isCurrentUser) {
            
            UIImageView *editImage               = [[UIImageView alloc]initWithFrame:CGRectMake(109 - 16, 109 - 16, 14, 14)];
            editImage.image                      = [UIImage imageNamed:@"User_image_edit"];
            [self.profileImage addSubview:editImage];
            
        }
        
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
        
        if (_isBottomBar) {
            
            self.navigation = appDelegate.canuViewController;
            
            UIView *bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, 119, 320, 57)];
            bottomBar.backgroundColor = UIColorFromRGB(0xf9f9f9);
            [self.wrapper addSubview:bottomBar];
            
            UIView *lineBottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, -1, 320, 1)];
            lineBottomBar.backgroundColor = UIColorFromRGB(0xd4e0e0);
            [bottomBar addSubview:lineBottomBar];
            
            UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, 57)];
            [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
            [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateHighlighted];
            [backButton addTarget:self action:@selector(closeComponents) forControlEvents:UIControlEventTouchDown];
            [bottomBar addSubview:backButton];
            
        }
        
        if (isCurrentUser) {
            
            self.settingsButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"User_settings"]];
            self.settingsButton.frame = CGRectMake(258, 0, 57, 57);
            self.settingsButton.userInteractionEnabled = YES;
            [self.wrapper addSubview:_settingsButton];
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings)];
            [self.settingsButton addGestureRecognizer:tapRecognizer];
            
            tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic)];
            [self.profileImage addGestureRecognizer:tapRecognizer];
            
        }
        
    }
    return self;
}

- (void)hideComponents:(BOOL)hide{
    
    if (hide) {
        self.mask.frame = [[UIScreen mainScreen] bounds];
        self.frame = [[UIScreen mainScreen] bounds];
        [UIView animateWithDuration:0.3 animations:^{
            if (!_isBottomBar) {
                self.wrapper.frame = CGRectMake(0, _rect.size.height - 119, 320, 119 + 57);
            } else {
                self.wrapper.frame = CGRectMake(0, _rect.size.height - 119 - 57, 320, 119 + 57);
                [self.navigation changePosition:1];
            }
            self.mask.alpha = 1;
        } completion:^(BOOL finished) {
            if (_isNavigationChangement) {
                self.navigation.control.hidden = YES;
            }
        }];
    }else{
        if (_isNavigationChangement) {
            self.navigation.control.hidden = NO;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.frame = CGRectMake(0, _rect.size.height, 320, 119 + 57);
            self.mask.alpha = 0;
            if (_isNavigationChangement) {
                [self.navigation changePosition:0];
            }
        } completion:^(BOOL finished) {
            self.mask.frame = CGRectMake(0, 0, 0, 0);
            self.frame = CGRectMake(0, 0, 0, 0);
        }];
    }
    
    self.profileHidden = !hide;
    
}

- (void)closeComponents{
    NSLog(@"closeComponents");
    [self hideComponents:NO];
    
    if (_isBottomBar) {
        [self performSelector:@selector(deleteView) withObject:nil afterDelay:0.3];
    }
    
}

- (void)deleteView{
    NSLog(@"Delete");
    [self removeFromSuperview];
    
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
        NSLog(@"Top");
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
