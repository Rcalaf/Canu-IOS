//
//  UICanuSearchLocation.m
//  CANU
//
//  Created by Vivien Cormier on 14/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuSearchLocation.h"

#import "Location.h"
#import "UICANULocationCell.h"

static int const KHeightMax = 213;

@interface UICanuSearchLocation ()

@property (strong, nonatomic) NSMutableArray *arrayLocation;
@property (strong, nonatomic) NSMutableArray *arrayCellLocation;

@end

@implementation UICanuSearchLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.searchLocation = @"";
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = UIColorFromRGB(0xe9eeee);
        
        UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 6)];
        shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        [self addSubview:shadowDescription];
        
        UIImageView *shadowDescriptionReverse = [[UIImageView alloc]initWithFrame:CGRectMake(0, KHeightMax - 6, 320, 6)];
        shadowDescriptionReverse.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        shadowDescriptionReverse.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:shadowDescriptionReverse];
        
        self.arrayCellLocation = [[NSMutableArray alloc]init];
        
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setCurrentLocation:(MKMapItem *)currentLocation{
    
    _currentLocation = currentLocation;
    
    [self createArrayLocation];
    
}

- (void)setSearchLocation:(NSString *)searchLocation{
    
    _searchLocation = searchLocation;
    
    [self createArrayLocation];
    
}

#pragma mark - Private

- (void)createArrayLocation{
    
    [Location seacrhLocation:_currentLocation SearchWords:_searchLocation Block:^(NSMutableArray *arrayLocation, NSError *error) {
        if (error) {
            NSLog(@"Error");
        } else {
            
            self.arrayLocation = arrayLocation;
            
            [self showLocation];
            
        }
    }];
    
}

- (void)showLocation{
    
    if ([_arrayCellLocation count] != 0 ) {
        
        for (int i = 0; i < [_arrayCellLocation count]; i++) {
            
            UICANULocationCell *cell = [_arrayCellLocation objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayCellLocation removeAllObjects];
        
    }
    
    for (int i = 0; i < [_arrayLocation count]; i++) {
        
        Location *location = [_arrayLocation objectAtIndex:i];
        
        UICANULocationCell *cellLocation = [[UICANULocationCell alloc]initWithFrame:CGRectMake(10, 10 + i * (47 + 10), 300, 47) WithLocation:location];
        [self addSubview:cellLocation];
        [self.arrayCellLocation addObject:cellLocation];
        
    }
    
}

@end
