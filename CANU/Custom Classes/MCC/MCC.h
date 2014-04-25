//
//  MCC.h
//  CANU
//
//  Created by Vivien Cormier on 09/04/14.
//  Copyright (c) 2014 CANU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCC : NSObject

@property (strong, nonatomic) NSString *mcc;
@property (strong, nonatomic) NSString *carriereVersion;
@property (strong, nonatomic) NSString *callingCode;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSArray *countryName_CallingCode_Array;
@property (strong, nonatomic) NSDictionary *countryName_CallingCode;
@property (strong, nonatomic) NSDictionary *mcc_CallingCode;

- (NSString *)callingCodeWithCountryName:(NSString *)countryName;

@end
