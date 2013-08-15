//
//  ActivitiesFeedViewController.m
//  CANU
//
//  Created by Roger Calaf on 17/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuActivityCell.h"
#import "ActivitiesFeedViewController.h"
#import "Activity.h"
#import "NewActivityViewController.h"


@interface ActivitiesFeedViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableActivities;

- (void)reload:(id)sender;
@end

@implementation ActivitiesFeedViewController{
@private
    NSArray *_activities;
}

@synthesize tableActivities = _tableActivities;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    self.tableActivities = [[UITableView alloc] initWithFrame:CGRectMake(1.0f, 0.0f, 310.0f, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableActivities.backgroundView = nil;
    self.tableActivities.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
    
    //UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    

    self.tableActivities.dataSource = self;
    self.tableActivities.delegate = self;
   
    [self.view addSubview:self.tableActivities]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  [self reload:nil];
 // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   [self reload:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload:(id)sender
{
    //[_activityIndicatorView startAnimating];
   // NSLog(@"reload?");
    
    [Activity publicFeedWithBlock:^(NSArray *activities, NSError *error) {
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            _activities = activities;
            [_tableActivities reloadData];
        }
        
        // self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    // NSLog(@"Loading");
    
    
}

-(void)triggerCellAction:(id)recognizer
{
    UICanuActivityCell *cell = (UICanuActivityCell *)[[[recognizer view] superview] superview];
    NewActivityViewController *eac;

    
    if (cell.activity.status == UICanuActivityCellGo) {
        [cell.activity dontAttendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
               //_activities = activities;
              //[self.tableActivities reloadData];
                
            }
        }];
    }
    if (cell.activity.status == UICanuActivityCellEditable) {
        eac = [[NewActivityViewController alloc] init];
        eac.activity = cell.activity;
        NSLog(@"loc: %@",eac.activity.location);
        [self presentViewController:eac animated:YES completion:nil];
    }
    
    if (cell.activity.status == UICanuActivityCellToGo) {
        [cell.activity attendWithBlock:^(NSArray *activities, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
               //_activities = activities;
               // [self.tableActivities reloadData];
            }
        }];
    }
    
    //NSLog(@"%lu", (unsigned long)cell.activity.activityId);
    [self reload:nil];
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



/*
 - (UICanuActivityCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Cell";
 
 UICanuActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (!cell) {
 cell = [[UICanuActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
 }
 
 Activity *activity= [_activities objectAtIndex:indexPath.row];
 cell.textLabel.text = activity.title;
 
 return cell;
 }*/

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
        
        cell.textLabel.text = activity.title;
        cell.location.text = activity.locationDescription;
        cell.userName.text = [NSString stringWithFormat:@"%@ %@",activity.user.firstName, activity.user.lastName];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"dd MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        cell.day.text = [dateFormatter stringFromDate:activity.start];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        cell.timeStart.text = [timeFormatter stringFromDate:activity.start];
        cell.timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:activity.end]];
        //[cell setNeedsDisplay];
    }
    
    //NSLog(@"%@",cell.reuseIdentifier);
    //cell.activity = activity;
    // NSLog(@"%u",cell.activity.status);
    //cell.textLabel.text = activity.title;
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




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[_activities];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        Activity *activity= [_activities objectAtIndex:indexPath.row];
        [activity removeActivityFromUserWithBlock:^(NSError *error) {
            if (!error){
                [self reload:nil];
            }
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.5f;
}

@end
