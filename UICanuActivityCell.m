//
//  UICanuActivityCell.m
//  CANU
//
//  Created by Roger Calaf on 03/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuActivityCell.h"
#import "AFCanuAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "Activity.h"
#import "User.h"

@implementation UICanuActivityCell

@synthesize activity = _activity;
@synthesize user = _user;
@synthesize actionButton = _actionButton;
@synthesize userName = _userName;
@synthesize day = _day;
@synthesize timeStart = _timeStart;
@synthesize timeEnd = _timeEnd;
@synthesize location = _location;
//@synthesize userPic = _userPic;
//@synthesize status = _status;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

/*- (void) setStatus:(UICanuActivityCellStatus)status{
    _status = status;
    NSLog(@"setting new status");
    //[self setNeedsDisplay];
}*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier activity:(Activity *)activity
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.activity = activity;
        
        self.textLabel.text = activity.title;
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_cell.png"]];
        
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,cell.activity.user.profileImageUrl]];
        //[cell.userPic setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        
       // _userPic = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 91.0, 25.0, 25.0)];
       // [_userPic setImageWithURL:self.activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
       // [self.contentView addSubview:_userPic];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(37.0f, 99.0f, 128.0f, 25.0f)];
        _userName.text = [NSString stringWithFormat:@"%@ %@",self.activity.user.firstName,activity.user.lastName];
        _userName.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
        _userName.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0f];
        
        //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        _userName.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [self.contentView addSubview:_userName];
        
        _location = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 65.0f, 200.0f, 12.0f)];
        _location.text = [self.activity locationDescription];
        _location.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
        _location.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
        _location.backgroundColor =  [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0f];
        [self.contentView addSubview:_location];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"HH:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        
        _timeStart = [[UILabel alloc] initWithFrame:CGRectMake(220.0f, 107.0f, 44.0f, 12.0f)];
        _timeStart.text = [timeFormatter stringFromDate:self.activity.start];
        _timeStart.font = [UIFont fontWithName:@"Lato-Bold" size:11.0];
        _timeStart.backgroundColor = _userName.backgroundColor;
        //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _timeStart.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
        [self.contentView addSubview:_timeStart];
        
        _timeEnd = [[UILabel alloc] initWithFrame:CGRectMake(250.0f, 106.5f, 44.0f, 12.0f)];
        _timeEnd.text = [NSString stringWithFormat:@" - %@",[timeFormatter stringFromDate:self.activity.end]];
        _timeEnd.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
        _timeEnd.backgroundColor = _userName.backgroundColor;
        //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _timeEnd.textColor = [UIColor colorWithRed:(182.0 / 255.0) green:(182.0 / 255.0) blue:(188.0 / 255.0) alpha: 1];
        [self.contentView addSubview:_timeEnd];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"d MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        _day = [[UILabel alloc] initWithFrame:CGRectMake(180.0f, 106.5f, 30.0f, 12.0f)];
        _day.text = [dateFormatter stringFromDate:self.activity.start];
        _day.font = [UIFont fontWithName:@"Lato-Regular" size:9.0];
        _day.backgroundColor = _userName.backgroundColor;
        //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _day.textColor = _timeStart.textColor;
        [self.contentView addSubview:_day];
        
       
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame = CGRectMake(243.0f, 29.0f, 47.0f, 47.0f);

        if ([self.reuseIdentifier isEqualToString:[NSString stringWithFormat:@"Canu Cell %u",UICanuActivityCellGo]] ) {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_yes.png"] forState:UIControlStateNormal];
    
        } else if ([self.reuseIdentifier isEqualToString:[NSString stringWithFormat:@"Canu Cell %u",UICanuActivityCellToGo]]){
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_go.png"] forState:UIControlStateNormal];
        } else {
            [self.actionButton setImage:[UIImage imageNamed:@"feed_action_edit.png"] forState:UIControlStateNormal];
        }

        [self.contentView addSubview:_actionButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setTransform:CGAffineTransformMakeRotation(M_PI)];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(15.0f, 26.0f, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.textLabel.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0f];
    self.textLabel.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
    self.textLabel.font = [UIFont fontWithName:@"Lato-Bold" size:22.0];
    
    self.imageView.frame = CGRectMake(5.0, 100.0, 25.0, 25.0);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,self.activity.user.profileImageUrl]];
    [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
}
@end
