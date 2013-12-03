//
//  UIChatCell.m
//  CANU
//
//  Created by Roger Calaf on 20/11/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UIChatCell.h"

@implementation UIChatCell

@synthesize message = _message;
@synthesize date = _date;
@synthesize userPic = _userPic;
@synthesize backgroundImageView = _backgroundImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_cell.png"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.textLabel setTextColor:[UIColor colorWithRed:(26.0 / 255.0) green:(139.0 / 255.0) blue:(156.0 / 255.0) alpha: 1]];
       
        _message = [[UITextView alloc] init];
        [self.message setFont:[UIFont fontWithName:@"Lato-Regular" size:15.0]];
        [self.message setTextColor:[UIColor colorWithRed:(109.0 / 255.0) green:(110.0 / 255.0) blue:(122.0 / 255.0) alpha: 1]];
        [self.message setBackgroundColor:[UIColor colorWithRed:(250.0 / 255.0) green:(250.0 / 255.0) blue:(250.0 / 255.0) alpha: 1]];
        [self.message setEditable:NO];
        [self.message setScrollEnabled:NO];
		[self.message sizeToFit];
		[self.contentView addSubview:self.message];
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
    self.textLabel.frame = CGRectMake(40.0f, 15.0f, 220.0f, self.textLabel.frame.size.height);
    self.textLabel.backgroundColor = [UIColor colorWithRed:(250.0/255.0) green:(250.0/255.0) blue:(250.0/255.0) alpha:1.0f];
    self.textLabel.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(139.0 / 255.0) blue:(156.0 / 255.0) alpha: 1];
    self.textLabel.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
    
    self.imageView.frame = CGRectMake(10.0, 10.0, 25.0, 25.0);
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAFCanuAPIBaseURLString,self.activity.user.profileImageUrl]];
//    [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_username.png"]];
}

@end
