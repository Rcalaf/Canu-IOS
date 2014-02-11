//
//  UICanuScrollPicker.h
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICanuScrollPicker : UIScrollView

- (id)initWithFrame:(CGRect)frame WithContent:(NSArray *)arrayContent;

/**
 *  Change position Scroll to index
 *
 *  @param currentObject
 */
- (void)changeCurrentObjectTo:(int)currentObject;

@end
