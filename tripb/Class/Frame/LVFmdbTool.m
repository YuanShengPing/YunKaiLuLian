

#import "LVFmdbTool.h"
#import "tripbHistModel.h"

#define LVSQLITE_NAME @"modals.sqlite"

@implementation LVFmdbTool


static FMDatabase *_fmdb;

//order_id,order_type,order_status,order_true_money,applyitem_starttime,apply_reason,order_name,money,is_overdue

+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    NSLog(@"filePath = %@",filePath);
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"create table if not exists t_modals(ID integer primary key  autoincrement,order_id TEXT NOT NULL ,order_type TEXT NOT NULL,order_city_title TEXT NOT NULL,order_step TEXT NOT NULL,order_true_total_money TEXT NOT NULL,order_total_estimate TEXT NOT NULL,order_applyreason TEXT NOT NULL,order_status TEXT NOT NULL,order_reapply_flag TEXT NOT NULL,order_reapply_url TEXT NOT NULL,order_starttime TEXT NOT NULL,order_red_flag TEXT NOT NULL)"];

}
//t_modals

+ (BOOL)insertModel:(tripbHistModel *)model {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_modals(order_id,order_type,order_city_title,order_step,order_true_total_money,order_total_estimate,order_applyreason,order_status,order_reapply_flag,order_reapply_url,order_starttime,order_red_flag) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                  [NSString stringWithFormat:@"%@",model.order_id],
                  [NSString stringWithFormat:@"%@",model.order_type],
                  [NSString stringWithFormat:@"%@",model.order_city_title],
                  [NSString stringWithFormat:@"%@",model.order_step],
                  [NSString stringWithFormat:@"%@",model.order_true_total_money],
                  [NSString stringWithFormat:@"%@",model.order_total_estimate],
                  [NSString stringWithFormat:@"%@",model.order_applyreason],
                  [NSString stringWithFormat:@"%@",model.order_status],
                  [NSString stringWithFormat:@"%@",model.order_reapply_flag],
                  [NSString stringWithFormat:@"%@",model.order_reapply_url],
                  [NSString stringWithFormat:@"%@",model.order_starttime],
                  [NSString stringWithFormat:@"%@",model.order_red_flag]];
    
//    NSLog(@"----%@",insertSql);
    return [_fmdb executeUpdate:insertSql];

}

+ (NSMutableArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_modals;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {

        NSString *order_id                 = [set stringForColumn:@"order_id"];
        NSString *order_type               = [set stringForColumn:@"order_type"];
        NSString *order_city_title         = [set stringForColumn:@"order_city_title"];
        NSString *order_step               = [set stringForColumn:@"model.order_step"];
        NSString *order_true_total_money   = [set stringForColumn:@"order_true_total_money"];
        NSString *order_total_estimate     = [set stringForColumn:@"order_total_estimate"];
        NSString *order_applyreason        = [set stringForColumn:@"order_applyreason"];
        NSString *order_status             = [set stringForColumn:@"order_status"];
        NSString *order_reapply_flag       = [set stringForColumn:@"order_reapply_flag"];
        NSString *order_reapply_url        = [set stringForColumn:@"order_reapply_url"];
        NSString *order_starttime          = [set stringForColumn:@"order_starttime"];
        NSString *order_red_flag           = [set stringForColumn:@"order_red_flag"];
//        
        tripbHistModel *modal = [tripbHistModel dataWithString:order_id order_type:order_type order_city_title:order_city_title order_step:order_step order_true_total_money:order_true_total_money order_total_estimate:order_total_estimate order_applyreason:order_applyreason order_status:order_status order_reapply_flag:order_reapply_flag order_reapply_url:order_reapply_url order_starttime:order_starttime order_red_flag:order_red_flag];
        [arrM addObject:modal];
    }

    if(arrM.count){
    
    return arrM;
    }else{
    
        return nil;
    }
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_modals";
    }
    
    return [_fmdb executeUpdate:deleteSql];

}

+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        modifySql = @"UPDATE t_modals SET ID_No = '789789' WHERE name = 'lisi'";
    }
    return [_fmdb executeUpdate:modifySql];
}



@end
