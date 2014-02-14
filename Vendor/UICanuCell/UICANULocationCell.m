//
//  UICANULocationCell.m
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICANULocationCell.h"

#import "Location.h"

@implementation UICANULocationCell

- (id)initWithFrame:(CGRect)frame WithLocation:(Location *)location{
    
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, 280, 20)];
        name.font = [UIFont fontWithName:@"Lato-Bold" size:13];
        name.textColor = UIColorFromRGB(0x1a8d9e);
        name.text = location.name;
        [self addSubview:name];
        
        UILabel *adress = [[UILabel alloc]initWithFrame:CGRectMake(10, 26, 280, 10)];
        adress.font = [UIFont fontWithName:@"Lato-Regular" size:8];
        adress.textColor = UIColorFromRGB(0x2b4b58);
        adress.text = [NSString stringWithFormat:@"%@, %@",location.street,location.city];
        [self addSubview:adress];
        
        UIImageView *square = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 28 - 10, (frame.size.height - 27)/2, 28, 27)];
        square.image = [UIImage imageNamed:@"F1_Add_Cell_Location"];
        [self addSubview:square];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [button addTarget:self action:@selector(cellIsTouched) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        
    }
    return self;
}

- (void)cellIsTouched{
    
    [self.delegate cellLocationIsTouched:self];
    
}

@end
