//
//  main.m
//  CANU
//
//  Created by Roger Calaf on 18/04/13.
//  Copyright (c) 2013 CANU. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "AppDelegate.h"

#import <PulseSDK/PulseSDK.h>

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [PulseSDK monitor:@"QO2OWjpm-05CG1FXP3aOB6nfDx8VbzHG"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
