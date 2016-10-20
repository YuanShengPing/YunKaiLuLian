//
//  orderDataModel.h
//  __PRODUCTNAME__
//
//  Created by 云开互联 on 16/08/04
//  Copyright (c) __ORGANIZATIONNAME__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface orderDataModel : NSObject

@property (nonatomic, copy) NSString *apply_id;

@property (nonatomic, copy) NSString *apply_approvedstatus;

@property (nonatomic, copy) NSString *apply_reason;

@property (nonatomic, copy) NSString *train_count;

@property (nonatomic, copy) NSString *apply_applytime;

@property (nonatomic, copy) NSString *estimate;

@property (nonatomic, copy) NSString *flight_count;

@property (nonatomic, copy) NSString *hotel_count;

@property (nonatomic, copy) NSString *apply_red_flag;


+ (instancetype)modalWith:(NSString *)apply_id apply_approvedstatus:(NSString *)apply_approvedstatus apply_reason:(NSString *)apply_reason train_count:(NSString *)train_count apply_applytime:(NSString *)apply_applytime estimate:(NSString *)estimate flight_count:(NSString *)flight_count hotel_count:(NSString *)hotel_count apply_red_flag:(NSString *)apply_red_flag;
@end
