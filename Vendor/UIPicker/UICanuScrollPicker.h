//
//  UICanuScrollPicker.h
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuScrollPicker : UIScrollView

@property (retain) id delegatePicker;

- (id)initWithFrame:(CGRect)frame WithContent:(NSArray *)arrayContent;

/**
 *  Change position Scroll to index
 *
 *  @param currentObject
 */
- (void)changeCurrentObjectTo:(int)currentObject;

- (int)currentObject;

- (void)blockScrollTo:(int)value;

@end

@protocol UICanuScrollPickerDelegate <NSObject>

@required

- (void)blockedValueIsSelected:(BOOL)isSelected;

@end
