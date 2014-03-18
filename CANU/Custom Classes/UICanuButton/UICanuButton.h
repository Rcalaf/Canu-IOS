//
//  UICanuButton.h
//  CANU
//
//  Created by Vivien Cormier on 18/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UICanuButtonStyle) {
    UICanuButtonStyleNormal = 0
};

@interface UICanuButton : UIButton

- (id)initWithFrame:(CGRect)frame forStyle:(UICanuButtonStyle)canuButtonStyle;

@end
