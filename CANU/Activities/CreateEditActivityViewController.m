//
//  CreateEditActivityViewController.m
//  CANU
//
//  Created by Vivien Cormier on 06/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "CreateEditActivityViewController.h"

#import "Activity.h"

@interface CreateEditActivityViewController ()

@end

#pragma mark - Lifecycle

@implementation CreateEditActivityViewController

- (void)loadView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    view.backgroundColor = backgroundColorView;
    self.view = view;
    
}

/**
 *  Create activity (local or tribe)
 *
 *  @param activity
 *
 *  @return
 */
- (id)initForCreate:(CANUCreateActivity)canuCreateActivity{
    
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

/**
 *  Edit a activity
 *
 *  @param activity
 *
 *  @return
 */
- (id)initForEdit:(Activity *)activity{
    
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
