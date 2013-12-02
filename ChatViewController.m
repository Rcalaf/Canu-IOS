//
//  ChatViewController.m
//  CANU
//
//  Created by Roger Calaf on 19/11/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewController.h"
#import "UICanuTextField.h"

@interface ChatViewController () <UITextFieldDelegate>

@property (strong, nonatomic) ChatTableViewController *chatTableViewController;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UITextField *textMessage;
@property (strong, nonatomic) UIView *controlsOutBox;

- (IBAction)sendMessage:(id)sender;

@end

@implementation ChatViewController

@synthesize chatTableViewController = _chatTableViewController;
@synthesize activity = _activity;
@synthesize textMessage = _textMessage;
@synthesize sendButton = _sendButton;
@synthesize controlsOutBox = _controlsOutBox;

- (IBAction)sendMessage:(id)sender
{
    NSString *message = _textMessage.text;
    _textMessage.text = nil;
    if ([message length] != 0) {
        [_activity newMessage:message WithBlock:^(NSError *error){
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
            } else {
                [_chatTableViewController reload:nil];
            }

        }];
    }
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reload
{
    [_chatTableViewController reload:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithActivity:(Activity *)activity
{
    self = [super init];
    if (self) {
        self.activity = activity;
        //self.view.frame = CGRectMake(10.0f, 265.0f, 300.0f, 200.0f);
        self.view.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0];
        _chatTableViewController = [[ChatTableViewController alloc] initWithActivity:activity];
        [self addChildViewController:_chatTableViewController];
        [self.view addSubview:_chatTableViewController.view];
        //self.view.backgroundColor = [UIColor greenColor];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0];
        _sendButton.frame = CGRectMake(179.0f, 1.5f, 62.0f, 34.0f);
        _sendButton.backgroundColor = [UIColor colorWithRed:28.0f/255.0f green:165.0f/255.0f blue:195.0f/255.0f alpha:1.0];
       [_sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        _textMessage = [[UICanuTextField alloc] initWithFrame:CGRectMake(1.5f, 1.5f, 167.0f, 34.0f)];
        _textMessage.placeholder = @"Write a message...";
        //_textMessage.font = [UIFont fontWithName:@"Lato-Bold" size:11.0];
        [_textMessage setReturnKeyType:UIReturnKeyGo];
        _textMessage.delegate = self;
        
        
        _controlsOutBox = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 402.5 + KIphone5Margin, 320.0f, 57.0f)];
        _controlsOutBox.backgroundColor = [UIColor colorWithRed:(241.0f/255.0f) green:(241.0f/255.0f) blue:(241.0f/255.0f) alpha:1.0f];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0.0, 0.0, 57.0, 57.0)];
        [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [_controlsOutBox addSubview:backButton];
        
        UIView *controls = [[UIView alloc] initWithFrame:CGRectMake(67.0f, 10.0f, 243.0f, 37.0f)];
        controls.backgroundColor = [UIColor whiteColor];
        
        [controls addSubview:_sendButton];
        [controls addSubview:_textMessage];
        
        [_controlsOutBox addSubview: controls];
        [self.view addSubview:_controlsOutBox];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textMessage resignFirstResponder];
    NSLog(@"touches ended");
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        _controlsOutBox.frame =CGRectMake(0.0f, 186.5f  + KIphone5Margin, _controlsOutBox.frame.size.width, _controlsOutBox.frame.size.height);
        _chatTableViewController.tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 186.5f + KIphone5Margin);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        _controlsOutBox.frame =CGRectMake(0.0f, 402.5f  + KIphone5Margin, _controlsOutBox.frame.size.width, _controlsOutBox.frame.size.height);
        _chatTableViewController.tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 402.5f + KIphone5Margin);
    }];
}

@end
