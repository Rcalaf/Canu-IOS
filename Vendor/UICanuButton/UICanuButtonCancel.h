//
//  UICanuButtonCancel.h
//  CANU
//
//  Created by Vivien Cormier on 19/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuButtonCancel : UIButton

@property (nonatomic) int maxWidth;

- (void)detectSize;

@end
