//
//  UpdateVersionTool.m
//  AppVersionUpdateDemo
//
//  Created by LiCheng on 16/6/20.
//  Copyright © 2016年 Li_Cheng. All rights reserved.
//

#import "UpdateVersionTool.h"
#import "AFNetworking.h"
#import "ReachabilityBool.h"

@interface UpdateVersionTool()

@end

@implementation UpdateVersionTool

/**
 *      网址问题:
 
    在网上的博客里面都是 //:itunes.apple.com/lookup?id=你的appid
    这个 网址解析出来的东西是空的
            
    需要加上/cn
    //:itunes.apple.com/cn/lookup?id=你的appid
 */

// 获取网络状态
//NSString *status = [self getNetWorkStatus];
//NSLog(@"%@", status);
// 只有当网络为WiFi 和 4G 的情况下 提醒更新
//if ([status isEqualToString:@"WIFI"] || [status isEqualToString:@"4G"] || [status isEqualToString:@"3G"] || [status isEqualToString:@"2G"]) {
//
//[self getVersionForAppID:appid isShowReleaseNotes:isShowReleaseNotes showController:controller];
//}else {


+(void)updateVersionForAppID:(NSString *)appid
          isShowReleaseNotes:(BOOL)isShowReleaseNotes
              showController:(UIViewController *)controller
{
    ReachabilityBool *statusT = [ReachabilityBool new];
    if ([statusT reachabilityWithStatus]) {
    
    
    [self getVersionForAppID:appid isShowReleaseNotes:isShowReleaseNotes showController:controller];
    
    }/*else{
//        检查网络
        [AlertActionTool NetworkTips:controller];
    }*/
}


#pragma mark - 获取版本信息
+(void)getVersionForAppID:(NSString *)appid
       isShowReleaseNotes:(BOOL)isShowReleaseNotes
           showController:(UIViewController *)controller
{
     NSString *urlStr =[NSString stringWithFormat:@"%@/api/user/get_appversion?os_type=2",[URLstate URLstateWithString]]; /*[NSString stringWithFormat:@"%@get_appversion?os_type=2",URLt];*/
//    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", appid];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"success"]) {
        
            NSString *compulsion = [responseObject objectForKey:@"force_version"];

        // 本地版本号
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        NSArray *largeVersion =[compulsion componentsSeparatedByString:@"."];
        NSArray *currentVersion = [localVersion componentsSeparatedByString:@"."];
        //4:4
        float compulsionLarge = [[NSString stringWithFormat:@"%@.%@",largeVersion[0],largeVersion[1]] floatValue];
        float compulsionSmall = [[NSString stringWithFormat:@"%@",largeVersion[2]] intValue];
        
        float SmallStore = [[NSString stringWithFormat:@"%@.%@",currentVersion[0],currentVersion[1]] floatValue];
        float SmallLocal = [[NSString stringWithFormat:@"%@",currentVersion[2]] intValue];
//            NSLog(@"%f == %f",compulsionLarge,SmallStore);
            if (compulsionLarge > SmallStore ) {
               //强制升级
                [self appStoreWithUpVersion:appid isShowReleaseNotes:isShowReleaseNotes
                             showController:controller compulsion:YES];
            }else if (compulsionLarge == SmallStore && compulsionSmall >= SmallLocal ){
                //强制升级
                [self appStoreWithUpVersion:appid isShowReleaseNotes:isShowReleaseNotes
                             showController:controller compulsion:YES];
            }else{
            //判断是否要升级 AppStore
                [self appStoreWithUpVersion:appid isShowReleaseNotes:isShowReleaseNotes
                             showController:controller compulsion:NO];
            
            }
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


+ (void)appStoreWithUpVersion:(NSString *)appid isShowReleaseNotes:(BOOL)isShowReleaseNotes
               showController:(UIViewController *)controller compulsion:(BOOL)compulsion{

        NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@", appid];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
            NSMutableArray *arr = [responseObject objectForKey:@"results"];
            NSDictionary   *dic = arr[0];
       
            // 获取 appstore 信息
            NSString *newVersion   = [dic objectForKey:@"version"];      // 版本号
            NSString *newURL       = [dic objectForKey:@"trackViewUrl"]; // 程序地址
            NSString *releaseNotes = [dic objectForKey:@"releaseNotes"]; // 版本注释
    
            if (compulsion) {
                
                [self setAlertWithUp:isShowReleaseNotes releaseNotes:releaseNotes newURL:newURL showController:controller newVersion:newVersion compulsionLarge:compulsion];
                
            }
            
            // 本地版本号
            NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
            NSArray *storeVersion =[newVersion componentsSeparatedByString:@"."];
            NSArray *currentVersion = [localVersion componentsSeparatedByString:@"."];
            //4:4
            float largeStore = [[NSString stringWithFormat:@"%@.%@",storeVersion[0],storeVersion[1]] floatValue];
            float currentLocal = [[NSString stringWithFormat:@"%@.%@",currentVersion[0],currentVersion[1]] floatValue];
    
            float SmallStore = [[NSString stringWithFormat:@"%@",storeVersion[2]] floatValue];
            float SmallLocal = [[NSString stringWithFormat:@"%@",currentVersion[2]] floatValue];
    
            // 1.获得Documents的全路径
            NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            // 2.获得文件的全路径
            NSString *path = [doc stringByAppendingPathComponent:@"Version.plist"];
    
            // 3.从文件中读取MJStudent对象
            NSString *stu = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    
            //判断AppStore版本是不是暂不提醒版本
            if (![newVersion isEqualToString:stu]) {
    
            if (largeStore > currentLocal) {
            [self setAlertWithUp:isShowReleaseNotes releaseNotes:releaseNotes newURL:newURL showController:controller newVersion:newVersion compulsionLarge:compulsion];
    
            }else if(largeStore == currentLocal && SmallStore > SmallLocal){
            [self setAlertWithUp:isShowReleaseNotes releaseNotes:releaseNotes newURL:newURL showController:controller newVersion:newVersion compulsionLarge:compulsion];
    
            }
    
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];

}


+ (void)setAlertWithUp:(BOOL)isShowReleaseNotes releaseNotes:(NSString *)releaseNotes newURL:(NSString *)newURL showController:(UIViewController *)controller newVersion:(NSString *)Version compulsionLarge:(BOOL)compulsionLarge{

    NSString *message = nil;
    
    if (isShowReleaseNotes == YES) {
        message = releaseNotes;
    }else{
        message = @"赶快更新吧，第一时间体验新功能！";
    }
    
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"有新版本了！" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (!compulsionLarge) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略此版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //获取沙盒文档目录
            NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [documents[0] stringByAppendingPathComponent:@"Version.plist"];
            [NSKeyedArchiver archiveRootObject:Version toFile:path];
            
        }];
        
        [alertV addAction:cancelAction];
    }
    
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 跳转到url
        if (newURL != nil) {
            NSURL *url=[NSURL URLWithString:newURL];
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    //修改按钮颜色
    [okAction setValue:[UIColor brownColor] forKey:@"titleTextColor"];
    
    [alertV addAction:okAction];
    [controller presentViewController:alertV animated:YES completion:nil];

}


#pragma mark - 获取当前网络状态
+(NSString *)getNetWorkStatus{
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    NSString *status = [[NSString alloc] init];
    
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    status = @"无网络";
                    break;
                    
                case 1:
                    status = @"2G";
                    break;
                    
                case 2:
                    status = @"3G";
                    break;
                    
                case 3:
                    status = @"4G";
                    break;
                    
                case 5:
                {
                    status = @"WIFI";
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return status;
}

@end
