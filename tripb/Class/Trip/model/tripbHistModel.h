//
//  tripbHistModel.h
//  tripb
//
//  Created by 云开互联 on 16/5/19.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tripbHistModel : NSObject
//url
@property (nonatomic,copy) NSString *order_id;
//工具
@property (nonatomic,copy) NSString *order_type;
//出发城市 - 目的地
@property (nonatomic,copy) NSString *order_city_title;
//时间
@property (nonatomic,copy) NSString *order_starttime;
//金额判断
@property (nonatomic,copy) NSString *order_step;
//实际金额
@property (nonatomic,copy) NSString *order_true_total_money;
//预估金额
@property (nonatomic,copy) NSString *order_total_estimate;
//出差理由
@property (nonatomic,copy) NSString *order_applyreason;
//状态
@property (nonatomic,copy) NSString *order_status;
//判断是否需要重新预定 0 不显示 1显示重新预定
@property (nonatomic,copy) NSString *order_reapply_flag;
//重新预定url
@property (nonatomic,copy) NSString *order_reapply_url;
//红点提示
@property (nonatomic,copy) NSString *order_red_flag;


+ (instancetype)dataWithString:(NSString *)order_id order_type:(NSString *)order_type order_city_title:(NSString *)order_city_title order_step:(NSString *)order_step order_true_total_money:(NSString *)order_true_total_money order_total_estimate:(NSString *)order_total_estimate order_applyreason:(NSString *)order_applyreason order_status:(NSString *)order_status order_reapply_flag:(NSString *)order_reapply_flag order_reapply_url:(NSString *)order_reapply_url order_starttime:(NSString *)order_starttime order_red_flag:(NSString *)order_red_flag;


@end
