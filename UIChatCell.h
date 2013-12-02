//
//  UIChatCell.h
//  CANU
//
//  Created by Roger Calaf on 20/11/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIChatCell : UITableViewCell

@property (strong, nonatomic) UITextView *message;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UIImageView *userPic;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@end
