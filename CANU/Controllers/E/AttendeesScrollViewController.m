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
@property (strong, nonatomic) UILabel *peoplesUnknowLabel;
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
        
        NSError *error = [PhoneBook checkPhoneBookAccess];
        
        if (!error) {
            [PhoneBook contactPhoneBookWithBlock:^(NSMutableArray *arrayContact, NSError *error) {
                
                if (error) {
                    
                } else {
                    
                    self.allContact = arrayContact;
                    
                }
                
                [NSThread detachNewThreadSelector:@selector(load)toTarget:self withObject:nil];
                
            }];
        } else {
            [NSThread detachNewThreadSelector:@selector(load)toTarget:self withObject:nil];
        }
        
    }
    return self;
}

- (NSMutableArray *)invits{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [_invitationGhostuser count]; i++) {
        
        NSString *phoneNumber = [_invitationGhostuser objectAtIndex:i];
        [array addObject:phoneNumber];
        
    }
    
    for (int i = 0; i < [_attendees count]; i++) {
        
        User *user = [_attendees objectAtIndex:i];
        [array addObject:user.phoneNumber];
        
    }
    
    for (int i = 0; i < [_invitationUser count]; i++) {
        
        User *user = [_invitationUser objectAtIndex:i];
        [array addObject:user.phoneNumber];
        
    }
    
    return array;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float newY;
    newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    // Reload Animation
    [self.loaderAnimation contentOffset:newY];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float newY = scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y);
    
    //Refresh
    
    if( newY <= -100.0f ){
        [NSThread detachNewThreadSelector:@selector(reload)toTarget:self withObject:nil];
    }
    
}

- (void)forceReload{
    [NSThread detachNewThreadSelector:@selector(load)toTarget:self withObject:nil];
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
    
    if (_peoplesUnknowLabel) {
        [self.peoplesUnknowLabel removeFromSuperview];
        self.peoplesUnknowLabel = nil;
    }
    
    NSInteger peoplesUnknows = 0;
    NSMutableArray *arrayContactRecognize = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [_invitationGhostuser count]; i++) {
        
        Contact *contact;
        
        NSString *phoneNumber = [_invitationGhostuser objectAtIndex:i];
        
        for (int y = 0; y < [_allContact count]; y++) {
            
            Contact *dataContact = [_allContact objectAtIndex:y];
            
            if ([phoneNumber isEqualToString:dataContact.convertNumber]) {
                contact = dataContact;
            }
            
        }
        
        if (contact) {
            [arrayContactRecognize addObject:contact];
        } else {
            peoplesUnknows += 1;
        }
        
    }
    
    float heightContentScrollView = ([_attendees count] + [_invitationUser count] + [arrayContactRecognize count]) * (55 + 5) + 5;
    
    if (heightContentScrollView <= _scrollview.frame.size.height) {
        heightContentScrollView = _scrollview.frame.size.height + 1;
    }
    
    self.scrollview.contentSize = CGSizeMake(320, heightContentScrollView);
    [self.scrollview setContentOffsetReverse:CGPointMake(0, 0)];
    
    int row = 0;
    
    for (int i = 0; i < [_attendees count]; i++) {
        
        User *user = [_attendees objectAtIndex:i];
        
        Contact *contact;
        
        for (int y = 0; y < [_allContact count]; y++) {
            
            Contact *dataContact = [_allContact objectAtIndex:y];
            
            if ([user.phoneNumber isEqualToString:dataContact.convertNumber]) {
                contact = dataContact;
            }
            
        }
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( row * (55 + 5) + 5 ) - 55, 300, 55) andUser:user orContact:contact];
        cell.delegate = self;
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        row ++;
        
    }
    
    for (int i = 0; i < [_invitationUser count]; i++) {
        
        User *user = [_invitationUser objectAtIndex:i];
        
        Contact *contact;
        
        for (int y = 0; y < [_allContact count]; y++) {
            
            Contact *dataContact = [_allContact objectAtIndex:y];
            
            if ([user.phoneNumber isEqualToString:dataContact.convertNumber]) {
                contact = dataContact;
            }
            
        }
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( row * (55 + 5) + 5 ) - 55, 300, 55) andUser:user orContact:contact];
        cell.alpha = 0.5;
        cell.delegate = self;
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        row ++;
        
    }
    
    for (int i = 0; i < [arrayContactRecognize count]; i++) {
        
        Contact *contact = [arrayContactRecognize objectAtIndex:i];
        
        UICanuAttendeeCellScroll *cell = [[UICanuAttendeeCellScroll alloc]initWithFrame:CGRectMake(10, _scrollview.contentSize.height - ( row * (55 + 5) + 5 ) - 55, 300, 55) andUser:nil orContact:contact];
        cell.alpha = 0.5;
        cell.delegate = self;
        [self.scrollview addSubview:cell];
        
        [_arrayCell addObject:cell];
        
        row ++;
        
    }
    
    if (peoplesUnknows > 0) {
        
        self.peoplesUnknowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _scrollview.contentSize.height - ( row * (55 + 5) + 5 ) - 55, 320, 55)];
        self.peoplesUnknowLabel.textAlignment = NSTextAlignmentCenter;
        self.peoplesUnknowLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        self.peoplesUnknowLabel.text = [NSString stringWithFormat:@"and %ld others peoples",(long)peoplesUnknows];
        self.peoplesUnknowLabel.textColor = UIColorFromRGB(0x2b4b58);
        self.peoplesUnknowLabel.alpha = 0.3f;
        [self.scrollview addSubview:_peoplesUnknowLabel];
        
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
