//
//  ToToolHelper.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ToToolHelper.h"
//#import "TOHttpHelper.h"
//#import "APService.h"
#import "AppDelegate.h"
//#import "LoginViewController.h"
//#import "NSDictionary+NullFilter.h"
//#import "SLFriendCircleConstant.h"
//#import "ViewController.h"
static ToToolHelper *toToolHelper = nil;
@implementation ToToolHelper

+(ToToolHelper *)sharedHelper
{
    if (toToolHelper == nil)
    {
        toToolHelper = [[ToToolHelper alloc] init];
    }
    return toToolHelper;
}
/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
//    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"剩余0天"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"剩余%ld分钟",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"剩余%ld小时",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"剩余%ld天",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"剩余%ld个月",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"剩余%ld年",temp];
    }
    
    return  result;
}

///检测是否是手机号码
-(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[7]|5[0-35-9]|8[0235-9]|7[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181
     22         */
    NSString * CT = @"^1((33|53|77|8[091])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
//     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


///检查登录结果
+(BOOL)checkIfLogin
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"ifLogin"];
    if ([value isEqualToString:@"yes"])
    {
        
        return YES;
    }
    else
    {
        return NO;
    //测试
// return YES;
    }
}
///保存登录结果
+(void)saveLoginState
{
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"ifLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
///更改退出登录
+(void)changeLoginState
{
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"ifLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
