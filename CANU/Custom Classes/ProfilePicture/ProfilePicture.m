//
//  ProfilePicture.m
//  CANU
//
//  Created by Vivien Cormier on 25/03/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import "ProfilePicture.h"

@implementation ProfilePicture

+ (UIImage *)defaultProfilePicture35{
    
    UIImage *image;
    
    NSArray *allProfilePicture35 = @[@"All_profile_picture_35_1",@"All_profile_picture_35_2",@"All_profile_picture_35_3"];
    
    NSInteger number = arc4random() % 3;
    
    image = [UIImage imageNamed:[allProfilePicture35 objectAtIndex:number]];
    
    return image;
    
}

+ (UIImage *)defaultProfilePicture95{
    
    UIImage *image;
    
    NSArray *allProfilePicture35 = @[@"All_profile_picture_95_1",@"All_profile_picture_95_2",@"All_profile_picture_95_3"];
    
    NSInteger number = arc4random() % 3;
    
    image = [UIImage imageNamed:[allProfilePicture35 objectAtIndex:number]];
    
    return image;
    
}

@end
