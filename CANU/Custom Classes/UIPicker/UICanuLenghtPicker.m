//
//  UICanuLenghtPicker.m
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLenghtPicker.h"

@interface UICanuLenghtPicker () <UIScrollViewDelegate>

@property (nonatomic) NSInteger currentObject;
@property (strong, nonatomic) UIScrollView *lenghtScroll;
@property (strong, nonatomic) NSMutableArray *arrayDataLowDisable;

@end

@implementation UICanuLenghtPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrayDataLowDisable = [[NSMutableArray alloc]init];
        
        UIView *backgroundSelected = [[UIView alloc]initWithFrame:CGRectMake(0, 35, frame.size.width, 45)];
        backgroundSelected.backgroundColor = UIColorFromRGB(0xf8fafa);
        [self addSubview:backgroundSelected];
        
        UILabel *forText = [[UILabel alloc]initWithFrame:CGRectMake(15, 51, 30, 13)];
        forText.textColor = UIColorFromRGB(0x2b4b58);
        forText.backgroundColor = UIColorFromRGB(0xf8fafa);
        forText.font = [UIFont fontWithName:@"Lato-Regular" size:13];
        forText.text = NSLocalizedString(@"For :", nil);
        [self addSubview:forText];
        
        self.lenghtScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 0, 100, self.frame.size.height)];
        self.lenghtScroll.backgroundColor = [UIColor clearColor];
        self.lenghtScroll.contentSize = CGSizeMake( 100, 55 + 96 * 55);
        self.lenghtScroll.decelerationRate = UIScrollViewDecelerationRateFast;
        self.lenghtScroll.showsVerticalScrollIndicator = NO;
        self.lenghtScroll.delegate = self;
        [self addSubview:_lenghtScroll];
        
        int mins = 0,hours = 0;
        
        for (int i = 0; i < 96; i++) {
            
            int gap = 15;
            
            if (hours >= 6) {
                gap = 30;
            }
            
            mins += gap;
            
            if (mins >= 60) {
                mins = 0;
                hours ++;
            }
            
            NSString *minHour;
            
            if (hours == 0) {
                minHour = [NSString stringWithFormat:@"%i min",mins];
            } else if (hours != 0 && mins != 0) {
                minHour = [NSString stringWithFormat:@"%i h %i min",hours,mins];
            } else {
                minHour = [NSString stringWithFormat:@"%i h",hours];
            }
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 29 + i * 55, 95, 55)];
            data.text = minHour;
            data.font = [UIFont fontWithName:@"Lato-Regular" size:18];
            data.textColor = UIColorFromRGB(0x2b4b58);
            data.backgroundColor = [UIColor clearColor];
            data.alpha = 0.3f;
            [self.lenghtScroll addSubview:data];
            [self.arrayDataLowDisable addObject:data];
            
        }
        
        [self changeCurrentObjectTo:1];
        [self changeCurrentObjectTo:0];
        
        UITapGestureRecognizer *tapAddValue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addValueLenght)];
        [self addGestureRecognizer:tapAddValue];
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float fractionalPage = scrollView.contentOffset.y/ 55.0f ;
    NSInteger nearestNumberCurrent = lround(fractionalPage);
    
    NSInteger newCurrentObject = 0;
    
    if (nearestNumberCurrent < 0) {
        newCurrentObject = 0;
    }else if (nearestNumberCurrent > 96){
        newCurrentObject = 96;
    }else{
        newCurrentObject = nearestNumberCurrent;
    }
    
    _currentObject = newCurrentObject;
    
    int minIndex = _currentObject - 2;
    
    if (minIndex < 0) {
        minIndex = 0;
    }
    
    int maxIndex = _currentObject + 2;
    
    if (maxIndex > [_arrayDataLowDisable count]) {
        maxIndex = [_arrayDataLowDisable count];
    }
    
    for (int i = minIndex; i < maxIndex; i++) {
        
        UILabel *data = [_arrayDataLowDisable objectAtIndex:i];
        
        if (i != _currentObject) {
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

#pragma mark - Public

- (NSString *)selectedLenght{
    
    NSString *lenght;
    
    int mins = 0,hours = 0;
    
    for (int i = 0; i <= _currentObject; i++) {
        
        int gap = 15;
        
        if (hours >= 6) {
            gap = 30;
        }
        
        mins += gap;
        
        if (mins >= 60) {
            mins = 0;
            hours ++;
        }
        
    }
    
    lenght = [NSString stringWithFormat:@"%.2d:%.2d", hours,mins];
    
    return lenght;
    
}

- (void)changeTo:(NSString *)lenght{
    
    NSArray *dateParts = [lenght componentsSeparatedByString:@"T"];
    NSArray *timeParts = [[dateParts objectAtIndex:1] componentsSeparatedByString:@":"];
    NSInteger hoursSave = [[timeParts objectAtIndex:0] integerValue];
    NSInteger minsSave = [[timeParts objectAtIndex:1] integerValue];
    
    int mins = 0,hours = 0;
    
    for (int i = 0; i <= 96; i++) {
        
        int gap = 15;
        
        if (hours >= 6) {
            gap = 30;
        }
        
        mins += gap;
        
        if (mins >= 60) {
            mins = 0;
            hours ++;
        }
        
        if (mins == minsSave && hours == hoursSave) {
            
            [self changeCurrentObjectTo:i];
            return;
            
        }
        
    }
    
}

#pragma mark - Private

- (void)addValueLenght{
    
    _currentObject ++;
    
    if (_currentObject > 96) {
        
        _currentObject = 96;
        
    }
    
    [self adapteCellWithAnimation:YES];
    
}

- (void)changeCurrentObjectTo:(int)currentObject{
    
    if (_currentObject >= 0 && _currentObject <= 96) {
        
        _currentObject = currentObject;
        
        [self adapteCellWithAnimation:NO];
        
    }
    
}

- (void)adapteCellWithAnimation:(BOOL)animation{
    
    NSInteger scrollContentOffeset = _currentObject * 55;
    
    float delay = 0.15f;
    
    if (!animation) {
        delay = 0.0f;
    }
    
    [UIView animateWithDuration:delay delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.lenghtScroll.contentOffset = CGPointMake(0, scrollContentOffeset);
                     }completion:nil];
    
}

@end
