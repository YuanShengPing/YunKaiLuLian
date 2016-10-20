//
//  tripbHistMode.h
//  tripb
//
//  Created by 云开互联 on 16/06/01
//  Copyright (c) tripb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Trips;

@interface tripbHistMode : NSObject

@property (nonatomic, copy) NSString *result;

@property (nonatomic, assign) NSInteger errorcode;

@property (nonatomic, copy) NSString *errormsg;

@property (nonatomic, strong) NSArray<Trips *> *trips;

@end