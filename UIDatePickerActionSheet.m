//
//  UIDatePickerActionSheet.m
//  CANU
//
//  Created by Roger Calaf on 12/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UIDatePickerActionSheet.h"

@interface UIDatePickerActionSheet ()





@end

@implementation UIDatePickerActionSheet

@synthesize datePicker = _datePicker;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.minuteInterval = 15;
        [self addSubview:_datePicker];
       // _datePicker = [[UIDatePicker alloc] init];
       // [self addSubview:_datePicker];
    }
    return self;
}

/*- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    
    return self;
}*/


- (void)showInView:(UIView *)view {
	[super showInView:view];
	[self setFrame:CGRectMake(0, 160 + KIphone5Margin, 320, 272)];
    	
	// get an array of all of the subviews of our action sheet
	//NSArray *subviews = [self subviews];
    //NSLog(@"%@",subviews);
	
	//[[subviews objectAtIndex:self.firstOtherButtonIndex] setFrame:CGRectMake(20, 226, 280, 46)];
	[_datePicker setFrame:CGRectMake(0, 85, 320, 216)];
	
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
