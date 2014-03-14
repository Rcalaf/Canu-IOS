//
//  TutorialStepFinal.h
//  CANU
//
//  Created by Vivien Cormier on 22/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialStepFinal : UIView

@property (retain) id delegate;

@end

@protocol TutorialStepFinalDelegate <NSObject>

@required
- (void)tutorialStepFinalEnd;
@end
