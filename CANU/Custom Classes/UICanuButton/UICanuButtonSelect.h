//
//  UICanuButtonSelect.h
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuButtonSelect : UIButton

/**
 *  Change visual of this button
 */
@property (nonatomic, readwrite) BOOL selected;

/**
 *  Add text to the button
 */
@property (strong, nonatomic) NSString *textButton;

@end
