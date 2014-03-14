//
//  UICANULocationCell.m
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICANULocationCell.h"

#import "Location.h"

@interface UICANULocationCell ()



@end

@implementation UICANULocationCell

- (id)initWithFrame:(CGRect)frame WithLocation:(Location *)location{
    
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor whiteColor];
        
        self.location = location;
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, 233, 20)];
        name.font = [UIFont fontWithName:@"Lato-Bold" size:13];
        name.textColor = UIColorFromRGB(0x1a8d9e);
        name.text = location.name;
        [self addSubview:name];
        
        UILabel *adress = [[UILabel alloc]initWithFrame:CGRectMake(10, 26, 233, 10)];
        adress.font = [UIFont fontWithName:@"Lato-Regular" size:8];
        adress.textColor = UIColorFromRGB(0x2b4b58);
        adress.text = location.displayAdresse;
        [self addSubview:adress];
        
        self.square = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 28 - 10, (frame.size.height - 27)/2, 28, 27)];
        self.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location"];
        [self addSubview:_square];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellIsTouched)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)cellIsTouched{
    
    [self.delegate cellLocationIsTouched:self];
    
}

@end
