//
//  UICanuButtonSelect.m
//  CANU
//
//  Created by Vivien Cormier on 07/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuButtonSelect.h"

@interface UICanuButtonSelect ()

@property (strong, nonatomic) UILabel *labelButton;

@end

@implementation UICanuButtonSelect

@synthesize selected = _selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.labelButton = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.labelButton.font = [UIFont fontWithName:@"Lato-Regular" size:15];
        self.labelButton.textColor = UIColorFromRGB(0x2b4b58);
        self.labelButton.backgroundColor = [UIColor clearColor];
        self.labelButton.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelButton];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selected = NO;
        
    }
    return self;
}

- (void)setTextButton:(NSString *)textButton{
    
    if (_selected) {
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textButton];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        
        self.labelButton.attributedText = attributeString;
        
    } else {
        
        self.labelButton.text = textButton;
        
    }
    
    _textButton = textButton;
    
}

- (void)setSelected:(BOOL)selected{
    
    if (selected) {
        self.labelButton.textColor = UIColorFromRGB(0x1ca6c3);
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_textButton];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        
        self.labelButton.attributedText = attributeString;
        
    } else {
        self.labelButton.textColor = UIColorFromRGB(0x2b4b58);
        self.labelButton.text = _textButton;
    }
    
    _selected = selected;
    
}

@end
