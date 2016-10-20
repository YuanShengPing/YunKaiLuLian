  //
//  HomeViewController.m
//  tripb
//
//  Created by 云开互联 on 16/4/21.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LoginState.h"
#import "LoginViewController.h"
#import "UIView+MGBadgeView.h"
#import "ReserveViewController.h"
#import "MJExtension.h"
#import "Reachability.h"
#import "ZDBombBox.h"
#import "ReachabilityBool.h"
#import "orderViewController.h"
#import "adminModel.h"
#import "tripDetailsViewController.h"
#import "WebViewJSController.h"
#import "JGGchijiuhua.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DanLi.h"
#import "LVFmdbTool.h"
#import "TravelWebView.h"

@interface HomeViewController ()<UINavigationControllerDelegate,WebViewJSControllerDelegata>{
    LoginViewController *bViewController;
    Reachability        *_networkConn;
}

@property (nonatomic,strong ) UIButton     *adminBtn;
@property (nonatomic,copy   ) NSString     *loginH;
//判断用户是否登入
@property (nonatomic,assign ) BOOL         isLogin;

@property (nonatomic,strong ) UIScrollView *ScrollView;

@property (nonatomic,strong ) LoginState   *state;
//titleView
@property (nonatomic,strong ) UIView       *titleView;
//图片bg_flight
@property (nonatomic,strong ) UIImageView  *tools;
//提示语
@property (nonatomic,strong ) UILabel      *indexText;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    初始化数据
    [self homeWithData];
//    判断登入与否
    ReachabilityBool *status = [ReachabilityBool new];
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        [self homeDataWithInit];
        if ([status reachabilityWithStatus]) {
            [self urlWithLogin];
        }else{
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"获取首页数据失败!" UIView:self.view];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        if ([state StateRefreshWithHome]) {
            [self urlWithLogin];
            StateRefresh *Refresh = [StateRefresh new];
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"RefreshHome.data"];
            //            归档手机号码
            Refresh.StateRefresh = [NSString stringWithFormat:@"NotRefresh"];
            [NSKeyedArchiver archiveRootObject:Refresh toFile:file];
        }else  if ([@"UphomeData" isEqualToString:[DanLi sharedDanLi].UpData]) {
            [DanLi sharedDanLi].UpOrder  = @"NotUphomeData";
            [self urlWithLogin];
        }
    }else{
            //       初始化首页数据
            [self.adminBtn.badgeView setBadgeValue:0];
    }
}

- (void)homeWithData{
    self.view.backgroundColor = [UIColor whiteColor];
//    self.fd_prefersNavigationBarHidden = YES;
    self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 44)];
    [self.view addSubview:self.ScrollView];
    self.ScrollView.showsHorizontalScrollIndicator = YES;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.contentSize =  CGSizeMake(0, HEIGHT * 0.3 + 300);
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT * 0.3)];
    [self.ScrollView addSubview:self.titleView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
     _networkConn = [Reachability reachabilityForInternetConnection];
    [_networkConn startNotifier];
    
    self.tools = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT * 0.3 )];
    self.tools.image = [UIImage imageNamed:@"home_bg"];
    [self.titleView addSubview:self.tools];
    
    UIView *fooView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT * 0.3 - 50, WIDTH, 50)];
    fooView.backgroundColor = [UIColor grayColor];
    fooView.alpha = 0.5;
    [self.titleView addSubview:fooView];
//
    self.indexText = [[UILabel alloc]initWithFrame:CGRectMake(5, HEIGHT * 0.3 - 50, WIDTH - 10, 50)];
    self.indexText.text = @"华南地区航班延误情况严重,在差旅管家预定的机票免费赠送延误险。有效时间：7月1日 -- 7月31日";
    self.indexText.numberOfLines = 0 ;
    self.indexText.textColor = [UIColor whiteColor];
    self.indexText.font = fontX(14);
    [self.titleView addSubview:self.indexText];
    
    UIView *Splitline = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT * 0.3, WIDTH,300)];
    Splitline.backgroundColor = [UIColor whiteColor];
    [self.ScrollView addSubview:Splitline];
    
    UIView *tripView = [[UIView alloc]initWithFrame:CGRectMake(10,100, WIDTH - 20, 1)];
    tripView.backgroundColor =[UIColor colorWithHexString:@"DCDCDC"];
    [Splitline addSubview:tripView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 200, WIDTH - 20, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    [Splitline addSubview:lineView];
    
    UIButton *system = [UIButton buttonWithType:UIButtonTypeCustom];
    system.frame = CGRectMake(WIDTH - 120, 33, 90, 34);
    [system.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [system.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
    [system.layer setBorderColor:colorref];//边框颜色
    [system setTitle:@"差旅制度" forState:UIControlStateNormal];
    [system setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    system.titleLabel.font = fontX(15);
    [system setImage:[UIImage imageNamed:@"Prompt"] forState:UIControlStateNormal];
    [system addTarget:self action:@selector(functionWithTouchButton:) forControlEvents:UIControlEventTouchDown];
    system.tag = 101;
    [Splitline addSubview:system];
    
    UIImageView *travelImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 25, 50, 50)];
    [Splitline addSubview:travelImage];
    travelImage.image = [UIImage imageNamed:@"home_apply"];
    
    UILabel *travelText = [[UILabel alloc]initWithFrame:CGRectMake(90, 20, WIDTH - 210, 30)];
    travelText.text = @"出差申请";
    travelText.font = fontX(20);
    [Splitline addSubview:travelText];
    
    UILabel *describe = [[UILabel alloc]initWithFrame:CGRectMake(90, 55, WIDTH - 210, 20)];
    describe.text = @"移动申请 随时出行";
    describe.font = fontX(14);
    describe.textColor = [UIColor grayColor];
    [Splitline addSubview:describe];
    UIButton *travelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, WIDTH - 130, 100)];
    [Splitline addSubview:travelBtn];
    travelBtn.tag = 100;
    [travelBtn addTarget:self action:@selector(functionWithTouchButton:) forControlEvents:UIControlEventTouchDown];
    

    UIImageView *costImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 125, 50, 50)];
    [Splitline addSubview:costImage];
    costImage.image = [UIImage imageNamed:@"home_expenses"];
    
    UILabel *costText = [[UILabel alloc]initWithFrame:CGRectMake(90, 120, WIDTH - 210, 30)];
    costText.text = @"我的费用";
    costText.font = fontX(20);
    [Splitline addSubview:costText];
    
    UILabel *costDescribe = [[UILabel alloc]initWithFrame:CGRectMake(90, 155, WIDTH - 180, 20)];
    costDescribe.text = @"所用的差旅费用列表";
    costDescribe.font = fontX(14);
    costDescribe.textColor = [UIColor grayColor];
    [Splitline addSubview:costDescribe];
    UIButton *costBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, WIDTH - 20, 100)];
    [Splitline addSubview:costBtn];
    costBtn.tag = 102;
    [costBtn addTarget:self action:@selector(functionWithTouchButton:) forControlEvents:UIControlEventTouchDown];
  
    
    UIView *Administration = [[UIView alloc]initWithFrame:CGRectMake(WIDTH / 2, 220, 1, 65)];
    Administration.backgroundColor = [UIColor colorWithHexString:@"DCDCDC"];
    [Splitline addSubview:Administration];
  #pragma 角标
    self.adminBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH * 0.25 - 25, 220, 50, 50)];
    [Splitline addSubview:self.adminBtn];
    [self.adminBtn setBackgroundImage:[UIImage imageNamed:@"home_approve"] forState:UIControlStateNormal];
    
    [self.adminBtn.badgeView setOutlineWidth:0.0];
    [self.adminBtn.badgeView setPosition:MGBadgePositionTopRight];
    [self.adminBtn.badgeView setOutlineColor:[UIColor yellowColor]];
    [self.adminBtn.badgeView setBadgeColor:[UIColor redColor]];
    [self.adminBtn.badgeView setTextColor:[UIColor whiteColor]];
//    [self.adminBtn.badgeView setFont:[UIFont systemFontOfSize:20]];
    
    UILabel *adminText  = [UILabel new];
    adminText.text = @"出差审批";
    adminText.centerX = WIDTH * 0.25 - 40;
    adminText.y  = 275;
    adminText.height = 20;
    adminText.width = 80;
    adminText.textAlignment = NSTextAlignmentCenter;
    [Splitline addSubview:adminText];

    UIButton *adminBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH * 0.25 - 45, 200, 90, 100)];
    [Splitline addSubview:adminBtn];
    adminBtn.tag = 103;
    [adminBtn addTarget:self action:@selector(functionWithTouchButton:) forControlEvents:UIControlEventTouchDown];
    
    UIImageView *teamView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * 0.75 - 25, 220, 50, 50)];
    [Splitline addSubview:teamView];
    teamView.image = [UIImage imageNamed:@"home_team"];
    
    UILabel *team  = [UILabel new];
    team.text = @"团队差旅";
    team.centerX = WIDTH * 0.75 - 40;
    team.y  = 275;
    team.height = 20;
    team.width = 80;
    team.textAlignment = NSTextAlignmentCenter;
    [Splitline addSubview:team];
    
    UIButton *teamBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH * 0.75 - 45, 200, 90, 100)];
    [Splitline addSubview:teamBtn];
    teamBtn.tag = 104;
    [teamBtn addTarget:self action:@selector(functionWithTouchButton:) forControlEvents:UIControlEventTouchDown];
   
}
- (void)functionWithTouchButton:(UIButton *)btn{

    
    NSDictionary *res = [JGGchijiuhua JGGhuoquJSONname:@"homeData"];
    
    NSDictionary *userinfo = [res objectForKey:@"userinfo"];
    
    NSArray *roles = [userinfo objectForKey:@"roles"];
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        
        if (btn.tag==100) {
            
            NSLog(@"出差申请");
//       z [self webviewWithURL:@"apply/apply"];
            TravelWebView *Travel = [TravelWebView new];
            [self.navigationController pushViewController:Travel animated:YES];
        }else if(btn.tag==101){
//            NSLog(@"差旅制度");Rule/show
            [self webviewWithURL:@"Rule/show" Delegate:NO];
        }else if(btn.tag==102){
//         NSLog(@"我的费用");  /Fee/myfee
            [self webviewWithURL:@"/Fee/myfee" Delegate:NO];
     
        }else if(btn.tag==103){
          
            if ([roles containsObject:@"a.approve"]) {
//                代理，用于记录审批条数
            
            [self webviewWithURL:@"apply/approvelst" Delegate:YES];
                
            }else{
                ZDBombBox *box = [ZDBombBox  new];
                
                [box bombBoxWithBtn:@"您没有开通该权限!" UIView:self.view];
            }
//              NSLog(@"差旅审批");
        }else if(btn.tag==104){
            
            if ([roles containsObject:@"a.approve"]) {
//         NSLog(@"团队差旅");http://fox.test.tripb.cn/Fee/teamfee
                [self webviewWithURL:@"Fee/teamfee" Delegate:YES];
                
            }else{
                ZDBombBox *box = [ZDBombBox  new];
                
                [box bombBoxWithBtn:@"您没有开通该权限!" UIView:self.view];
            }
        }
    }else{
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
}
- (void)webviewWithURL:(NSString *)url Delegate:(BOOL) state{
   
    WebViewJSController *WebView = [WebViewJSController new];
    
    if (state) {
        WebView.WebDelegate = self;
    }
    [self.navigationController pushViewController:WebView animated:YES];
    WebView.url = url;
}
//代理
- (void)homeWithIndex{

    [self readUserinfoWithUrl];

}


- (void)reachabilityChanged{
    
    ReachabilityBool *status = [ReachabilityBool new];
    
    if ([status reachabilityWithStatus]) {
        //   解档赋值
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
            
            [self urlWithLogin];
            
        }
    }
}

- (void)homeDataWithInit{
        NSDictionary *marr=[NSDictionary dictionary];
        //    提示  获取文件的时候要记住以前的保存文件名 如果忘记可根据打印的路径查找
        marr=[JGGchijiuhua JGGhuoquJSONname:@"homeData"];
        if (marr != nil) {
            [self AssignmentControl];
        }
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
     NSString *url = AFNurlTwo(@"get_userinfo",phone);
//    NSLog(@"url:%@",url);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回的结果:JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"===>%@",responseObject);
        NSString *success = [responseObject objectForKey:@"result"];
        if ([@"success" isEqualToString:success]) {
            [JGGchijiuhua JGGshanchuJSONname:@"homeData"];
            //     3.调用方法保存
            [JGGchijiuhua JGGbocunJSONname:@"homeData" shuzu:responseObject];
        
            [self AssignmentControl];
        }else{
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"首页数据获取失败!" UIView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
    }];
}
//#pragma message "Warning 1"
//#warning  赋值首页数据
//#error "Something wrong"

- (void)AssignmentControl{
    
    NSDictionary *res = [JGGchijiuhua JGGhuoquJSONname:@"homeData"];
    
    NSDictionary *userinfo = [res objectForKey:@"userinfo"];
    
    self.indexText.text =  [userinfo objectForKey:@"latestmsg"];
    
    NSDictionary *applysummary = [userinfo objectForKey:@"applysummary"];
    NSString *count = [[applysummary objectForKey:@"needapprove"]objectForKey:@"count"];
    if (count.intValue) {
        
        [self.adminBtn.badgeView setBadgeValue:count.intValue];
    }else{
        [self.adminBtn.badgeView setBadgeValue:0];
    }
    
    NSArray *roles = [userinfo objectForKey:@"roles"];
    NSString *name = [userinfo objectForKey:@"nickname"];
    if ([roles containsObject:@"a.approve"]) {
        
        [self addwithfile:[NSString stringWithFormat:@"YESAdmin"] name:name];
    }else{
        [self addwithfile:[NSString stringWithFormat:@"NotAdmin"] name:name];
    }
}
- (void)addwithfile:(NSString *)fileAdmin name:(NSString *)name{
    
    adminModel *admin = [adminModel new];
//             删除归档数据
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"admin.data"];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"admin.data"] error:nil];
//            归档手机号码
    admin.name  = name;
    admin.admin = fileAdmin ;
    [NSKeyedArchiver archiveRootObject:admin toFile:file];
}


-(void)urlWithLogin{
    
    NSString *URL = AFNurl(@"/api/user/", @"check_logstatus");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        login  logout
        NSString *success = [responseObject objectForKey:@"result"];
        if ([@"success" isEqualToString:success]) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSString *logstatus = [data objectForKey:@"logstatus"];
                        if ([@"login" isEqualToString:logstatus]) {
NSLog(@"***************************用户已经登录成功*******************************");
                [self readUserinfoWithUrl];

            }else{
//                清除本地登入状态
                [self exitLoginWithPwd];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"用户没用登入成功：%@",error);

    }];
}
- (void)exitLoginWithPwd{
    //    清除首页缓存数据
    [JGGchijiuhua JGGshanchuJSONname:@"homeData"];
    //    清除行程缓存数据
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存泄露");
}

@end
