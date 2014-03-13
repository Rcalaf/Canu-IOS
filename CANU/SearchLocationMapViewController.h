//
//  SearchLocationMapViewController.h
//  CANU
//
//  Created by Vivien Cormier on 18/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;

@interface SearchLocationMapViewController : UIViewController

@property (retain) id delegate;
@property (strong, nonatomic) Location *selectedLocation;

- (id)initWithLocation:(Location *)location;

- (void)searchAnnotionWithLocation:(Location *)location;

@end

@protocol SearchLocationMapViewControllerDelegate <NSObject>

@required

- (void)locationIsSelectedByMap:(Location *)location;

- (void)closeTheMap;

@end
