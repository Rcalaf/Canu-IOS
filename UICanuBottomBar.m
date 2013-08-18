//
//  UICanuBottomBar.m
//  CANU
//
//  Created by Roger Calaf on 16/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuBottomBar.h"

@implementation UICanuBottomBar

@synthesize backButton = _backButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0, 402.5, 320.0, 57.0)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        //set the create button
        /*
        _createButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createButon setTitle:@"EDIT ACTIVITY" forState:UIControlStateNormal];
      
        [_createButon setFrame:CGRectMake(67.0, 10.0, 243.0, 37.0)];
        [_createButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _createButon.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
        [_createButon setBackgroundColor:[UIColor colorWithRed:(28.0 / 166.0) green:(166.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
        [_createButon addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
        */
        //set Back button
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
        [_backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return self;
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
