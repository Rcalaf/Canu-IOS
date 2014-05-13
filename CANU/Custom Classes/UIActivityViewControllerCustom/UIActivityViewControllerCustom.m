//
//  UIActivityViewControllerCustom.m
//  CANU
//
//  Created by Vivien Cormier on 07/05/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UIActivityViewControllerCustom.h"

#import "AppDelegate.h"
#import "UICanuButton.h"

@interface UIActivityViewControllerCustom ()

@property (strong, nonatomic) UIView *backgroundOpacity;
@property (strong, nonatomic) UIView *wrapper;
@property (strong, nonatomic) UIImageView *illustration;
@property (strong, nonatomic) NSMutableArray *arrayCellButtons;

@end

@implementation UIActivityViewControllerCustom

- (instancetype)initWithUIImage:(UIImage *)image andButtons:(NSArray *)buttons
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        
        self.backgroundOpacity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
        self.backgroundOpacity.backgroundColor = UIColorFromRGB(0x2b4b58);
        self.backgroundOpacity.alpha = 0;
        [self addSubview:_backgroundOpacity];
        
        UITapGestureRecognizer *closeView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
        [self.backgroundOpacity addGestureRecognizer:closeView];
        
        self.wrapper = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 280, 0)];
        self.wrapper.alpha = 0;
        [self addSubview:_wrapper];
        
        UIImageView *backgroundImage = [UIImageView new];
        backgroundImage.image = [[UIImage imageNamed:@"All_background_UIActivityView"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0];
        [self.wrapper addSubview:backgroundImage];
        
        self.illustration = [[UIImageView alloc]initWithFrame:CGRectMake( (280 - image.size.width) / 2, 10, image.size.width, image.size.height)];
        self.illustration.image = image;
        self.illustration.alpha = 0;
        self.illustration.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self.wrapper addSubview:_illustration];
        
        self.arrayCellButtons = [NSMutableArray new];
        
        NSInteger positionY = 10 + image.size.width + 20;
        
        for (int i = 0; i < [buttons count]; i++) {
            
            UICanuButton *button = [[UICanuButton alloc]initWithFrame:CGRectMake(10, positionY, 260, 45) forStyle:UICanuButtonStyleWhite];
            [button setTitle:[buttons objectAtIndex:i] forState:UIControlStateNormal];
            button.alpha = 0;
            button.transform = CGAffineTransformMakeScale(0.8, 0.8);
            [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.wrapper addSubview:button];
            
            [self.arrayCellButtons addObject:button];
            
            positionY += 45 + 5;
            
        }
        
        positionY += 5;
        
        UICanuButton *cancel = [[UICanuButton alloc]initWithFrame:CGRectMake(10, positionY, 260, 45) forStyle:UICanuButtonStyleLarge];
        [cancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        cancel.alpha = 0;
        cancel.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [cancel addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self.wrapper addSubview:cancel];
        
        [self.arrayCellButtons addObject:cancel];
        
        positionY += 45 + 5;
        
        // Height View
        NSInteger height = positionY + 5;
        
        self.wrapper.frame = CGRectMake( 20, ([[UIScreen mainScreen] bounds].size.height - height) / 2, 280, height);
        backgroundImage.frame = CGRectMake( -3, -3, self.wrapper.frame.size.width + 6, self.wrapper.frame.size.height + 6);
        
    }
    return self;
}

#pragma mark - Public

- (void)show{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundOpacity.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.wrapper.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.illustration.alpha = 1;
                self.illustration.transform = CGAffineTransformMakeScale(1, 1);
            } completion:nil];
            
            for (int i = 0; i < [_arrayCellButtons count]; i ++) {
                
                UICanuButton *button = [_arrayCellButtons objectAtIndex:i];
                
                [UIView animateWithDuration:0.2 delay:0.1f + i * 0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    button.alpha = 1;
                    button.transform = CGAffineTransformMakeScale(1, 1);
                } completion:nil];
                
            }
        }];
    }];
    
}

#pragma mark - Private

- (void)buttonEvent:(UIButton *)button{
    
    [self closeViewBlock:^(BOOL finished) {
        if (_object) {
            [self.delegate ActivityAction:button.titleLabel.text WithObject:_object];
        } else {
            [self.delegate ActivityAction:button.titleLabel.text];
        }
    }];
    
}

- (void)closeView{
    [self closeViewBlock:nil];
}

- (void)closeViewBlock:(void (^)(BOOL finished))block{
    
    for (int i = 0; i < [_arrayCellButtons count]; i ++) {
        
        UICanuButton *button = [_arrayCellButtons objectAtIndex:i];
        
        [UIView animateWithDuration:0.4 animations:^{
            button.alpha = 0;
            button.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:nil];
        
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.illustration.alpha = 0;
        self.illustration.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.wrapper.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundOpacity.alpha = 0;
            } completion:^(BOOL finished) {
                if (block) {
                    block(true);
                }
                [self removeFromSuperview];
            }];
        }];
    }];
    
}

@end
