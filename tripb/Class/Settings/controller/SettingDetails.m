//
//  SettingDetails.m
//  tripb
//
//  Created by 云开互联 on 16/5/10.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "SettingDetails.h"
#import "aboutTripb.h"
#import "AFNetworking.h"
#import "JGGchijiuhua.h"
#import "LoginViewController.h"
#import "LVFmdbTool.h"
#import "CLOrderTool.h"
@interface SettingDetails ()<UIAlertViewDelegate>

@end

@implementation SettingDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor =COLOR_LightGray;
    self.tableView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{

    [self.tableView reloadData];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
   
    }else{
    
        return 1;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.section == 0) {
            cell.textLabel.text = @"关于企业差旅管家";
    }else{
    
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
        cell.textLabel.text = @"退出登录";
        }else{
        cell.textLabel.text = @"登录";
        }
    }
    cell.textLabel.font = fontX(16);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
       
            aboutTripb *tripb = [aboutTripb new];
            [self.navigationController pushViewController:tripb animated:YES];
    }else{
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
        [self ExitLogin];
        }else{
  
            LoginViewController *login = [LoginViewController new];
            
            [self.navigationController pushViewController:login animated:YES];
  
        }
    }
}



- (void)ExitLogin{
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applyOrder" object:nil userInfo:@{@"key":@"NO"}];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upOrder" object:nil userInfo:@{@"key":@"NO"}];
//    清除首页缓存数据
    [JGGchijiuhua JGGshanchuJSONname:@"homeData"];
//    清除行程缓存数据CLOrderTool
    [CLOrderTool deleteData:nil];
   
    [LVFmdbTool deleteData:nil];
  
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"admin.data"] error:nil];
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"phoneNumber.data"]  ;
    StudentModel *student = [StudentModel new];
    student = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    //            归档密码
    student.phone = student.phone;
    student.login  = [NSString stringWithFormat:@"NotLogin"];
    
    [NSKeyedArchiver archiveRootObject:student toFile:file];
    //    NSLog(@"login：%@",student);
    
    [defaultManager removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"admin.data"] error:nil];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url =[NSString stringWithFormat:@"%@/api/user/logout_user.html",[URLstate URLstateWithString]];/*AFNurl(@"/api/user/", @"logout_user");*/
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        NSString *result = [responseObject objectForKeyedSubscript:@"result"];
        if ([@"success"isEqualToString:result]) {
            
            //            NSString *prompt = [responseObject objectForKeyedSubscript:@"errormsg"];
            ZDBombBox *box = [ZDBombBox  new];
            [box bombBoxWithBtn:@"退出登录成功!" UIView:self.view];
            
        }else{
            
            NSString *errormsg = [responseObject objectForKeyedSubscript:@"errormsg"];
            ZDBombBox *box = [ZDBombBox  new];
            [box bombBoxWithBtn:errormsg UIView:self.view];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error=%@",error);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
    
}




@end
