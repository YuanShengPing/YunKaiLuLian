//
//  AppDelegate.m
//  tripb
//
//  Created by 云开互联 on 16/4/8.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "AppDelegate.h"
#import "MytabBarController.h"
#import "WXApiManager.h"
#import "BPush.h"
#import "AFNetworking.h"
#import <sys/utsname.h>
#import "CreateEnterpriseViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "UpdateVersionTool.h"
//推送跳转的页面
#import "pushViewController.h"
#import "TravelWebView.h"
#import "DanLi.h"
#import "HomeViewController.h"

static BOOL isBackGroundActivateApplication;
//百度推送KEY  FouuxHPnXbVmj96OtjshU8TQ
//注册微信支付  wx91fe389334f7dde7

@interface AppDelegate ()<UIAlertViewDelegate>
{
    UITabBarController *_tabBarCtr;
}
@property (nonatomic,copy)NSString *urlString;

@property (nonatomic,strong)HomeViewController *homeController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef DEBUG
    [DanLi sharedDanLi].UpEnvironmental = @"mantis";
#else
    [DanLi sharedDanLi].UpEnvironmental = @"m";
#endif
    //通知是否注册公司
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(upCompany) name:@"upCompany" object:nil];
    

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent ];
    // 动态添加快捷启动3D Touch
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //判断是否是6S 或 6s plus
    if ([deviceString isEqualToString:@"iPhone8,1"] || [deviceString isEqualToString:@"iPhone8,2"]) {
        
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePause];
       
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"first" localizedTitle:@"我要出差" localizedSubtitle:nil icon:icon userInfo:nil];
        UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"second" localizedTitle:@"出差详情" localizedSubtitle:nil icon:icon1 userInfo:nil];
        
        [[UIApplication sharedApplication] setShortcutItems:@[item1,item]];
    }

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _tabBarCtr = [MytabBarController new];
    
    self.window.rootViewController = _tabBarCtr;
    
    [self.window makeKeyWindow];
    
    /**
     注册微信支付 wx91fe389334f7dde7
     */
    [WXApi registerApp:@"wx91fe389334f7dde7" withDescription:@"tripb"];
    /**
     百度推送
     iOS8 下需要使用新的 API
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [application registerForRemoteNotifications];
                                  }
                              }];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
//#warning 测试 开发环境 时需要修改BPushMode为BPushModeDevelopment 需要修改Apikey为自己的Apikey
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
   [BPush registerChannel:launchOptions apiKey:@"FouuxHPnXbVmj96OtjshU8TQ" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
//    禁止地图定位推送
     [BPush disableLbs];
 
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    return YES;
}

- (void)upCompany{

    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未在任何企业中!点击确定,加入或创建企业。" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *okAction =     [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        CreateEnterpriseViewController *CreateEnterprise = [CreateEnterpriseViewController new];
        
        [_tabBarCtr.selectedViewController pushViewController:CreateEnterprise animated:YES];
    }];
    //修改按钮颜色
    [okAction setValue:[UIColor brownColor] forKey:@"titleTextColor"];
    [alertV addAction:cancelAction];
    [alertV addAction:okAction];
    [_tabBarCtr.selectedViewController presentViewController:alertV animated:YES completion:nil];

}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    pushViewController *skipCtr = [[pushViewController alloc]init];
//    NSLog(@"------%@",userInfo);
   [self pushWithUrl:userInfo];
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    
    NSString *title;
    NSString *content;
    NSString *message = [NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]];
    if ([message rangeOfString:@"】"].location == NSNotFound) {
        //不存在
        title = [NSString stringWithFormat:@"收到一条消息"];
        content = [NSString stringWithFormat:@"message"];
    }else{
     NSArray *arrayMessage= [message componentsSeparatedByString:@"】"];//从字符A中分隔成2个元素的数组
        title = [NSString stringWithFormat:@"%@】",arrayMessage[0]];
        content = [NSString stringWithFormat:@"%@",arrayMessage[1]];
    }
    
    [DanLi sharedDanLi].homeData = @"UphomeData";
    [DanLi sharedDanLi].UpData   = @"UpData";
    [DanLi sharedDanLi].UpOrder  = @"UpOrder";
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
    
        NSDictionary *datadict = @{@"username":@"MiMi"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShowAlertView" object:self userInfo:datadict];
        

        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
        // 根视图是nav 用push 方式跳转
        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
        skipCtr.urlString =self.urlString;
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
//        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    completionHandler(UIBackgroundFetchResultNewData);
//    NSLog(@"------%@",userInfo);

}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
            // 获取channel_id
            NSString *myChannel_id = [BPush getChannelId];
            
            [DanLi sharedDanLi].channel_id = myChannel_id;
            
            [self channelIdPushSeve:myChannel_id];
            
            [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                if (result) {
//                    NSLog(@"result ============== %@",result);
                }
            }];
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                }
            }];
        }
    }];

    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    [self pushWithUrl:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        
        NSString *title;
        NSString *content;
        NSString *message = [NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]];
        if ([message rangeOfString:@"】"].location == NSNotFound) {
            //不存在
            title = [NSString stringWithFormat:@"收到一条消息"];
            content = [NSString stringWithFormat:@"message"];
            
        }else{
            NSArray *arrayMessage= [message componentsSeparatedByString:@"】"];//从字符A中分隔成2个元素的数组
            title = [NSString stringWithFormat:@"%@",arrayMessage[0]];
            content = [NSString stringWithFormat:@"%@",arrayMessage[1]];
            
        }
       
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        pushViewController *skipCtr = [[pushViewController alloc]init];
        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
        skipCtr.urlString =self.urlString;
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        pushViewController *skipCtr = [[pushViewController alloc]init];
        // 根视图是nav 用push 方式跳转
        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
        
        skipCtr.urlString  = self.urlString ;

    }
}
//set_baiduchannel 上传channel id
- (void)channelIdPushSeve:(NSString *)channelId{

    NSString *str = [NSString stringWithFormat:@"%@/api/user/set_pushchannel.html",[URLstate URLstateWithString]];/*AFNurl(@"/api/user/", @"set_pushchannel");*/
    NSString *url = [NSString stringWithFormat:@"%@?device=iOS&channelid=%@",str,channelId];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject:%@上传channel_id成功",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败");
        
    }];
    

}

- (void)pushWithUrl:(NSDictionary *)userInif {

    NSString *action_url = [userInif objectForKey:@"msg_action_url"];
//    刷新订单数据（还为实现1刷新，0不刷新）
    NSString *msg_refresh = [userInif objectForKey:@"msg_refresh"];
    if ([msg_refresh intValue]) {
        [DanLi sharedDanLi].UpData  = @"UpData";
        [DanLi sharedDanLi].UpOrder  = @"UpOrder";
    }else{
        [DanLi sharedDanLi].UpData  = @"NotUpData";
        [DanLi sharedDanLi].UpOrder  = @"NotUpOrder";
    }
    NSArray *arg = [userInif objectForKey:@"arg"];
    NSMutableString *strURL = [NSMutableString new];
    for (NSDictionary *dict in arg) {
        NSString *field_name  = [dict objectForKey:@"field_name"];
        NSString *field_value = [dict objectForKey:@"field_value"];
        NSString *field = [NSString stringWithFormat:@"%@=%@&",field_name,field_value];
        [strURL appendString:field];
    }
//    [NSString stringWithFormat:@"%@/%@.html",URLw,url]
    
    self.urlString = [NSString stringWithFormat:@"%@/%@.html?%@",[URLstate URLstateWithString],action_url,strURL];
    
//    NSLog(@"self.urlString:%@",[NSString stringWithFormat:@"%@?%@",HTML(action_url),strURL]);
}

//静止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  
    NSLog(@"应用从活动状态进入到非活动状态：applicationWillResignActive ：");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
    NSLog(@"应用进入到后台时候调用的方法:applicationDidEnterBackground：");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"应用进入到前台时候调用的方法:appplicationWillEnterForeground:");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   NSLog(@"应用进入前台并处于活动状态时候调用：applicationDidBecomeActive:");
    [UpdateVersionTool updateVersionForAppID:@"1103625202" isShowReleaseNotes:YES showController:_tabBarCtr.selectedViewController];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSLog(@" applicationWillTeminate：应用被终止的状态:");
}
/**
 微信支付
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
/**
 <#Description#>
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
//    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    
    NSString *itemType = shortcutItem.type;
    if ([itemType isEqualToString:@"first"]) {
        NSLog(@"点击了第一个");
        TravelWebView *Travel = [TravelWebView new];
       [_tabBarCtr.selectedViewController pushViewController:Travel animated:YES];
    }
    else if ([itemType isEqualToString:@"second"]) {
        NSLog(@"点击了第二个");
    }
    
   
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:@"upCompany"];
}
@end
