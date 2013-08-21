//
//  UICanuAttendeeCell.m
//  CANU
//
//  Created by Roger Calaf on 21/08/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import "UICanuAttendeeCell.h"

@implementation UICanuAttendeeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attendee_cell.png"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIView Subviews

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(60.0f, 10.0f, 225.0f, 37.0f);
    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.textLabel.textColor = [UIColor colorWithRed:(26.0 / 255.0) green:(146.0 / 255.0) blue:(163.0 / 255.0) alpha: 1];
    self.textLabel.font = [UIFont fontWithName:@"Lato-Bold" size:13.0];
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.size.height = 37.0f;
    imageFrame.size.width = 37.0f;
    self.imageView.frame = imageFrame;
    
}
@end
