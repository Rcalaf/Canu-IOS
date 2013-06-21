//
//  NewActivityViewController.h
//  CANU
//
//  Created by Roger Calaf on 04/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewActivityViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

- (IBAction)createActivity:(id)sender;
- (IBAction)goBack:(id)sender;


@end



