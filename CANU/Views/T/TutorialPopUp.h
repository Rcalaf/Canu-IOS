//
//  TutorialPopUp.h
//  CANU
//
//  Created by Vivien Cormier on 23/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UICanuNavigationController.h"

@interface TutorialPopUp : UIView

@property (retain) id delegate;

- (void)changeToCreate;

- (void)popUpGoToPosition:(TutorialStep)step;

@end

@protocol TutorialPopUpDelegate <NSObject>

@required

- (void)nextStep;

@end