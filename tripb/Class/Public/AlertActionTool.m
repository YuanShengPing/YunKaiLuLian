//
//  AlertActionTool.m
//  tripb
//
//  Created by 云开互联 on 16/6/29.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "AlertActionTool.h"

@implementation AlertActionTool

+ (void)NetworkTips:(UIViewController *)controller{
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *Version =[phoneVersion componentsSeparatedByString:@"."];
    NSString *largeVersion  = [NSString stringWithFormat:@"%@",Version[0]];
    
    if ([largeVersion isEqualToString:@"10"]) {
        
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"无网络连接" message:@"需要开启网络服务,请到设置->“移动网络”或“WLAN”,打开网络服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
        
    }else{
    
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前网络好像开小差了，是否检查网络？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
    
        [controller.navigationController popViewControllerAnimated:YES];
    }];
    

    UIAlertAction *okAction =     [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //跳转到设置
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=INTERNET_TETHERING"]];
        });

    }];
    //修改按钮颜色
    [cancelAction setValue:[UIColor brownColor] forKey:@"titleTextColor"];
    [alertV addAction:cancelAction];
    [alertV addAction:okAction];
    [controller presentViewController:alertV animated:YES completion:nil];
    }
}


@end
