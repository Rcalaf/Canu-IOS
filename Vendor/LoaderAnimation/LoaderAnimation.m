//
//  LoaderAnimation.m
//  CANU
//
//  Created by Vivien Cormier on 18/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "LoaderAnimation.h"

@interface LoaderAnimation ()

@property (nonatomic) int start;
@property (nonatomic) int end;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) BOOL isLoading;

@end

@implementation LoaderAnimation

- (id)initWithFrame:(CGRect)frame withStart:(int)start andEnd:(int)end
{
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, 30, 30);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.start = abs(start);
        
        self.end = abs(end);
        
        self.isLoading = NO;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.imageView.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"loop_1"],
                                       [UIImage imageNamed:@"loop_2"],
                                       [UIImage imageNamed:@"loop_3"],
                                       [UIImage imageNamed:@"loop_4"], nil];
        self.imageView.animationDuration = 1.0f;
        self.imageView.animationRepeatCount = 0;
        [self addSubview:_imageView];
        
    }
    return self;
}

- (void)contentOffset:(float)contentOffset{
    
    if (_isLoading || contentOffset > 0) {
        return;
    }
    
    contentOffset = fabsf(contentOffset);
    
    float value = 0;
    
    if (contentOffset > _start && contentOffset <= _end) {
        value = (contentOffset - _start) / (_end - _start);
    }else if (contentOffset > _end){
        value = 1;
    }else if (contentOffset <= _start){
        value = 0;
    }
    
    // convert value to image name
    
    if (value != 0 ) {
        
        int numberImage = roundf(value * 16 + 1);
        
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loader-%i",numberImage]];
        
    }else{
        self.imageView.image = nil;
    }
    
}

- (void)startAnimation{
    
    self.isLoading = YES;
    
    [_imageView startAnimating];
    
}

- (void)stopAnimation{
    
    self.isLoading = NO;
    
    [_imageView stopAnimating];
    
}

@end
