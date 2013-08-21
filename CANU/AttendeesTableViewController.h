//
//  AttendeesTableViewController.h
//  CANU
//
//  Created by Roger Calaf on 21/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface AttendeesTableViewController : UITableViewController

@property (strong, nonatomic) Activity *activity;
@property (strong, nonatomic) NSArray *attendees;

@end
