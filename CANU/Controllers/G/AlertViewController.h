//
//  AlertViewController.h
//  CANU
//
//  Created by Vivien Cormier on 24/01/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrorManager.h"

typedef NS_ENUM(NSInteger, CANUAlertViewType) {
    CANUAlertViewHeader = 0,    // Little View on the header
    CANUAlertViewPopIn = 1,     // Classic pop in
};

@interface AlertViewController : UIViewController

/**
 *  Visuel type of the Alert
 */
@property (nonatomic) CANUAlertViewType canuAlertViewType;

/**
 *  Type of the error
 */
@property (nonatomic) CANUError canuError;

@end
