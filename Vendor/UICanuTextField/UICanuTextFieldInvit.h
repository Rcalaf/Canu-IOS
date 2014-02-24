//
//  UICanuTextFieldInvit.h
//  CANU
//
//  Created by Vivien Cormier on 20/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "UICanuTextField.h"

@interface UICanuTextFieldInvit : UICanuTextField

@property (nonatomic) BOOL activeReset;

- (void)updateUserSelected:(NSMutableArray *)arrayAllUserSelected;

@end
