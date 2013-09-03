//
//  ActivityTableViewController.m
//  CANU
//
//  Created by Roger Calaf on 26/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "Activity.h"

#import "AFCanuAPIClient.h"
#import "UIImageView+AFNetworking.h"

#import "UICanuActivityCell.h"

#import "AppDelegate.h"
#import "ActivityTableViewController.h"
#import "NewActivityViewController.h"
#import "DetailActivityViewController.h"

#import "ActivitiesFeedViewController.h"
#import "UserProfileViewController.h"


@interface ActivityTableViewController ()
- (void)reload:(id)sender;
@end

@implementation ActivityTableViewController

@synthesize activities = _activities;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f + KIphone5Margin) style:UITableViewStyleGrouped];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    [self.tableView setTransform:CGAffineTransformMakeRotation(M_PI)];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 311.5);
    
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    //[refresh setTransform:CGAffineTransformMakeRotation(M_PI)];
    [refresh addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self reload:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.activities = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reload:(id)sender
{
    //NSLog(@"%@",[self.parentViewController class]);

    if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) {
        AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [Activity publicFeedWithCoorindate:appDelegate.currentLocation WithBlock:^(NSArray *activities, NSError *error) {
            
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _activities = activities;
              
                [self.tableView reloadData];
            }
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }];
    }else{
        [[(UserProfileViewController *)self.parentViewController user] userActivitiesWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                //NSLog(@"%@",activities);
                _activities = activities;
                [self.tableView reloadData];
            }
            if (self.refreshControl.refreshing) {
                [self.refreshControl endRefreshing];
            }
        }];
    }

    
    
}

-(void)triggerCellAction:(id)recognizer
{
    UICanuActivityCell *cell = (UICanuActivityCell *)[[[recognizer view] superview] superview];
    NewActivityViewController *eac;
    

    if (cell.activity.status == UICanuActivityCellGo) {
        cell.loadingIndicator.hidden = NO;
        [cell.loadingIndicator startAnimating];
        cell.actionButton.hidden = YES;
        [cell.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _activities = activities;
                if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) [self.tableView reloadData];
            }
            if ([self.parentViewController isKindOfClass:[UserProfileViewController class]]) [self reload:nil];
            //
            //cell.loadingIndicator.hidden = YES;
            //cell.actionButton.hidden = NO;
            
        }];
    }
    if (cell.activity.status == UICanuActivityCellEditable) {
        eac = [[NewActivityViewController alloc] init];
        eac.activity = cell.activity;
        //NSLog(@"loc: %@",eac.activity.location);
        [self presentViewController:eac animated:YES completion:nil];
    }
    
    if (cell.activity.status == UICanuActivityCellToGo) {
        cell.loadingIndicator.hidden = NO;
        [cell.loadingIndicator startAnimating];
        cell.actionButton.hidden = YES;
        [cell.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                _activities = activities;
                if ([self.parentViewController isKindOfClass:[ActivitiesFeedViewController class]]) [self.tableView reloadData];
            }
            if ([self.parentViewController isKindOfClass:[UserProfileViewController class]]) [self reload:nil];
            
            //[self reload:nil];
             //cell.loadingIndicator.hidden = YES;
            //cell.actionButton.hidden = NO;
            
        }];
    }
    
    //NSLog(@"%lu", (unsigned long)cell.activity.activityId);
    //[self reload:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_activities count];
}

- (UICanuActivityCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"";
    
    Activity *activity= [_activities objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Canu Cell %u",activity.status];
    
    UICanuActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UICanuActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier activity:activity];
        
    } else{
        
        cell.activity = activity;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,cell.activity.user.profileImageUrl]];
        [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        // [cell.userPic setImageWithURL:cell.activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        
        cell.textLabel.text = activity.title;
        cell.location.text = activity.locationDescription;
        //cell.userName.text = [NSString stringWithFormat:@"%@ %@",activity.user.firstName, activity.user.lastName];
         cell.userName.text = activity.user.userName;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"d MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        cell.day.text = [dateFormatter stringFromDate:activity.start];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        cell.timeStart.text = [timeFormatter stringFromDate:activity.start];
        cell.timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:activity.end]];
        
        [cell.loadingIndicator stopAnimating];
        cell.loadingIndicator.hidden = YES;
        cell.actionButton.hidden = NO;
    }
    
    UITapGestureRecognizer *cellAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerCellAction:)];
    [cell.actionButton addGestureRecognizer:cellAction];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    DetailActivityViewController *davc = [[DetailActivityViewController alloc] init];
    davc.activity = [_activities objectAtIndex:indexPath.row];
    [self presentViewController:davc animated:YES completion:nil];
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.5f;
}

@end
