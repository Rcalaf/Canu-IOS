//
//  SignUpViewController.h
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

- (IBAction)authButtonAction:(id)sender;
- (IBAction)performSingUp:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)takePic:(id)sender;

@end
