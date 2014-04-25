//
//  UICanuAMPMPicker.h
//  CANU
//
//  Created by Vivien Cormier on 10/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuAMPMPicker : UIScrollView

@property (retain) id delegatePicker;

/**
 *  Change position Scroll to index
 *
 *  @param currentObject
 */
- (void)changeCurrentObjectTo:(int)currentObject;

- (NSInteger)currentObject;

- (void)blockTo:(int)value;

@end


@protocol UICanuAMPMPickerDelegate <NSObject>

@required

- (void)amPmchangeIsBlockedValue:(BOOL)blockedValue;

@end