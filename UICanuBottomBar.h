//
//  UICanuBottomBar.h
//  CANU
//
//  Created by Roger Calaf on 16/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UICanuBottomBarDelegate

@end

@interface UICanuBottomBar : UIView

@property (weak) id <UICanuBottomBarDelegate> delegate;
@property (strong, nonatomic) UIButton *backButton;

@end
