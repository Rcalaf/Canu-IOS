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
#import "LoaderAnimation.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "UIProfileView.h"
#import "ErrorManager.h"
#import "PhoneBook.h"
#import "Contact.h"

@interface AttendeesScrollViewController () <UIScrollViewDelegate,UICanuAttendeeCellScrollDelegate>

@property (nonatomic) UIScrollViewReverse *scrollview;
@property (nonatomic) NSMutableArray *arrayCell;
@property (nonatomic) Activity *activity;
@property (nonatomic) NSArray *attendees;
@property (nonatomic) NSArray *invitationUser;
@property (nonatomic) NSArray *invitationGhostuser;
@property (strong, nonatomic) NSMutableArray *allContact;
@property (nonatomic) LoaderAnimation *loaderAnimation;
@property (nonatomic) BOOL isReload;

@end

@implementation AttendeesScrollViewController

- (id)initWithFrame:(CGRect)frame andActivity:(Activity *)activity{
    self = [super init];
    if (self) {
        
        self.view.frame = frame;
        
        self.activity = activity;
        
        self.isReload = NO;
        
        self.arrayCell = [[NSMutableArray alloc]init];
        
        self.loaderAnimation = [[LoaderAnimation alloc]initWithFrame:CGRectMake((frame.size.width - 30) / 2, frame.size.height - 45, 30, 30) withStart:-20 andEnd:-100];
        [self.view addSubview:_loaderAnimation];
        
        self.scrollview = [[UIScrollViewReverse alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height -1)];
        self.scrollview.delegate = self;
        [self.view addSubview:_scrollview];
        
        [PhoneBook contactPhoneBookWithBlock:^(NSMutableArray *arrayContact, NSError *error) {
            
            if (error) {
                
            } else {
                
                self.allContact = arrayContact;
                
            }
            
            [NSThread detachNewThreadSelector:@selector(load)toTarget:self withObject:nil];
        }];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newY;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    // Reload Animation
    [self.loaderAnimation contentOffset:newY];
    
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
    
    self.isReload = YES;
    
    [self.loaderAnimation startAnimation];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollview.frame = CGRectMake(0, - 48, _scrollview.frame.size.width, _scrollview.frame.size.height);
    } completion:^(BOOL finished) {
        [self load];
    }];
    
}

- (void)load{
    
    [self.activity attendees:^(NSArray *attendees, NSArray *invitationUser, NSArray *invitationGhostuser, NSError *error) {
        
        if (error) {
            // Visual information of this error adding by Error Manager
            [[ErrorManager sharedErrorManager] visualAlertFor:error.code];
        } else {
            
            _attendees = attendees;
            _invitationUser = invitationUser;
            _invitationGhostuser = invitationGhostuser;
            
            [self showAttendees];
            
        }
        
        if (_isReload) {
            
            [UIView animateWithDuration:0.4 animations:^{
                self.scrollview.frame = CGRectMake( 0, -1, _scrollview.frame.size.width, _scrollview.frame.size.height);
            } completion:^(BOOL finished) {
                [self.loaderAnimation stopAnimation];
                
                self.isReload = NO;
                
            }];
        }
        
        [self.loaderAnimation stopAnimation];
        
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
    
    float heightContentScrollView = ([_attendees count] + [_invitationUser count] + [_invitationGhostuser count]) * (57 + 10) + 10;
    
    if (heightContentScrollView <= _scrollview.frame.size.height) {
        heightContentScrollView = _scrollview.frame.size.height + 1;
    }
    
    self.scrollview.contentSize = CGSizeMake(320, heightContentScrollView);
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
    int row = 0;
    
    for (int i = 0; i < [_attendees count]; i++) {
        
        User *user = [_attendees objectAtIndex:i];
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( row * (57 + 10) + 10 ) - 57, 300, 57) andUser:user orContact:nil];
        cell.delegate = self;
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        row ++;
        
    }
    
    for (int i = 0; i < [_invitationUser count]; i++) {
        
        User *user = [_invitationUser objectAtIndex:i];
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( row * (57 + 10) + 10 ) - 57, 300, 57) andUser:user orContact:nil];
        cell.alpha = 0.5;
        cell.delegate = self;
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        row ++;
        
    }
    
    for (int i = 0; i < [_invitationGhostuser count]; i++) {
        
        Contact *contact;
        
        NSString *phoneNumber = [_invitationGhostuser objectAtIndex:i];
        
        for (int y = 0; y < [_allContact count]; y++) {
            
            Contact *dataContact = [_allContact objectAtIndex:y];
            
            if ([phoneNumber isEqualToString:dataContact.convertNumber]) {
                contact = dataContact;
            }
            
        }
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( row * (57 + 10) + 10 ) - 57, 300, 57) andUser:nil orContact:contact];
        cell.alpha = 0.5;
        cell.delegate = self;
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        row ++;
        
    }
    
}

- (void)attendeeCellEventProfileView:(User *)user{
    
    UIProfileView *profileView = [[UIProfileView alloc] initWithUser:user WithBottomBar:YES AndNavigationchangement:NO OrTutorial:NO];
    [self.parentViewController.view addSubview:profileView];
    
    [profileView hideComponents:profileView.profileHidden];
    
    if (profileView.profileHidden) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Activity Attendees"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    } else {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Profile User View"];
        [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
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

- (void)dealloc{
    
    NSLog(@"Dealloc AttendeesScrollViewController");
    
}

@end
