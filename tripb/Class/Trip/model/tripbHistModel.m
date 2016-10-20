//
//  tripbHistModel.m
//  tripb
//
//  Created by 云开互联 on 16/5/19.
//  Copyright © 2016年 tripb. All rights reserved.


#import "tripbHistModel.h"

@implementation tripbHistModel

+ (instancetype)dataWithString:(NSString *)order_id order_type:(NSString *)order_type order_city_title:(NSString *)order_city_title order_step:(NSString *)order_step order_true_total_money:(NSString *)order_true_total_money order_total_estimate:(NSString *)order_total_estimate order_applyreason:(NSString *)order_applyreason order_status:(NSString *)order_status order_reapply_flag:(NSString *)order_reapply_flag order_reapply_url:(NSString *)order_reapply_url order_starttime:(NSString *)order_starttime order_red_flag:(NSString *)order_red_flag{
  
    tripbHistModel *model        = [[self alloc] init];
    model.order_id               = order_id;
    model.order_type             = order_type;
    model.order_city_title       = order_city_title;
    model.order_starttime        = order_starttime;
    model.order_step             = order_step;
    model.order_true_total_money = order_true_total_money;
    model.order_total_estimate   = order_total_estimate;
    model.order_applyreason      = order_applyreason;
    model.order_status           = order_status;
    model.order_reapply_flag     = order_reapply_flag;
    model.order_reapply_url      = order_reapply_url;
    model.order_red_flag         = order_red_flag;
//    NSLog(@"order_true_total_money : %@",order_true_total_money);
    
    return model;
}
@end
