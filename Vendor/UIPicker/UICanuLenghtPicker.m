//
//  UICanuLenghtPicker.m
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLenghtPicker.h"

@interface UICanuLenghtPicker () <UIScrollViewDelegate>

@property (nonatomic) int currentObject;
@property (strong, nonatomic) UILabel *patternHours;
@property (strong, nonatomic) UIScrollView *lenghtScroll;
@property (strong, nonatomic) NSMutableArray *arrayDataLowDisable;

@end

@implementation UICanuLenghtPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrayDataLowDisable = [[NSMutableArray alloc]init];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15, 47)];
        icon.image = [UIImage imageNamed:@"F1_lenght_picker"];
        [self addSubview:icon];
        
        UILabel *patternMins = [[UILabel alloc]initWithFrame:CGRectMake(43, 21, 80, 16)];
        patternMins.text = @"min";
        patternMins.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        patternMins.textColor = UIColorFromRGB(0x1ca6c3);
        patternMins.textAlignment = NSTextAlignmentRight;
        patternMins.backgroundColor = [UIColor whiteColor];
        [self addSubview:patternMins];
        
        self.patternHours = [[UILabel alloc]initWithFrame:CGRectMake(40, 21, 37, 16)];
        self.patternHours.text = @"h";
        self.patternHours.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        self.patternHours.textColor = UIColorFromRGB(0x1ca6c3);
        self.patternHours.textAlignment = NSTextAlignmentRight;
        self.patternHours.backgroundColor = [UIColor whiteColor];
        [self addSubview:_patternHours];
        
        self.lenghtScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 1, 100, self.frame.size.height - 2)];
        self.lenghtScroll.backgroundColor = [UIColor clearColor];
        self.lenghtScroll.contentSize = CGSizeMake( 100, 19 + 96 * 26);
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
                minHour = [NSString stringWithFormat:@"%i",mins];
            } else if (hours != 0 && mins != 0) {
                minHour = [NSString stringWithFormat:@"%i      %i",hours,mins];
            } else {
                minHour = [NSString stringWithFormat:@"%i      00",hours];
            }
            
            UILabel *dataGray = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + i * 26, 60, 16)];
            dataGray.text = minHour;
            dataGray.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            dataGray.textColor = UIColorFromRGB(0xe0e3e4);
            dataGray.textAlignment = NSTextAlignmentRight;
            dataGray.backgroundColor = [UIColor clearColor];
            [self.lenghtScroll addSubview:dataGray];
            
            UILabel *data = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + i * 26, 60, 16)];
            data.text = minHour;
            data.font = [UIFont fontWithName:@"Lato-Bold" size:15];
            data.textColor = UIColorFromRGB(0x1ca6c3);
            data.textAlignment = NSTextAlignmentRight;
            data.backgroundColor = [UIColor clearColor];
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
    
    float fractionalPage = scrollView.contentOffset.y/ 26.0f ;
    NSInteger nearestNumberCurrent = lround(fractionalPage);
    
    int newCurrentObject = 0;
    
    if (nearestNumberCurrent < 0) {
        newCurrentObject = 0;
    }else if (nearestNumberCurrent > 96){
        newCurrentObject = 96;
    }else{
        newCurrentObject = nearestNumberCurrent;
    }
    
    _currentObject = newCurrentObject;
    
    for (int i = 0; i < [_arrayDataLowDisable count]; i++) {
        
        UILabel *data = [_arrayDataLowDisable objectAtIndex:i];
        
        if (i != _currentObject) {
            [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 data.alpha = 0;
                             }completion:^(BOOL finished) {}];
        } else {
            [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 data.alpha = 1;
                             }completion:^(BOOL finished) {}];
        }
        
    }
    
    // if there is hour
    if (_currentObject >= 3) {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.patternHours.alpha = 1;
                         }completion:^(BOOL finished) {}];
    } else {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.patternHours.alpha = 0;
                         }completion:^(BOOL finished) {}];
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
    
    int scrollContentOffeset = _currentObject * 26;
    
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
