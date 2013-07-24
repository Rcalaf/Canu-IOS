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


@interface ActivitiesFeedViewController ()

@property (strong, nonatomic) UITableView *tableView;

- (void)reload:(id)sender;
@end

@implementation ActivitiesFeedViewController{
@private
NSArray *_activities;
__strong UIActivityIndicatorView *_activityIndicatorView;

}

@synthesize tableView = _tableview;

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(1.0f, 0.0f, 310.0f, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload:nil];
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
    [_activityIndicatorView startAnimating];
    
    [Activity publicFeedWithBlock:^(NSArray *activities, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            //NSLog(@"%@",activities);
            _activities = activities;
            [self.tableView reloadData];
        }
        
        [_activityIndicatorView stopAnimating];
        // self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    // NSLog(@"Loading");
    
    
}

-(void)triggerCellAction:(id)recognizer
{
    UICanuActivityCell *cell = (UICanuActivityCell *)[[[recognizer view] superview] superview];
    NewActivityViewController *eac = [[NewActivityViewController alloc] init];
    eac.activity = cell.activity;
    [self presentViewController:eac animated:YES completion:nil];
    //NSLog(@"%lu", (unsigned long)cell.activity.activityId);
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
    static NSString *CellIdentifier = @"Canu Cell";
    
    Activity *activity= [_activities objectAtIndex:indexPath.row];
    
    UICanuActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UICanuActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier Status:activity.status activity:activity];
    }
    
    //cell.activity = activity;
    cell.textLabel.text = activity.title;
    UITapGestureRecognizer *cellAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggerCellAction:)];
    //cellAction.delegate = self;
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
