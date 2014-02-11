//
//  UICanuScrollPicker.m
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuScrollPicker.h"

@interface UICanuScrollPicker () <UIScrollViewDelegate>

@property (nonatomic) int currentObject;
@property (strong, nonatomic) NSArray *arrayContent;
@property (strong, nonatomic) NSMutableArray *arrayDataLowDisable;

@end

@implementation UICanuScrollPicker

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame WithContent:(NSArray *)arrayContent
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        
        self.showsVerticalScrollIndicator = NO;
        
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        self.arrayContent = arrayContent;
        
        int maxContent = [arrayContent count];
        
        self.contentSize = CGSizeMake(frame.size.width, 19 + ( maxContent + 6 ) * 26 + 16);
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.arrayDataLowDisable = [[NSMutableArray alloc]init];
        
        for (int i = [arrayContent count] - 3; i < [arrayContent count]; i ++) {
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + ( 2 - ( maxContent - 1 - i ) ) * 26, frame.size.width, 16)];
            data.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            data.textColor = UIColorFromRGB(0x1ca6c3);
            data.textAlignment = NSTextAlignmentCenter;
            data.text = [arrayContent objectAtIndex:i];
            data.backgroundColor = [UIColor whiteColor];
            [self addSubview:data];
            
            UILabel *dataGray = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + ( 2 - ( maxContent - 1 - i ) ) * 26, frame.size.width, 16)];
            dataGray.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            dataGray.textColor = UIColorFromRGB(0xe0e3e4);
            dataGray.textAlignment = NSTextAlignmentCenter;
            dataGray.text = [arrayContent objectAtIndex:i];
            dataGray.backgroundColor = [UIColor whiteColor];
            [self addSubview:dataGray];
            [self.arrayDataLowDisable addObject:dataGray];
            
        }

        for (int i = 0; i < maxContent; i ++) {
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + ( i + 3 ) * 26, frame.size.width, 16)];
            data.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            data.textColor = UIColorFromRGB(0x1ca6c3);
            data.textAlignment = NSTextAlignmentCenter;
            data.text = [arrayContent objectAtIndex:i];
            data.backgroundColor = [UIColor whiteColor];
            [self addSubview:data];
            
            UILabel *dataGray = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + ( i + 3 ) * 26, frame.size.width, 16)];
            dataGray.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            dataGray.textColor = UIColorFromRGB(0xe0e3e4);
            dataGray.textAlignment = NSTextAlignmentCenter;
            dataGray.text = [arrayContent objectAtIndex:i];
            dataGray.backgroundColor = [UIColor whiteColor];
            [self addSubview:dataGray];
            [self.arrayDataLowDisable addObject:dataGray];
            
        }
        
        for (int i = 0; i < 3; i ++) {
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 +  (i + 3 + maxContent) * 26, frame.size.width, 16)];
            data.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            data.textColor = UIColorFromRGB(0x1ca6c3);
            data.textAlignment = NSTextAlignmentCenter;
            data.text = [arrayContent objectAtIndex:i];
            data.backgroundColor = [UIColor whiteColor];
            [self addSubview:data];
            
            UILabel *dataGray = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 +  (i + 3 + maxContent) * 26, frame.size.width, 16)];
            dataGray.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            dataGray.textColor = UIColorFromRGB(0xe0e3e4);
            dataGray.textAlignment = NSTextAlignmentCenter;
            dataGray.text = [arrayContent objectAtIndex:i];
            dataGray.backgroundColor = [UIColor whiteColor];
            [self addSubview:dataGray];
            [self.arrayDataLowDisable addObject:dataGray];
            
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
- (void)changeCurrentObjectTo:(int)currentObject{
    
    if (_currentObject >= -3 && _currentObject <= [_arrayContent count] + 3) {
        
        _currentObject = currentObject;
        
        [self adapteCellWithAnimation:NO];
        
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float fractionalPage = scrollView.contentOffset.y/ 26.0f ;
    NSInteger nearestNumberCurrent = lround(fractionalPage);
    
    int newCurrentObject = 0;
    
    if (nearestNumberCurrent < 0) {
        newCurrentObject = 0;
    }else if (nearestNumberCurrent > [_arrayContent count] + 6){
        newCurrentObject = [_arrayContent count] + 6;
    }else{
        newCurrentObject = nearestNumberCurrent;
    }
    
    _currentObject = newCurrentObject - 3;
    
    if (_currentObject < 0) {
        [self adapteScrollInfinite];
    }
    
    if (_currentObject > [_arrayContent count]) {
        [self adapteScrollInfinite];
    }
    
    for (int i = 0; i < [_arrayDataLowDisable count]; i++) {
        
        UILabel *data = [_arrayDataLowDisable objectAtIndex:i];
        
        if (i - 3 != _currentObject) {
            [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 data.alpha = 1;
                             }completion:^(BOOL finished) {}];
        } else {
            [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 data.alpha = 0;
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
    
    int scrollContentOffeset = ( _currentObject + 3 ) * 26;
    
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
        
        self.contentOffset = CGPointMake(0, self.contentOffset.y + [_arrayContent count] * 26.0f);
        
    } else if (_currentObject > [_arrayContent count]) {
        
        _currentObject = _currentObject - [_arrayContent count];
        
        self.contentOffset = CGPointMake(0, self.contentOffset.y - [_arrayContent count] * 26.0f);
        
    }
    
}

@end
