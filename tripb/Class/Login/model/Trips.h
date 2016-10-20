//
//  Trips.h
//  tripb
//
//  Created by 云开互联 on 16/06/01
//  Copyright (c) tripb. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Trips : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *airline;

@property (nonatomic, copy) NSString *arrTimeShort;

@property (nonatomic, copy) NSString *transNumber;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *arrCity;

@property (nonatomic, copy) NSString *depCity;

@property (nonatomic, copy) NSString *depPort;

@property (nonatomic, copy) NSString *arrPort;

@property (nonatomic, assign) NSInteger depTime;

@property (nonatomic, copy) NSString *depTimeShort;

@property (nonatomic, assign) NSInteger arrTime;

@property (nonatomic, assign) NSInteger currentTrip;

@end