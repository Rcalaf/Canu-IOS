//
//  UICanuChatCellScroll.m
//  CANU
//
//  Created by Vivien Cormier on 13/12/2013.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuChatCellScroll.h"

#import "UIImageView+AFNetworking.h"

#import "AFCanuAPIClient.h"

#import "AppDelegate.h"

#import "Message.h"

@interface UICanuChatCellScroll ()

@property (nonatomic) UITextView *textMessage;

@end

@implementation UICanuChatCellScroll

- (id)initWithFrame:(CGRect)frame andMessage:(Message *)message
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        self.line = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 280, 1)];
        self.line.backgroundColor = UIColorFromRGB(0xd4e0e0);
        [self addSubview:_line];
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
        [avatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,message.user.profileImageUrl]] placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        [self addSubview:avatar];
        
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 10.0f, 128.0f, 25.0f)];
        if (appDelegate.user.userId == message.user.userId) {
            userName.text = @"You";
        } else {
            userName.text = message.user.userName;
            
        }
        userName.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
        userName.backgroundColor = UIColorFromRGB(0xfafafa);
        userName.textColor = UIColorFromRGB(0x1a8b9c);
        [self addSubview:userName];
        
        self.textMessage = [[UITextView alloc]initWithFrame:CGRectMake(40, 40, 234, 5)];
        self.textMessage.editable = NO;
        self.textMessage.scrollEnabled = NO;
        self.textMessage.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.textMessage.backgroundColor = UIColorFromRGB(0xfafafa);
        self.textMessage.textColor = UIColorFromRGB(0x2b4b58);
        self.textMessage.text = message.text;
        [self.textMessage sizeToFit];
        [self addSubview:_textMessage];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"d MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(240.0f, 10.0f, 50.0f, 10.0f)];
        if ([[self normalizedDateWithDate:message.date] isEqualToDate:[self normalizedDateWithDate:[NSDate date]]]) {
            time.text = [NSString stringWithFormat:@"%@",[timeFormatter stringFromDate:message.date]];
        }else{
            time.text = [NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:message.date],[timeFormatter stringFromDate:message.date]];
        }
        time.textAlignment = NSTextAlignmentRight;
        time.font = [UIFont fontWithName:@"Lato-Regular" size:8.0];
        time.backgroundColor = UIColorFromRGB(0xfafafa);
        time.textColor = UIColorFromRGB(0x6d6e7a);
        time.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [self addSubview:time];
        
    }
    return self;
}

- (float)heightContent{
    
    CGSize textViewSize = [self.textMessage sizeThatFits:CGSizeMake(self.textMessage.frame.size.width, FLT_MAX)];
    
    self.textMessage.frame = CGRectMake(_textMessage.frame.origin.x, _textMessage.frame.origin.y, _textMessage.frame.size.width, textViewSize.height + 1);
    
    float height = 0;
    
    height = 10 + 25 + 10 + _textMessage.frame.size.height + 10;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
    return height;
    
}

-(NSDate*)normalizedDateWithDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate: date];
    return [calendar dateFromComponents:components];
}

@end
