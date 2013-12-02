//
//  ChatTableViewController.h
//  CANU
//
//  Created by Roger Calaf on 19/11/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ChatTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) Activity *activity;

- (id)initWithActivity:(Activity *)activity;
- (void)reload:(id)sender;
- (void)scrollToLast:(id)sender;

@end
