//
//  ChatTableViewController.m
//  CANU
//
//  Created by Roger Calaf on 19/11/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//
#import "AFCanuAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Message.h"
#import "UIChatCell.h"
#import "ChatTableViewController.h"
#import "AppDelegate.h"



@interface ChatTableViewController ()

@property (strong, nonatomic) NSTimer *autoUpdate;

@end

@implementation ChatTableViewController

@synthesize messages = _messages;
@synthesize activity = _activity;
@synthesize autoUpdate = _autoUpdate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithActivity:(Activity *)activity
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
      
        self.activity = activity;
        self.tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 402.5f + KIphone5Margin);
        self.tableView.backgroundView = nil;
       // self.tableView.backgroundColor = [UIColor whiteColor];
        //self.tableView.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:0.0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self reload:nil];
    //_autoUpdate = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reload:) userInfo:nil repeats:YES];
   // [_autoUpdate fire];
}

-(void) viewWillDisappear:(BOOL)animated
{
    //[_autoUpdate invalidate];
    [super viewWillDisappear:YES];
}

/*- (void)loadView{
    [super loadView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f + KIphone5Margin) style:UITableViewStyleGrouped];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:0.0];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload:(id)sender
{
    [self.activity messagesWithBlock:^(NSArray *messages, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            _messages = messages;
            [self.tableView reloadData];
            [self scrollToLast:nil];
        }
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)scrollToLast:(id)sender
{
    if ([_messages count] > 0) {

        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
   
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
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Message *message= [_messages objectAtIndex:indexPath.row];
    UIChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UIChatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
    
    //Calculate text area size
    cell.message.text = message.text;
    CGSize textSize = { 280.0, 10000.0 };
	CGSize size = [message.text sizeWithFont:[UIFont fontWithName:@"Lato-Regular" size:10.0]
					  constrainedToSize:textSize
						  lineBreakMode:UILineBreakModeWordWrap];
	size.width += (20.0f);
   
    [cell.message setFrame:CGRectMake(2.0f, 40.0f, size.width, size.height+10.0f)];

   // cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"chat_cell.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15]];
    
  //  NSLog(@"height: %f, width: %f",size.height,size.width);
    // Configure the cell...
    
   // cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"attendee_cell.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:20]];
    
    AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.user.userId == message.user.userId) {
       cell.textLabel.text = @"You";
    } else {
       cell.textLabel.text = message.user.userName;
       
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,message.user.profileImageUrl]];
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
    cell.textLabel.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(139.0 / 255.0) blue:(156.0 / 255.0) alpha: 1];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [_messages objectAtIndex:indexPath.row];
	NSString *text = [[_messages objectAtIndex:indexPath.row] text];
	CGSize  textSize = { 280.0, 10000.0 };
	CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Lato-Regular" size:10.0]
                   constrainedToSize:textSize
                       lineBreakMode:UILineBreakModeWordWrap];
	
    
    
	size.height += 55.0f;
   // NSLog(@"cell height: %f, width: %f",size.height,size.width);
	return size.height;
}

@end
