//
//  orderDataModel.m
//  __PRODUCTNAME__
//
//  Created by 云开互联 on 16/08/04
//  Copyright (c) __ORGANIZATIONNAME__. All rights reserved.
//

#import "orderDataModel.h"

@implementation orderDataModel

+ (instancetype)modalWith:(NSString *)apply_id apply_approvedstatus:(NSString *)apply_approvedstatus apply_reason:(NSString *)apply_reason train_count:(NSString *)train_count apply_applytime:(NSString *)apply_applytime estimate:(NSString *)estimate flight_count:(NSString *)flight_count hotel_count:(NSString *)hotel_count apply_red_flag:(NSString *)apply_red_flag{

    orderDataModel *model = [[self alloc] init];
    model.apply_id = apply_id;
    model.apply_approvedstatus = apply_approvedstatus;
    model.apply_reason = apply_reason;
    model.train_count = train_count;
    model.apply_applytime = apply_applytime;
    model.estimate = estimate;
    model.flight_count = flight_count;
    model.hotel_count = hotel_count;
    model.apply_red_flag =apply_red_flag;
    
    return model;
}

@end
