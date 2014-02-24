//
//  CreateEditUserList.h
//  CANU
//
//  Created by Vivien Cormier on 11/02/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEditUserList : UIView

@property (retain) id delegate;
@property (nonatomic) int maxHeight;
@property (strong, nonatomic) NSMutableArray *arrayAllUserSelected;

- (void)searchPhoneBook:(NSString *)searchWords;

@end

@protocol CreateEditUserListDelegate <NSObject>

@required

- (void)changeUserSelected:(NSMutableArray *)arrayAllUserSelected;

@end
