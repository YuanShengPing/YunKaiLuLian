//
//  JGGchijiuhua.h
//  JGG持久化类
//
//  Created by bz on 16/5/12.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGGchijiuhua : NSObject
#pragma mark--保存可变数组 参数名  数组 如果有需要则可以创建一个字符串接受返回值 0保存失败 1保存成功
+(NSString*)JGGbocunJSONname:(NSString*)name shuzu:(NSDictionary *)marr;

#pragma mark--获取持久化的数据
+(NSDictionary *)JGGhuoquJSONname:(NSString*)name;

#pragma mark--删除持久化数据 如果有需要则可以创建一个字符串接受返回值 0删除失败 1删除成功
+(NSString*)JGGshanchuJSONname:(NSString*)name;

@end
