//
//  SignUpStep2.m
//  CANU
//
//  Created by Vivien Cormier on 15/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "SignUpStep2.h"

#import "UICanuTextField.h"
#import "TTTAttributedLabel.h"
#import "SignUpViewController.h"

@interface SignUpStep2 () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic) SignUpViewController *parentViewController;

@end

@implementation SignUpStep2

- (id)initWithFrame:(CGRect)frame AndParentViewController:(SignUpViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.parentViewController = parentViewController;
        
        UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        title2.text = NSLocalizedString(@"Your Profile", nil);
        title2.textAlignment = NSTextAlignmentCenter;
        title2.backgroundColor = [UIColor clearColor];
        title2.textColor = UIColorFromRGB(0x1ca6c3);
        title2.font = [UIFont fontWithName:@"Lato-Bold" size:24];
        [self addSubview:title2];
        
        TTTAttributedLabel *termsAmdPrivacy = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 50, 320, 20)];
        termsAmdPrivacy.text = NSLocalizedString(@"Grab my Facebook info", nil);
        termsAmdPrivacy.textColor = UIColorFromRGB(0x1ca6c3);
        termsAmdPrivacy.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        termsAmdPrivacy.textAlignment = NSTextAlignmentCenter;
        termsAmdPrivacy.backgroundColor = [UIColor clearColor];
        [self addSubview:termsAmdPrivacy];
        
        [termsAmdPrivacy setText:termsAmdPrivacy.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange termsRange = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"Grab my Facebook info", nil) options:NSCaseInsensitiveSearch];
            
            [mutableAttributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:termsRange];
            
            return mutableAttributedString;
            
        }];
        
        self.takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.takePictureButton setFrame:CGRectMake(10, 80, 94.5, 94.5)];
        [self.takePictureButton setImage:[UIImage imageNamed:@"icon_userpic"] forState:UIControlStateNormal];
        [self.takePictureButton addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_takePictureButton];
        
        self.name = [[UICanuTextField alloc] initWithFrame:CGRectMake(105, 80, 205, 47.0)];
        self.name.placeholder = NSLocalizedString(@"Full name", nil);
        [self.name setReturnKeyType:UIReturnKeyNext];
        self.name.delegate = self;
        [self addSubview:self.name];
        
        self.email = [[UICanuTextField alloc] initWithFrame:CGRectMake(105, 128, 205, 47.0)];
        self.email.placeholder = NSLocalizedString(@"E-mail", nil);
        self.email.delegate = self;
        self.email.keyboardType = UIKeyboardTypeEmailAddress;
        [self.email setReturnKeyType:UIReturnKeyGo];
        [self addSubview:self.email];
        
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _name) {
        [self.name resignFirstResponder];
        [self.email becomeFirstResponder];
    }else if (textField == _email){
        [self.delegate signUpUser];
    }
    
    return YES;
    
}

- (void)takePic:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Choose an existing one",nil),NSLocalizedString(@"Take a picture",nil), nil];
    [actionSheet showInView:self];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.parentViewController presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"Done");
        }];
    } else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self.parentViewController presentViewController:imagePicker animated:YES completion:^{
                NSLog(@"Done");
            }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [_takePictureButton setImage:[info valueForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
