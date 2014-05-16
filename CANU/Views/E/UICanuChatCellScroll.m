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
#import "UserManager.h"
#import "ProfilePicture.h"
#import "Message.h"
#import "NSDate+TimeAgo.h"

@interface UICanuChatCellScroll ()

@property (nonatomic) BOOL isFirst;
@property (nonatomic) BOOL isLast;
@property (nonatomic) BOOL addTime;
@property (nonatomic, strong) UIImageView *arrowBackgroundMessage;
@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UITextView *textMessage;
@property (nonatomic, strong) UIImageView *backgroundMessage;

@end

@implementation UICanuChatCellScroll

- (id)initWithFrame:(CGRect)frame andMessage:(Message *)message addTime:(BOOL)addTime isFirst:(BOOL)isFirst isLast:(BOOL)isLast isTheUser:(BOOL)isTheUser{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.addTime = addTime;
        self.isFirst = isFirst;
        self.isLast = isLast;
        self.isTheUser = isTheUser;
        
        self.backgroundMessage = [[UIImageView alloc]initWithFrame:CGRectMake(55, 1, 225, 100)];
        self.backgroundMessage.image = [[UIImage imageNamed:@"E_Message_background"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:5.0f];
        [self addSubview:_backgroundMessage];
        
        self.textMessage = [[UITextView alloc]initWithFrame:CGRectMake(55 + 5, 0, 234 - 10, 5)];
        self.textMessage.editable = NO;
        self.textMessage.scrollEnabled = NO;
        self.textMessage.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.textMessage.backgroundColor = [UIColor clearColor];
        self.textMessage.textColor = UIColorFromRGB(0x2b4b58);
        self.textMessage.text = message.text;
        [self addSubview:_textMessage];
        
        if (isFirst) {
            
            if (!isTheUser) {
                self.profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 35, 35)];
                [self.profilePicture setImageWithURL:message.user.profileImageUrl placeholderImage:[ProfilePicture defaultProfilePicture35]];
                self.profilePicture.clipsToBounds = YES;
                [self addSubview:_profilePicture];
                [self setRoundedView:_profilePicture];
                
                // Stroke profile picture
                UIImageView *strokePicture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
                strokePicture.image = [UIImage imageNamed:@"All_stroke_profile_picture_35"];
                [self.profilePicture addSubview:strokePicture];
            }
            
            self.arrowBackgroundMessage = [[UIImageView alloc]initWithFrame:CGRectMake(55 - 5, 10, 6, 11)];
            self.arrowBackgroundMessage.image = [UIImage imageNamed:@"E_Message_background_arrow"];
            [self addSubview:_arrowBackgroundMessage];
            
        }
        
        if (isLast || addTime) {
            
            if (!isTheUser && !addTime) {
                UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(55 + 1, 8, 200, 12)];
                username.backgroundColor = backgroundColorView;
                username.textColor = UIColorFromRGB(0x2b4b58);
                username.alpha = 0.3;
                username.text = message.user.userName;
                username.font = [UIFont fontWithName:@"Lato-Regular" size:10];
                [self addSubview:username];
            }
            
            UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(55 + 25, 8, 200, 12)];
            time.backgroundColor = backgroundColorView;
            time.textColor = UIColorFromRGB(0x2b4b58);
            time.textAlignment = NSTextAlignmentRight;
            time.alpha = 0.3;
            time.font = [UIFont fontWithName:@"Lato-Regular" size:10];
            [self addSubview:time];
            
            if ([message.date mk_differenceInDaysToDate:[NSDate date]] == 0) {
                time.text = [message.date timeAgo];
            } else {
                time.text = [NSString stringWithFormat:@"%@ %@",[self timeWithDate:message.date],[self dayWithDate:message.date]];
            }
            
        }
        
    }
    return self;
}

- (float)heightContent{
    
    CGSize textViewSize = [self.textMessage sizeThatFits:CGSizeMake(self.textMessage.frame.size.width, FLT_MAX)];
    CGSize textViewSizeHeight = [self.textMessage sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
    
    int width = self.textMessage.frame.size.width;
    
    if (textViewSizeHeight.height == textViewSize.height) {
        CGSize sizeOfText = [self.textMessage.text sizeWithFont:self.textMessage.font constrainedToSize:CGSizeMake(self.textMessage.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByClipping];
        width = sizeOfText.width + 10 + 1;
        if (!IS_OS_7_OR_LATER) {
            width += 5;
        }
    }
    
    self.backgroundMessage.frame = CGRectMake(_backgroundMessage.frame.origin.x, _backgroundMessage.frame.origin.y, width + 10, textViewSize.height + 3);
    
    self.textMessage.frame = CGRectMake(_textMessage.frame.origin.x, _textMessage.frame.origin.y + 2, width, textViewSize.height + 1);
    
    float height = 0;
    
    height = textViewSize.height + 4;
    
    if (_isTheUser) {
        self.backgroundMessage.frame = CGRectMake(300 - 10 - _backgroundMessage.frame.size.width, _backgroundMessage.frame.origin.y, _backgroundMessage.frame.size.width, _backgroundMessage.frame.size.height);
        self.textMessage.frame = CGRectMake(300 - 10 - 5 - _textMessage.frame.size.width, _textMessage.frame.origin.y, _textMessage.frame.size.width, _textMessage.frame.size.height);
        if (_isFirst) {
            self.arrowBackgroundMessage.frame = CGRectMake(300 - 10 - 1, height - 11 - 12, 6, 11);
            self.arrowBackgroundMessage.transform = CGAffineTransformMakeRotation(M_PI);
        }
    } else {
        if (_isFirst) {
            self.profilePicture.frame = CGRectMake(10, height - 35, 35, 35);
            self.arrowBackgroundMessage.frame = CGRectMake(55 - 5, height - 11 - 12, 6, 11);
        }
    }
    
    if (_isLast || _addTime) {
        self.backgroundMessage.frame = CGRectMake(_backgroundMessage.frame.origin.x, _backgroundMessage.frame.origin.y + 12 + 10, _backgroundMessage.frame.size.width, _backgroundMessage.frame.size.height);
        self.textMessage.frame = CGRectMake(_textMessage.frame.origin.x, _textMessage.frame.origin.y + 12 + 10, _textMessage.frame.size.width, _textMessage.frame.size.height);
        if (_isFirst) {
            self.profilePicture.frame = CGRectMake(_profilePicture.frame.origin.x, _profilePicture.frame.origin.y + 12 + 10, _profilePicture.frame.size.width, _profilePicture.frame.size.height);
            self.arrowBackgroundMessage.frame = CGRectMake(_arrowBackgroundMessage.frame.origin.x, _arrowBackgroundMessage.frame.origin.y + 12 + 10, _arrowBackgroundMessage.frame.size.width, _arrowBackgroundMessage.frame.size.height);
        }
        height += 12 + 10;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
    return height + 1;
    
}

- (NSString *)dayWithDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateFormatter.dateFormat       = @"d MMM";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dateFormatter stringFromDate:date];
    
}

- (NSString *)timeWithDate:(NSDate *)date{
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    
    if ([self timeIs24HourFormat]) {
        timeFormatter.dateFormat = @"HH:mm";
    } else {
        timeFormatter.dateFormat = @"hh:mm a";
    }
    
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    return [[timeFormatter stringFromDate:date] lowercaseString];
    
}

- (BOOL)timeIs24HourFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
    return is24Hour;
}

-(void)setRoundedView:(UIImageView *)roundedView{
    
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, roundedView.frame.size.width, roundedView.frame.size.width);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = roundedView.frame.size.width / 2.0;
    roundedView.center = saveCenter;
    
}

@end
