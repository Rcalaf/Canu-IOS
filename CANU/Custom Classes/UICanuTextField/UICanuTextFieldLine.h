//
//  UICanuTextFieldLine.h
//  CANU
//
//  Created by Vivien Cormier on 08/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuTextFieldLine : UITextField

@property (nonatomic) BOOL valueValide;
@property (nonatomic) BOOL disablePlaceHolderAnimate;

- (void)textChange:(NSString *)text;

@end
