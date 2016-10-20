//
//  ZDBombBox.m
//  zhidingwang
//
//  Created by 袁胜平 on 15/10/23.
//  Copyright © 2015年 直订网365. All rights reserved.
//

#import "ZDBombBox.h"


@implementation ZDBombBox

- (void)bombBoxWithBtn:(NSString *)text UIView:(UIView *)View{

    MBProgressHUD* hud = [[MBProgressHUD alloc]initWithView:View];
    [View addSubview:hud];
    
    //当前view背景颜色暗下去
    hud.dimBackground =NO;
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        float progress =0.0f;
        while (progress<1.0f)
        {
            progress += 0.01f;
            hud.progress =progress;
            //                进程挂起一段时间， 单位是微秒（千分之一毫秒）
            usleep(10000);
        }
    } completionBlock:^{
        [hud removeFromSuperview];
        
    }];


}

@end
