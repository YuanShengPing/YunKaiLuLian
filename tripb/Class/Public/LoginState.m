//
//  LoginState.m
//  tripb
//
//  Created by 云开互联 on 16/4/18.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "LoginState.h"


@implementation LoginState

- (BOOL)LoginStateWithBumber{
    //    解档
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"phoneNumber.data"]  ;
    StudentModel *student = [StudentModel new];
    student = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
//    NSLog(@"归档->phone:%@",student);
    NSString *Tel= [NSString stringWithFormat:@"%@",student.phone];
    if (student.phone) {
      self.phone = [NSString stringWithFormat:@"%@",Tel];
        return YES;
    }else{
    
        return NO;
    }
}
//判断登入与否
- (BOOL)NotLoginWithLogin{
    //    解档
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"phoneNumber.data"]  ;
    StudentModel *student = [StudentModel new];
    student = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
//    NSLog(@"解档phone:%@",student);
    NSString *login= [NSString stringWithFormat:@"%@",student.login];
    
    if ([login isEqualToString:@"state"]) {
        
        return YES;
    }else{
        
        return NO;
    }

}
//判断用户是否需要刷新数据
- (BOOL)StateRefreshWithHome{

    //    解档
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"RefreshHome.data"]  ;
    StateRefresh *student = [StateRefresh new];
    student = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
   NSLog(@"----解档phone:%@",student);
    NSString *refresh= [NSString stringWithFormat:@"%@",student.StateRefresh];
    
    if ([refresh isEqualToString:@"Refresh"]) {
        
        return YES;
    }else{
        
        return NO;
    }
}
@end
