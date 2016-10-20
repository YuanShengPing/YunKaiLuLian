//
//  CLOrderTool.m
//  tripb
//
//  Created by 云开互联 on 16/8/8.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "CLOrderTool.h"
#import "orderDataModel.h"
#define LVSQLITE_NAME @"order.sqlite"

@implementation CLOrderTool


static FMDatabase *_fmdb;

+ (void)initialize {
    
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
//#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"create table if not exists t_order(ID integer primary key  autoincrement,apply_id TEXT NOT NULL ,apply_approvedstatus TEXT NOT NULL,apply_reason TEXT NOT NULL,train_count TEXT NOT NULL,apply_applytime TEXT NOT NULL,estimate TEXT NOT NULL,flight_count TEXT NOT NULL,hotel_count TEXT NOT NULL,apply_red_flag TEXT NOT NULL)"];
    
}

+ (BOOL)insertModel:(orderDataModel *)model {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_order(apply_id,apply_approvedstatus,apply_reason,train_count,apply_applytime,estimate,flight_count,hotel_count,apply_red_flag) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                           [NSString stringWithFormat:@"%@",model.apply_id],
                           [NSString stringWithFormat:@"%@",model.apply_approvedstatus],
                           [NSString stringWithFormat:@"%@",model.apply_reason],
                           [NSString stringWithFormat:@"%@",model.train_count],
                           [NSString stringWithFormat:@"%@",model.apply_applytime],
                           [NSString stringWithFormat:@"%@",model.estimate],
                           [NSString stringWithFormat:@"%@",model.flight_count],
                           [NSString stringWithFormat:@"%@",model.hotel_count],
                           [NSString stringWithFormat:@"%@",model.apply_red_flag]];
                           
    
    return [_fmdb executeUpdate:insertSql];
    
}

+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_order;";
    }
    
    NSMutableArray *arrY = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        //
        NSString *apply_id = [set stringForColumn:@"apply_id"];
        NSString *apply_approvedstatus = [set stringForColumn:@"apply_approvedstatus"];
        NSString *apply_reason = [set stringForColumn:@"apply_reason"];
        NSString *train_count = [set stringForColumn:@"train_count"];
        NSString *apply_applytime = [set stringForColumn:@"apply_applytime"];
        NSString *estimate = [set stringForColumn:@"estimate"];
        NSString *flight_count = [set stringForColumn:@"flight_count"];
        NSString *hotel_count = [set stringForColumn:@"hotel_count"];
        NSString *apply_red_flag = [set stringForColumn:@"apply_red_flag"];
       
//        NSLog(@"======>a");
        orderDataModel *modal = [orderDataModel modalWith:apply_id apply_approvedstatus:apply_approvedstatus apply_reason:apply_reason train_count:train_count apply_applytime:apply_applytime estimate:estimate flight_count:flight_count hotel_count:hotel_count apply_red_flag:apply_red_flag];
        [arrY addObject:modal];
       
//         NSLog(@"======>arrY : %@",arrY);
        
      
    }
        return arrY;
}


+ (BOOL)deleteData:(NSString *)deleteSql {
                               
  if (deleteSql == nil) {
      deleteSql = @"DELETE FROM t_order";
                        }
                               
 return [_fmdb executeUpdate:deleteSql];
                               
}

@end
