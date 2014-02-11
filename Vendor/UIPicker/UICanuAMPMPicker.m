//
//  UICanuAMPMPicker.m
//  CANU
//
//  Created by Vivien Cormier on 10/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuAMPMPicker.h"

@interface UICanuAMPMPicker () <UIScrollViewDelegate>

@property (strong, nonatomic) UILabel *amLabel;
@property (strong, nonatomic) UILabel *pmLabel;
@property (nonatomic) int currentObject;

@end

@implementation UICanuAMPMPicker

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        
        self.showsVerticalScrollIndicator = NO;
        
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        self.contentSize = CGSizeMake(frame.size.width, 19 + 2 * 26 + 9);
        
        UILabel *amData = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, frame.size.width, 16)];
        amData.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        amData.textColor = UIColorFromRGB(0xe0e3e4);
        amData.textAlignment = NSTextAlignmentCenter;
        amData.text = @"AM";
        amData.backgroundColor = [UIColor whiteColor];
        [self addSubview:amData];
        
        UILabel *pmData = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + 26, frame.size.width, 16)];
        pmData.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        pmData.textColor = UIColorFromRGB(0xe0e3e4);
        pmData.textAlignment = NSTextAlignmentCenter;
        pmData.text = @"PM";
        pmData.backgroundColor = [UIColor whiteColor];
        [self addSubview:pmData];
        
        self.amLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, frame.size.width, 16)];
        self.amLabel.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        self.amLabel.textColor = UIColorFromRGB(0x1ca6c3);
        self.amLabel.textAlignment = NSTextAlignmentCenter;
        self.amLabel.text = @"AM";
        self.amLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_amLabel];
        
        self.pmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 19 + 26, frame.size.width, 16)];
        self.pmLabel.font = [UIFont fontWithName:@"Lato-Bold" size:10];
        self.pmLabel.textColor = UIColorFromRGB(0x1ca6c3);
        self.pmLabel.textAlignment = NSTextAlignmentCenter;
        self.pmLabel.text = @"PM";
        self.pmLabel.backgroundColor = [UIColor whiteColor];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float fractionalPage = scrollView.contentOffset.y/ 26.0f ;
    NSInteger nearestNumberCurrent = lround(fractionalPage);
    
    int newCurrentObject = 0;
    
    if (nearestNumberCurrent < 0) {
        newCurrentObject = 0;
    }else if (nearestNumberCurrent > 1){
        newCurrentObject = 1;
    }else{
        newCurrentObject = nearestNumberCurrent;
    }
    
    _currentObject = newCurrentObject;
    
    if (_currentObject == 0) {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.amLabel.alpha = 1;
                         }completion:^(BOOL finished) {}];
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.pmLabel.alpha = 0;
                         }completion:^(BOOL finished) {}];
    } else {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.amLabel.alpha = 0;
                         }completion:^(BOOL finished) {}];
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.pmLabel.alpha = 1;
                         }completion:^(BOOL finished) {}];
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
    
    int scrollContentOffeset = _currentObject * 26;
    
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
