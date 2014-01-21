//
//  TutorialStepStart.h
//  CANU
//
//  Created by Vivien Cormier on 21/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialStepStart : UIView

@property (retain) id delegate;

@end

@protocol TutorialStepStartDelegate <NSObject>

@required
- (void)tutorialStepStartNext;
@end