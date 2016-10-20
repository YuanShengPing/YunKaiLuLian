//
//  JGGchijiuhua.m
//  JGG持久化类
//
//  Created by bz on 16/5/12.
//  Copyright © 2016年 . All rights reserved.
//

#import "JGGchijiuhua.h"

@implementation JGGchijiuhua

+(NSString*)JGGbocunJSONname:(NSString*)name shuzu:(NSDictionary *)marr
{
    
    name=[NSString stringWithFormat:@"%@.json",name];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:name];
    
    BOOL ok=[[NSJSONSerialization dataWithJSONObject:marr options:0 error:nil] writeToFile:fileName atomically:YES];
    
//    NSLog(@"路径是：%@",path);
    return [NSString stringWithFormat:@"%d",ok];
}


+(NSDictionary*)JGGhuoquJSONname:(NSString*)name
{
    NSDictionary *marr=[[NSDictionary alloc]init];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *fileName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",name]];
    
    NSData*data = [NSData dataWithContentsOfFile:fileName];
    if (data==nil) {
        NSLog(@"根据方法名没有找到文件，请根据路径检查方法名！");
        NSLog(@"路径是：%@",path);
        return 0;
    }else
    {
    marr = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
//        NSLog(@"路径是：%@",path);
        return marr;
    }
}

+(NSString*)JGGshanchuJSONname:(NSString*)name
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //文件名
    NSString *fileName=[[path objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",name]];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:fileName];
//    NSLog(@"路径是：%@",path);
    if (blHave){
        BOOL blDele= [fileManager removeItemAtPath:fileName error:nil];
        if (blDele)
        {
            NSLog(@"%@.json 删除成功!",name);
            return @"1";
        }else
        {
            NSLog(@"查询到该文件，但由于未知原因无法删除!建议通过路径操作！");
            return @"0";
        }
    }else{
        NSLog(@"没有找到该文件，删除失败!");
        return @"0";
    }
}
@end
