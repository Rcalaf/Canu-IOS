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
#import "UICanuButtonSignBottomBar.h"

@interface UICanuSearchLocation () <UICANULocationCellDelegate, UIScrollViewDelegate>

@property (nonatomic) BOOL isFirstTime;
@property (strong, nonatomic) NSMutableArray *arrayLocation;
@property (strong, nonatomic) NSMutableArray *arrayCellLocation;
@property (strong, nonatomic) UILabel *noResults;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation UICanuSearchLocation

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isFirstTime = YES;
        
        self.clipsToBounds = YES;
        
        self.maxHeight = [[UIScreen mainScreen] bounds].size.height - 65;
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, _maxHeight)];
        self.scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 6)];
        shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        [self addSubview:shadowDescription];
        
        self.arrayCellLocation = [[NSMutableArray alloc]init];
        
        self.noResults = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 300, 47)];
        self.noResults.backgroundColor = [UIColor clearColor];
        self.noResults.textColor = UIColorFromRGB(0xabb3b7);
        self.noResults.text = NSLocalizedString(@"No results ...", nil);
        self.noResults.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        self.noResults.alpha = 0;
        [self.scrollView addSubview:_noResults];
        
    }
    return self;
}

- (void)forceDealloc{
    
    [self.arrayCellLocation removeAllObjects];
    
    [self.arrayLocation removeAllObjects];
    
    [self.scrollView removeFromSuperview];
    
    _arrayLocation = nil;
    _arrayCellLocation = nil;
    _scrollView = nil;
    _currentLocation = nil;
    _locationPicker = nil;
    _selectedLocation = nil;
    
}

- (void)dealloc
{
    NSLog(@"Dealloc UICanuSearchLocation");
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

#pragma mark - UICANULocationCellDelegate

- (void)cellLocationIsTouched:(UICANULocationCell *)cell{
    
    for (int i = 0; i < [_arrayCellLocation count]; i++) {
        
        UICANULocationCell *cellArray = [_arrayCellLocation objectAtIndex:i];
        if (cellArray != cell) {
            cellArray.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location"];
        } else {
            cellArray.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
        }
        
    }
    
    self.selectedLocation = cell.location;
    [self.delegate locationIsSelected:cell.location];
    
    if (_selectedLocation.canuLocation == CANULocationAutocomplete || _selectedLocation.canuLocation == CANULocationPlaceSearch ) {
        
        // Complete the data
        
        [NSThread detachNewThreadSelector:@selector(addFullDataLocation) toTarget:self withObject:nil];
        
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.delegate hiddenKeyboardSearchLocation];
}

#pragma mark - Private

- (void)createArrayLocation{
    
    [Location searchLocation:_currentLocation SearchWords:_searchLocation Block:^(NSMutableArray *arrayLocation, NSError *error) {
        if (error) {
            NSLog(@"Error %@",error);
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
    
    int i = 0;
    
    for (i = 0; i < [_arrayLocation count]; i++) {
        
        Location *location = [_arrayLocation objectAtIndex:i];
        
        UICANULocationCell *cellLocation = [[UICANULocationCell alloc]initWithFrame:CGRectMake(10, 10 + i * (55 + 10), 300, 55) WithLocation:location];
        cellLocation.delegate = self;
        [self.scrollView addSubview:cellLocation];
        [self.arrayCellLocation addObject:cellLocation];
        
        if (!_selectedLocation && _isFirstTime) {
            self.isFirstTime = NO;
            cellLocation.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
            self.selectedLocation = cellLocation.location;
            [self.delegate locationIsSelected:cellLocation.location];
        }
        
        if ([_selectedLocation.name isEqualToString:cellLocation.location.name] && [_selectedLocation.name isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
            cellLocation.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
        }
        
        if ([_selectedLocation.referencePlaceDetails isEqualToString:cellLocation.location.referencePlaceDetails]) {
            cellLocation.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
        }
        
    }
    
    if ([_arrayLocation count] == 0) {
        self.noResults.alpha = 1;
        i++;
    }
    
    NSInteger heightScroll = i * ( 55 + 10) + 10;
    
    if (heightScroll < _maxHeight) {
        heightScroll = _maxHeight + 1;
    }
    
    self.scrollView.contentSize = CGSizeMake(320, heightScroll);
    
}

- (void)addFullDataLocation{
    
    [self.selectedLocation addFullDataLocationBlock:^(Location *locationFull, NSError *error) {
        
    }];
    
}

#pragma mark - Public

- (void)reset{
    
    self.selectedLocation = nil;
    
    self.searchLocation = @"";
    
    [self createArrayLocation];
    
}

- (void)forceLocationTo:(Location *)location{
    
    self.selectedLocation = location;
    [self.delegate locationIsSelected:location];
    
}

@end