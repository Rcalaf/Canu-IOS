//
//  AttendeesScrollViewController.m
//  CANU
//
//  Created by Vivien Cormier on 12/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "AttendeesScrollViewController.h"

#import "UICanuAttendeeCellScroll.h"

#import "User.h"

#import "UIScrollViewReverse.h"
#import "Activity.h"

@interface AttendeesScrollViewController () <UIScrollViewDelegate>

@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSMutableArray *arrayCell;

@end

@implementation AttendeesScrollViewController

@synthesize activity = _activity;
@synthesize attendees = _attendees;

- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        
        self.view.frame = frame;
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollview.delegate = self;
        [self.view addSubview:_scrollview];
        
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newX,newY;
    
    newX = scrollView.contentOffset.x;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    // Reload Animation
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newX,newY;
    
    newX = scrollView.contentOffset.x;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= -100.0f ){
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
    }
    
}

- (void)reload{
    
    [self.activity attendees:^(NSArray *attendees, NSError *error) {
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            _attendees = attendees;
            
            [self showAttendees];
            
        }

//            Si le loader tourne on le stop
//            if (self.refreshControl.refreshing) {
//                [self.refreshControl endRefreshing];
//            }
        
    }];
    
}

- (void)showAttendees{
    
    if ([_arrayCell count] != 0 ) {
        
        for (int i = 0; i < [_arrayCell count]; i++) {
            
            UICanuAttendeeCellScroll *cell = [_arrayCell objectAtIndex:i];
            [cell removeFromSuperview];
            cell = nil;
            
        }
        
        [_arrayCell removeAllObjects];
        
    }
    
    float heightContentScrollView = [_attendees count] * (120 + 10) + 10;
    
    if (heightContentScrollView <= _scrollview.frame.size.height) {
        heightContentScrollView = _scrollview.frame.size.height + 1;
    }
    
    self.scrollview.contentSize = CGSizeMake(320, heightContentScrollView);
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
    for (int i = 0; i < [_attendees count]; i++) {
        
        User *user = [_attendees objectAtIndex:i];
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( i * (57 + 10) + 10 ) - 57, 300, 57) andUser:user];
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
    }
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
