//
//  CLOrderTool.h
//  tripb
//
//  Created by 云开互联 on 16/8/8.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class orderDataModel;

@interface CLOrderTool : NSObject


// 插入模型数据
+ (BOOL)insertModel:(orderDataModel *)model;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;



@end
