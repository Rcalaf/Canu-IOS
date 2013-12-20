//
//  UICanuTextField.m
//  CANU
//
//  Created by Roger Calaf on 16/05/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuTextField.h"

@implementation UICanuTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, frame.size.height)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColor whiteColor];
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textColor = UIColorFromRGB(0x2b4b58);
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

/*
 Overide this method to customize the text bounds
 */
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
//    return inset;
//}

//- (CGRect)rightViewRectForBounds:(CGRect)bounds
//{
//    // return the CGRect that would fit your view/button. The buttons param that is passed here is the size of the view that is being added to the textField.
//    return CGRectMake(self.frame.size.width - 47.0, 0.0, 47.0, 47.0);
//    //
//}

/*
 Overide this method to customize the editing bounds
*/
 
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
//    return inset;
//}

/*
 // Overide this method to customize the placeholder style
 */
//- (void) drawPlaceholderInRect:(CGRect)rect {
//    [[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1] setFill];
//}

@end
