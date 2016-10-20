//
//  homeDataModel.h
//  tripb
//
//  Created by 云开互联 on 16/08/05
//  Copyright (c) tripb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserinfomModel,Applysummary,Needapprove;

@interface homeDataModel : NSObject

@property (nonatomic, copy) NSString *result;

@property (nonatomic, assign) NSInteger errorcode;

@property (nonatomic, copy) NSString *errormsg;

@property (nonatomic, strong) UserinfomModel *userinfo;

@end