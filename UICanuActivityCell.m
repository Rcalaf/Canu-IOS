//
//  UICanuActivityCell.m
//  CANU
//
//  Created by Roger Calaf on 03/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuActivityCell.h"
#import "UIImageView+AFNetworking.h"
#import "Activity.h"

@implementation UICanuActivityCell

@synthesize activity = _activity;
@synthesize actionButton = _actionButton;
@synthesize status = _status;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void) setStatus:(UICanuActivityCellStatus)status{
    _status = status;
    NSLog(@"setting new status");
    [self setNeedsDisplay];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier activity:(Activity *)activity
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.activity = activity;
        //self.status = status;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        backgroundView.backgroundColor = [UIColor colorWithRed:(231.0 / 255.0) green:(231.0 / 255.0) blue:(231.0 / 255.0) alpha: 1];
        self.backgroundView = backgroundView;
        
        UIView *userContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 85.0f, 168.0f, 35.0f)];
        userContentView.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0f];
        
        UIImageView *userPic = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 25.0, 25.0)];
        [userPic setImageWithURL:activity.user.profileImageUrl placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
        [userContentView addSubview:userPic];
        
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, 128.0f, 35.0f)];
        userName.text = [NSString stringWithFormat:@"%@ %@",activity.user.firstName,activity.user.lastName];
        userName.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        userName.backgroundColor = userContentView.backgroundColor;
        //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        userName.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [userContentView addSubview:userName];
        [self.backgroundView addSubview:userContentView];
        
        
        UIView *timeDayContent = [[UIView alloc] initWithFrame:CGRectMake(169.0f, 85.0f, 87.0f, 35.0f)];
        timeDayContent.backgroundColor = userContentView.backgroundColor;
        
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
        timeFormatter.dateFormat = @"hh:mm";
        [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
      
        
        UILabel *timeFrame = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 20.0f, 82.0f, 12.0f)];
        timeFrame.text = [timeFormatter stringFromDate:[self.activity startDate]];//[NSString stringWithFormat:@"%d:%d - %d:%d",20,0,20,30];
        timeFrame.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
        timeFrame.backgroundColor = userContentView.backgroundColor;
        //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        timeFrame.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [timeDayContent addSubview:timeFrame];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat = @"dd MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 62.0f, 12.0f)];
        day.text = [dateFormatter stringFromDate:[self.activity startDate]];
        day.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
        day.backgroundColor = userContentView.backgroundColor;
        //userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        day.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
        [timeDayContent addSubview:day];
        
        [self.backgroundView addSubview:timeDayContent];
        
        UIView *descriptionViewContent = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 84.0f)];
        descriptionViewContent.backgroundColor = userContentView.backgroundColor;
        UIImage *locationImage = [UIImage imageNamed:@"create_location.png"];
        UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(-5.0f, 43.0f, locationImage.size.width, locationImage.size.width)];
        locationIcon.image = locationImage;
        
        //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"create_location.png"]];
        
        [descriptionViewContent addSubview:locationIcon];
        UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 60.0f, 200.0f, 12.0f)];
        location.text = [self.activity locationDescription];
        location.font = [UIFont fontWithName:@"Lato-Regular" size:11.0];
        location.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
        location.backgroundColor = userContentView.backgroundColor;
        [descriptionViewContent addSubview:location];
        [self.backgroundView addSubview:descriptionViewContent];
        
        self.actionButton = [[UIView alloc] initWithFrame:CGRectMake(256.5f, 84.5f, 42.5f, 34.5f)];
        UIImageView *buttonIcon;
        if ([self.reuseIdentifier isEqualToString:[NSString stringWithFormat:@"Canu Cell %u",UICanuActivityCellGo]] ) {
            self.actionButton.backgroundColor = [UIColor colorWithRed:(162.0 / 255.0) green:(203.0 / 255.0) blue:(208.0 / 255.0) alpha: 1];
            buttonIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_gogoing.png"]];
        } else if ([self.reuseIdentifier isEqualToString:[NSString stringWithFormat:@"Canu Cell %u",UICanuActivityCellToGo]]){
            self.actionButton.backgroundColor = [UIColor colorWithRed:(59.0 / 255.0) green:(194.0 / 255.0) blue:(141.0 / 255.0) alpha: 1];
            buttonIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_go.png"]];
        } else {
            self.actionButton.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(221.0 / 255.0) blue:(32.0 / 255.0) alpha: 1];
            buttonIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_edit.png"]];
        }
                   buttonIcon.frame = CGRectMake(0.0f, -5.0f, buttonIcon.image.size.width, buttonIcon.image.size.height);
        [self.actionButton addSubview:buttonIcon];
        
        /*self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame = CGRectMake(256.5f, 85.0f, 43.5f, 35.0f);
        self.actionButton.backgroundColor = */
        self.actionButton.userInteractionEnabled = YES;
        
       // [self.backgroundView addSubview:_actionButton];
        [self.contentView addSubview:_actionButton];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

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
    self.textLabel.frame = CGRectMake(16.5f, 24.0f, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.textLabel.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    self.textLabel.textColor = [UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1];
    self.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:22.0];
}
@end
