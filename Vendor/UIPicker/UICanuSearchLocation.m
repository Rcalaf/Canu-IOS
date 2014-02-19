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

static int const KHeightMax = 238;

@interface UICanuSearchLocation () <UICANULocationCellDelegate>

@property (nonatomic) BOOL isMap;
@property (nonatomic) BOOL isFirstTime;
@property (strong, nonatomic) NSMutableArray *arrayLocation;
@property (strong, nonatomic) NSMutableArray *arrayCellLocation;
@property (strong, nonatomic) UILabel *noResults;
@property (strong, nonatomic) UICanuButtonSignBottomBar *searchOnMap;

@end

@implementation UICanuSearchLocation

- (id)initWithFrame:(CGRect)frame ForMap:(BOOL)isMap{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isMap = isMap;
        
        self.isFirstTime = YES;
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = UIColorFromRGB(0xe9eeee);
        
        UIImageView *shadowDescription = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 6)];
        shadowDescription.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        [self addSubview:shadowDescription];
        
        UIImageView *shadowDescriptionReverse = [[UIImageView alloc]initWithFrame:CGRectMake(0, KHeightMax - 6, 320, 6)];
        shadowDescriptionReverse.image = [UIImage imageNamed:@"F1_Shadow_Description"];
        shadowDescriptionReverse.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:shadowDescriptionReverse];
        
        if (!_isMap) {
            self.searchOnMap = [[UICanuButtonSignBottomBar alloc]initWithFrame:CGRectMake(10, 10.0, 300, 47.0) andBlue:YES];
            [self.searchOnMap setTitle:NSLocalizedString(@"SEARCH ON THE MAP", nil) forState:UIControlStateNormal];
            [self.searchOnMap addTarget:self action:@selector(openTheMap) forControlEvents:UIControlEventTouchDown];
        }
        
        self.arrayCellLocation = [[NSMutableArray alloc]init];
        
        self.noResults = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 300, 47)];
        self.noResults.backgroundColor = [UIColor clearColor];
        self.noResults.textColor = UIColorFromRGB(0xabb3b7);
        self.noResults.text = NSLocalizedString(@"No results ...", nil);
        self.noResults.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        self.noResults.alpha = 0;
        [self addSubview:_noResults];
        
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
    
    if (_isMap) {
    
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = _searchLocation;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
        
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (error && error.code != 4) {
                NSLog(@"Error 4 %@",error);
            }
            
            [Location searchLocationMap:response Block:^(NSMutableArray *arrayLocation, NSError *error) {
                if (error) {
                    NSLog(@"Error %@",error);
                } else {
                    
                    self.arrayLocation = arrayLocation;
                    
                    [self showLocation];
                    
                }
            }];
    
        }];
        
    } else {
        [Location searchLocation:_currentLocation SearchWords:_searchLocation Block:^(NSMutableArray *arrayLocation, NSError *error) {
            if (error) {
                NSLog(@"Error %@",error);
            } else {
                
                self.arrayLocation = arrayLocation;
                
                [self showLocation];
                
            }
        }];
    }
    
}

- (void)showLocation{
    
    if (!_isMap) {
        [self.searchOnMap removeFromSuperview];
    }
    
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
        
        UICANULocationCell *cellLocation = [[UICANULocationCell alloc]initWithFrame:CGRectMake(10, 10 + i * (47 + 10), 300, 47) WithLocation:location];
        cellLocation.delegate = self;
        [self addSubview:cellLocation];
        [self.arrayCellLocation addObject:cellLocation];
        
        if (!_selectedLocation && !_isMap && _isFirstTime) {
            self.isFirstTime = NO;
            cellLocation.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
            self.selectedLocation = cellLocation.location;
            [self.delegate locationIsSelected:cellLocation.location];
        }
        
        if ([_selectedLocation.name isEqualToString:cellLocation.location.name]) {
            cellLocation.square.image = [UIImage imageNamed:@"F1_Add_Cell_Location_checked"];
        }
        
    }
    
    if ([_arrayLocation count] == 0) {
        self.noResults.alpha = 1;
        i++;
    }
    
    if (!_isMap) {
        
        if ([_searchLocation mk_isEmpty] || !_searchLocation) {
            [self.searchOnMap setTitle:NSLocalizedString(@"SEARCH ON THE MAP", nil) forState:UIControlStateNormal];
        } else {
            NSString *word = [NSString stringWithFormat:@"%@ \"%@\" %@",NSLocalizedString(@"SEARCH", nil),_searchLocation,NSLocalizedString(@"ON THE MAP", nil)];
            [self.searchOnMap setTitle:word forState:UIControlStateNormal];
        }
        
        self.searchOnMap.frame = CGRectMake(10, 10 + i * (47 + 10), 300, 47);
        [self addSubview:_searchOnMap];
    }
    
}

- (void)openTheMap{
    [self.delegate searchWithTheMap];
}

#pragma mark - Public

- (void)reset{
    
    self.selectedLocation = nil;
    
    self.searchLocation = @"";
    
    [self createArrayLocation];
    
}

- (void)addResult:(NSMutableArray *)response{
    
    self.arrayLocation = response;
    
    [self showLocation];
    
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
    
}

@end
