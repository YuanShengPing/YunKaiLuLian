//
//  SettingsTableViewController.m
//  tripb
//
//  Created by 云开互联 on 16/4/8.
//  Copyright © 2016年 tripb. All rights reserved.


#import "SettingsTableViewController.h"
#import "SettingsTableViewCell.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "ReachabilityBool.h"
#import "LoginViewController.h"
#import "SettingDetails.h"
#import "adminModel.h"
#import "WebViewJSController.h"
#import "personalDataController.h"
#import "MJExtension.h"
#import "JGGchijiuhua.h"
#import "contactWaiterTableViewController.h"
#import "CLOrderTool.h"
#import "LVFmdbTool.h"

@interface SettingsTableViewController ()<UIActionSheetDelegate>{

     Reachability *_networkCon;
}

@property (nonatomic,strong)NSString *userName;

@end

@implementation SettingsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =COLOR_LightGray;
//    网络切换时刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
    _networkCon = [Reachability reachabilityForInternetConnection];
    [_networkCon startNotifier];
}

#pragma mark - 切换网络状态时
- (void)reachabilityChanged{
    
    ReachabilityBool *status = [ReachabilityBool new];
    
    if ([status reachabilityWithStatus]) {
        //   解档赋值
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin] ) {
            [self readUserinfoWithUrl];
        }
    }else{
        
        ZDBombBox *box = [ZDBombBox  new];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        [box bombBoxWithBtn:@"获取数据失败!" UIView:window];
    }
}
- (void)viewWillAppear:(BOOL)animated{

    ReachabilityBool *status = [ReachabilityBool new];
    LoginState *state = [LoginState new];
//     登入状态
    if ([state NotLoginWithLogin]) {
//     网络
        if ([status reachabilityWithStatus]) {
//       是否刷新
          if ([state StateRefreshWithHome] || ![self numberWithRow] ) {
                
         [self readUserinfoWithUrl];
     }
        }
    }else{
    [self.tableView reloadData];
    }
}


- (NSString *)numberWithRow{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"admin.data"];
    adminModel *student = [adminModel new];
    student = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        self.userName = student.name;
    //    NSLog(@"self.userName :%@  student.name:%@",self.userName,student.name);
    return self.userName;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
       
        return 1;
        
    }else{
        LoginState *state = [LoginState new];
        [state LoginStateWithBumber];
    
        if ([state.phone isEqualToString:@"18501374593"] || [state.phone isEqualToString:@"18911201632"] || [state.phone isEqualToString:@"15501267321"] || [state.phone isEqualToString:@"15011380203"] || [state.phone isEqualToString:@"17600854366"] || [state.phone isEqualToString:@"13301021062"] || [state.phone isEqualToString:@"13581931246"] || [state.phone isEqualToString:@"15012469287"] ) {
                return 4;
        }else{
            return 3;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *ID = @"iconCell";
        SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SettingsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        if ([self numberWithRow]) {
            cell.NotLogin.text = nil;
             cell.userName.text = self.userName;
            LoginState *state = [LoginState new];
            if ([state LoginStateWithBumber ]) {
               
                cell.phone.text = state.phone;
            }
        }else {
            cell.NotLogin.text = @"游客";
            cell.userName.text = nil;
            cell.phone.text = nil;
        }
        return  cell;
    }else{
        NSString *ID =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        [self setTingsWithTableView:cell indexPAth:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
}

- (void)setTingsWithTableView:(UITableViewCell *)cell indexPAth:(NSIndexPath *)indexPath{
 
    NSArray *array = [NSArray array];
    NSArray *arrayIcon = [NSArray array];
 
        array = @[@"我的单位",@"联系客服",@"设置",@"开发设置"];
        arrayIcon = @[@"company",@"WechatIMG1",@"p15",@"p15"];

        for (int i=0; i<array.count; i++) {
            
            if (indexPath.row == i) {
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@",array[i]];
                UIImage *icon = [UIImage imageNamed:arrayIcon[i]];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                CGSize itemSize = CGSizeMake(20, 20);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [icon drawInRect:imageRect];
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, 10)];
    view.backgroundColor = COLOR_LightGray;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoginState *state = [LoginState new];
        if (indexPath.section == 0) {
            if ([state NotLoginWithLogin]) {
            //                点击我的头像user/myself
            personalDataController *personal = [personalDataController new] ;
            [self.navigationController pushViewController:personal animated:YES];

            }else{
                LoginViewController *login = [LoginViewController new];
                
                [self.navigationController pushViewController:login animated:YES];
            }
        }else if (indexPath.section == 1) {
           
            if(indexPath.row == 0){
             if ([state NotLoginWithLogin]) {
                [self webviewWithURL:@"Enterprise/show"];
             }else{
             
                 LoginViewController *login = [LoginViewController new];
                 
                 [self.navigationController pushViewController:login animated:YES];
             }
            }else if(indexPath.row == 1){
//             if ([state NotLoginWithLogin]) {
                 /**
                  联系客服
                  */
                 contactWaiterTableViewController *contact = [contactWaiterTableViewController new];
                 
                 [self.navigationController pushViewController:contact animated:YES];
           
//             }else{
//                 LoginViewController *login = [LoginViewController new];
//                 
//                 [self.navigationController pushViewController:login animated:YES];
//             }
            }else if(indexPath.row == 2){
                
                SettingDetails *setting = [SettingDetails new];
                [self.navigationController pushViewController:setting animated:YES];
            }else{
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"您当前环境是%@",[DanLi sharedDanLi].UpEnvironmental] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"http://mantis.test.tripb.cn",@"http://monkey.test.tripb.cn",@"http://pre.tripb.cn",@"http://master.test.tripb.cn",@"http://m.tripb.cn", nil];
                [sheet showInView:self.view];
            
            }
            
        }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

        if(buttonIndex == 0){
            NSLog(@"http://mantis.test.tripb.cn");
            [self ExitLogin];
            [DanLi sharedDanLi].UpEnvironmental = @"mantis";
            
    
        }else if (buttonIndex == 1){
    
            NSLog(@"http://monkey.test.tripb.cn");
            [self ExitLogin];
           [DanLi sharedDanLi].UpEnvironmental = @"monkey";
            
    
        }else if (buttonIndex == 2){
            
             NSLog(@"http://pre.tripb.cn");
            [self ExitLogin];
            [DanLi sharedDanLi].UpEnvironmental = @"pre";
         
        }else if (buttonIndex == 3){
    
             NSLog(@"http://master.test.tripb.cn");
            [self ExitLogin];
            [DanLi sharedDanLi].UpEnvironmental = @"master";

        }else if (buttonIndex == 4){
            
            NSLog(@"http://m.tripb.cn");
            [self ExitLogin];
            [DanLi sharedDanLi].UpEnvironmental = @"m";
            
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

//分割线左移
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)webviewWithURL:(NSString *)url{
    
    WebViewJSController *WebView = [WebViewJSController new];
    [self.navigationController pushViewController:WebView animated:YES];
    WebView.url = url;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}
//获取用户数据
- (void)readUserinfoWithUrl{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *phone = [NSString string];
    LoginState *state = [LoginState new];
    if ([state LoginStateWithBumber ]) {
        
        phone = state.phone;
    }
    //                           get_userinfo
    //#define URLt [NSString stringWithFormat:@"%@/api/user/",URLw]
    //#define AFNurlTwo(url,phone)  [NSString stringWithFormat:@"%@%@.html?keys=%@",URLt,url,phone]
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/get_userinfo.html?keys=%@",[URLstate URLstateWithString],phone];/*AFNurlTwo(@"get_userinfo",phone);*/
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"--responseObject:%@",responseObject);
        NSString *success = [responseObject objectForKey:@"result"];
        if ([@"success" isEqualToString:success]) {
    
             [JGGchijiuhua JGGshanchuJSONname:@"homeData"];
            //     3.调用方法保存
            [JGGchijiuhua JGGbocunJSONname:@"homeData" shuzu:responseObject];
            
            NSString *code = [[responseObject objectForKey:@"userinfo"] objectForKey:@"nickname"];
          
            NSArray *admin = [[responseObject objectForKey:@"userinfo"] objectForKey:@"roles"];
           
            if ([admin containsObject:@"e.admin"]) {
                [self addwithfile:[NSString stringWithFormat:@"YESAdmin"]  phoneNumber:code];
            }else{
                [self addwithfile:[NSString stringWithFormat:@"NotAdmin" ] phoneNumber:code];
            }
       
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        ZDBombBox *box = [ZDBombBox  new];
        
        [box bombBoxWithBtn:@"获取数据失败！" UIView:self.view];
    }];
    
    [self.tableView reloadData];
}

- (void)addwithfile:(NSString *)fileAdmin phoneNumber:(NSString *)number{
    
    adminModel *admin = [adminModel new];
    //             删除归档数据
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"admin.data"];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"admin.data"] error:nil];
    //            归档手机号码
    admin.name = number;
    admin.admin = fileAdmin ;
    [NSKeyedArchiver archiveRootObject:admin toFile:file];
    
    [self.tableView reloadData];
}

@end
