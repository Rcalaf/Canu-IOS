//
//  UICanuAMPMPicker.m
//  CANU
//
//  Created by Vivien Cormier on 10/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuAMPMPicker.h"

@interface UICanuAMPMPicker () <UIScrollViewDelegate>

@property (nonatomic) int currentObject;
@property (nonatomic) int blockTo;
@property (strong, nonatomic) UILabel *amLabel;
@property (strong, nonatomic) UILabel *pmLabel;

@end

@implementation UICanuAMPMPicker

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        
        self.showsVerticalScrollIndicator = NO;
        
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        self.contentSize = CGSizeMake(frame.size.width, 29 + 2 * 55 + 29);
        
        self.amLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, frame.size.width - 5, 55)];
        self.amLabel.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        self.amLabel.textColor = UIColorFromRGB(0x2b4b58);
        self.amLabel.textAlignment = NSTextAlignmentCenter;
        self.amLabel.text = @"AM";
        self.amLabel.backgroundColor = [UIColor clearColor];
        self.amLabel.alpha = 0.3f;
        [self addSubview:_amLabel];
        
        self.pmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 + 55, frame.size.width - 5, 55)];
        self.pmLabel.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        self.pmLabel.textColor = UIColorFromRGB(0x2b4b58);
        self.pmLabel.textAlignment = NSTextAlignmentCenter;
        self.pmLabel.text = @"PM";
        self.pmLabel.backgroundColor = [UIColor clearColor];
        self.pmLabel.alpha = 0.3f;
        [self addSubview:_pmLabel];
        
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
    
    if (_currentObject >= 0 && _currentObject <= 1) {
        
        _currentObject = currentObject;
        
        [self adapteCellWithAnimation:NO];
        
    }
    
}

- (int)currentObject{
    
    int current = _currentObject;
    
    return current;
    
}

- (void)blockTo:(int)value{
    
    self.blockTo = value;
    
    [self scrollViewDidScroll:self];
    
    [self adapteCellWithAnimation:YES];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float fractionalPage = scrollView.contentOffset.y/ 55.0f ;
    NSInteger nearestNumberCurrent = lround(fractionalPage);
    
    int newCurrentObject = 0;
    
    if (nearestNumberCurrent < 0) {
        newCurrentObject = 0;
    }else if (nearestNumberCurrent > 1){
        newCurrentObject = 1;
    }else{
        newCurrentObject = nearestNumberCurrent;
    }
    
    if (_blockTo < 2) {
        if (_blockTo == 1) {
            _currentObject = _blockTo;
        } else {
            _currentObject = newCurrentObject;
        }
        
        if (_currentObject == _blockTo) {
            [self.delegatePicker amPmchangeIsBlockedValue:YES];
        } else {
            [self.delegatePicker amPmchangeIsBlockedValue:NO];
        }
    } else {
        _currentObject = newCurrentObject;
    }
    
    if (_currentObject == 0) {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.amLabel.alpha = 1;
                         }completion:^(BOOL finished) {}];
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.pmLabel.alpha = 0.3f;
                         }completion:^(BOOL finished) {}];
    } else {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.amLabel.alpha = 0.3f;
                         }completion:^(BOOL finished) {}];
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.pmLabel.alpha = 1;
                         }completion:^(BOOL finished) {}];
    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self performSelector:@selector(performScrollView) withObject:nil afterDelay:0.05];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self performSelector:@selector(performScrollView) withObject:nil afterDelay:0.05];
}

- (void)performScrollView{
    [self adapteCellWithAnimation:YES];
}

#pragma mark - Private

- (void)adapteCellWithAnimation:(BOOL)animation{
    
    int scrollContentOffeset = _currentObject * 55;
    
    float delay = 0.15f;
    
    if (!animation) {
        delay = 0.0f;
    }
    
    [UIView animateWithDuration:delay delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.contentOffset = CGPointMake(0, scrollContentOffeset);
                     }completion:nil];
    
}

@end
