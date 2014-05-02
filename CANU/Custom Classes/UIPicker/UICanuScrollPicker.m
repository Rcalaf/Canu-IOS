//
//  UICanuScrollPicker.m
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuScrollPicker.h"

@interface UICanuScrollPicker () <UIScrollViewDelegate>

@property (nonatomic) NSInteger blockedValue;
@property (nonatomic) NSInteger currentObject;
@property (strong, nonatomic) NSArray *arrayContent;
@property (strong, nonatomic) NSMutableArray *arrayLabel;

@end

@implementation UICanuScrollPicker

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame WithContent:(NSArray *)arrayContent
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.blockedValue = [arrayContent count];
        
        self.delegate = self;
        
        self.showsVerticalScrollIndicator = NO;
        
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        self.arrayContent = arrayContent;
        
        NSInteger maxContent = [arrayContent count];
        
        self.contentSize = CGSizeMake(frame.size.width, 29 + ( maxContent + 6 ) * 55 + 55);
        
        self.backgroundColor = [UIColor clearColor];
        
        self.arrayLabel = [[NSMutableArray alloc]init];
        
        for (int i = (int)[arrayContent count] - 3; i < [arrayContent count]; i ++) {
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 29 + ( 2 - ( maxContent - 1 - i ) ) * 55, frame.size.width, 55)];
            data.font = [UIFont fontWithName:@"Lato-Regular" size:18];
            data.textColor = UIColorFromRGB(0x2b4b58);
            data.textAlignment = NSTextAlignmentCenter;
            data.text = [arrayContent objectAtIndex:i];
            data.backgroundColor = [UIColor clearColor];
            data.alpha = 0.3f;
            [self addSubview:data];
            [self.arrayLabel addObject:data];
            
        }

        for (int i = 0; i < maxContent; i ++) {
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 29 + ( i + 3 ) * 55, frame.size.width, 55)];
            data.font = [UIFont fontWithName:@"Lato-Regular" size:18];
            data.textColor = UIColorFromRGB(0x2b4b58);
            data.textAlignment = NSTextAlignmentCenter;
            data.text = [arrayContent objectAtIndex:i];
            data.backgroundColor = [UIColor clearColor];
            data.alpha = 0.3f;
            [self addSubview:data];
            [self.arrayLabel addObject:data];
            
        }
        
        for (int i = 0; i < 3; i ++) {
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 29 +  (i + 3 + maxContent) * 55, frame.size.width, 55)];
            data.font = [UIFont fontWithName:@"Lato-Regular" size:18];
            data.textColor = UIColorFromRGB(0x2b4b58);
            data.textAlignment = NSTextAlignmentCenter;
            data.text = [arrayContent objectAtIndex:i];
            data.backgroundColor = [UIColor clearColor];
            data.alpha = 0.3f;
            [self addSubview:data];
            [self.arrayLabel addObject:data];
            
        }
        
    }
    return self;
}

#pragma mark - Public

/**
 *  Change position Scroll to index
 *
 *  @param currentObject
 */
- (void)changeCurrentObjectTo:(NSInteger)currentObject{
    
    if (_currentObject >= -3 && _currentObject <= [_arrayContent count] + 3) {
        
        _currentObject = currentObject;
        
        [self adapteCellWithAnimation:NO];
        
    }
    
}

- (NSInteger)currentObject{
    
    NSInteger current = _currentObject;
    
    if (_currentObject < 0) {
        
        current = _currentObject + [_arrayContent count];
        
    } else if (_currentObject >= [_arrayContent count]) {
        
        current = _currentObject - [_arrayContent count];
        
    }
    
    return current;
    
}

- (void)blockScrollTo:(NSInteger)value{
    
    self.blockedValue = value;
    
    [self scrollViewDidScroll:self];
    
    [self adapteCellWithAnimation:YES];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float fractionalPage = scrollView.contentOffset.y/ 55.0f ;
    NSInteger nearestNumberCurrent = lround(fractionalPage);
    
    [self changementCurrentObjectIfBlockedValue:nearestNumberCurrent - 3];
    
    if (_currentObject < 0) {
        [self adapteScrollInfinite];
    }
    
    if (_currentObject > [_arrayContent count]) {
        [self adapteScrollInfinite];
    }
    
    for (int i = 0; i < [_arrayLabel count]; i++) {
        
        UILabel *data = [_arrayLabel objectAtIndex:i];
        
        if (i - 3 != _currentObject) {
            [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 data.alpha = 0.3f;
                             }completion:^(BOOL finished) {}];
        } else {
            [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 data.alpha = 1;
                             }completion:^(BOOL finished) {}];
        }
        
    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView.contentOffset.y > 0 && velocity.y == 0) [self adapteCellWithAnimation:YES];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) [self adapteCellWithAnimation:YES];
}

#pragma mark - Private

- (void)adapteCellWithAnimation:(BOOL)animation{
    
    NSInteger scrollContentOffeset = ( _currentObject + 3 ) * 55;
    
    float delay = 0.15f;
    
    if (!animation) {
        delay = 0.0f;
    }
    
    [UIView animateWithDuration:delay delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.contentOffset = CGPointMake(0, scrollContentOffeset);
                     }completion:nil];
    
}

- (void)adapteScrollInfinite{
    
    if (_currentObject < 0) {
        
        _currentObject = _currentObject + [_arrayContent count];
        
        self.contentOffset = CGPointMake(0, self.contentOffset.y + [_arrayContent count] * 55.0f);
        
    } else if (_currentObject > [_arrayContent count]) {
        
        _currentObject = _currentObject - [_arrayContent count];
        
        self.contentOffset = CGPointMake(0, self.contentOffset.y - [_arrayContent count] * 55.0f);
        
    }
    
}

- (void)changementCurrentObjectIfBlockedValue:(NSInteger)value{
    
    NSInteger current = value;
    
    if (value < 0) {
        
        current = value + [_arrayContent count];
        
    } else if (value >= [_arrayContent count]) {
        
        current = value - [_arrayContent count];
        
    }
    
    if (current >= 0 && current <= _blockedValue && _blockedValue <= [_arrayContent count] - 1) {
        if (current == 0) {
            _currentObject = value - 1;
        } else {
            _currentObject = _blockedValue;
        }
    } else {
        _currentObject = value;
    }
    
    if (_currentObject == _blockedValue) {
        [self.delegatePicker blockedValueIsSelected:YES];
    } else {
        [self.delegatePicker blockedValueIsSelected:NO];
    }
    
}

@end
