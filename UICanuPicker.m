//
//  UICanuPicker.m
//  CANU
//
//  Created by Roger Calaf on 12/06/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuPicker.h"

@protocol UICanuPickerDelegate;

@implementation UICanuPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        UIGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSetValue:self:)];
        [self addGestureRecognizer:pangr];
        
    }
    return self;
}

- (void)didSetValue:(UICanuPicker *)canupicker gestureRecognizer:(UIPanGestureRecognizer *)gesture{
    CGPoint point= [gesture locationInView:self];
    NSLog(@"%f %f",point.x,point.y);
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

@protocol UICanuPickerDelegate <NSObject>
@optional

- (void)didSetValue:(UICanuPicker *)canupicker gestureRecognizer:(UIPanGestureRecognizer *)gesture;

@end
