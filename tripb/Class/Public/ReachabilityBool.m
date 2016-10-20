//
//  ReachabilityBool.m
//  tripb
//
//  Created by 云开互联 on 16/5/5.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "ReachabilityBool.h"

@implementation ReachabilityBool

- (BOOL)reachabilityWithStatus{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态是wifi 后者 蜂窝网络
    if ([wifi currentReachabilityStatus] != NotReachable || [conn currentReachabilityStatus] != NotReachable) {

        return YES;
        
    }else{
        
        return NO;
    }

}


@end
