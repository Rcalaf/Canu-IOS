//
//  UICanuButton.h
//  CANU
//
//  Created by Vivien Cormier on 18/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UICanuButtonStyle) {
    UICanuButtonStyleNormal = 0,
    UICanuButtonStyleLarge = 1,
    UICanuButtonStyleWhite = 2,
    UICanuButtonStyleWhiteArrow = 3
};

typedef NS_ENUM(NSInteger, UICanuButtonStatus) {
    UICanuButtonStatusNormal = 0,
    UICanuButtonStatusDisable = 1,
};

@interface UICanuButton : UIButton

@property (nonatomic) UICanuButtonStatus buttonStatus;

- (id)initWithFrame:(CGRect)frame forStyle:(UICanuButtonStyle)canuButtonStyle;

@end
