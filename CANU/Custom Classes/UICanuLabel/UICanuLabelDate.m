//
//  UICanuLabelDate.m
//  CANU
//
//  Created by Vivien Cormier on 27/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuLabelDate.h"
#import "Activity.h"

@implementation UICanuLabelDate

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font            = [UIFont fontWithName:@"Lato-Regular" size:10.0];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment   = NSTextAlignmentRight;
        self.textColor       = UIColorFromRGB(0x2b4b58);
        
    }
    return self;
}

- (void)setDate:(Activity *)activity{
    
    NSString *text = [NSString stringWithFormat:@"%@ %@ - %@",[UICanuLabelDate dayWithDate:activity.start],[UICanuLabelDate timeWithDate:activity.start],[UICanuLabelDate timeWithDate:activity.end]];
    
    self.text = text;
    
    [self setText:self.text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange startRange = [[mutableAttributedString string] rangeOfString:[UICanuLabelDate timeWithoutAMWithDate:activity.start] options:NSCaseInsensitiveSearch];
        NSRange endRange = [[mutableAttributedString string] rangeOfString:[UICanuLabelDate timeWithoutAMWithDate:activity.end] options:NSCaseInsensitiveSearch];
        
        UIFont *boldSystemFont = [UIFont fontWithName:@"Lato-Bold" size:10.0];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:startRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:endRange];
            CFRelease(font);
        }
        
        return mutableAttributedString;
        
    }];
    
}

+ (NSString *)dayWithDate:(NSDate *)date{
    
    NSString *day;
    
    if ([date mk_isToday]) {
        day = [NSString stringWithFormat:@"%@ ",NSLocalizedString(@"Today", nil)];
    } else if ([date mk_isTomorrow]){
        day = [NSString stringWithFormat:@"%@ ",NSLocalizedString(@"Tomorrow", nil)];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        dateFormatter.dateFormat       = @"d MMM";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        day = [dateFormatter stringFromDate:date];
    }
    
    return day;
    
}

+ (NSString *)timeWithDate:(NSDate *)date{
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    
    if ([self timeIs24HourFormat]) {
        timeFormatter.dateFormat = @"HH:mm";
    } else {
        timeFormatter.dateFormat = @"hh:mm a";
    }
    
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    return [[timeFormatter stringFromDate:date] lowercaseString];
    
}

+ (NSString *)timeWithoutAMWithDate:(NSDate *)date{
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    
    if ([self timeIs24HourFormat]) {
        timeFormatter.dateFormat = @"HH:mm";
    } else {
        timeFormatter.dateFormat = @"hh:mm";
    }
    
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    return [timeFormatter stringFromDate:date];
    
}

+ (BOOL)timeIs24HourFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
    return is24Hour;
}

@end
