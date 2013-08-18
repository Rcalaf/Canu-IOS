//
//  UICanuActivityCell.h
//  CANU
//
//  Created by Roger Calaf on 03/07/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UICanuActivityCellEditable = 0,
    UICanuActivityCellGo = 1,
    UICanuActivityCellToGo = 2,
} UICanuActivityCellStatus;

@class Activity;
@class User;

@interface UICanuActivityCell : UITableViewCell

@property (strong, nonatomic) Activity *activity;
@property (strong, nonatomic) User *user;
//@property (strong, nonatomic) IBOutlet UIView *actionButton;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *day;
@property (strong, nonatomic) UILabel *timeStart;
@property (strong, nonatomic) UILabel *timeEnd;
@property (strong, nonatomic) UILabel *location;
@property (strong, nonatomic) UIImageView *userPic;


//@property (nonatomic) UICanuActivityCellStatus status;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier activity:(Activity *)activity;


@end
