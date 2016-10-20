//
//  LoginState.h
//  tripb
//
//  Created by 云开互联 on 16/4/18.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentModel.h"
#import "StateRefresh.h"
//typedef enum {
//    //以下是枚举成员 TestA = 0,
//    Login,
//    NotLogin
//}isLogin;

@interface LoginState : NSObject

@property (nonatomic,copy)NSString *phone;
//获取缓存手机号码
- (BOOL)LoginStateWithBumber;
//判断登入状态
- (BOOL)NotLoginWithLogin;
//获取刷新状态
- (BOOL)StateRefreshWithHome;
@end
