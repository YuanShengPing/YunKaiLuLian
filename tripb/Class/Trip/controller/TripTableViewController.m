//
//  TripTableViewController.m
//  tripb
//
//  Created by 云开互联 on 16/4/8.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "TripTableViewController.h"
#import "MJRefresh.h"
#import "listTripCell.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "ReachabilityBool.h"
#import "LoginViewController.h"
#import "tripbHistModel.h"
#import "MJExtension.h"
#import "tripDetailsViewController.h"
#import "FMDB.h"
#import "LVFmdbTool.h"
#import "NotData.h"
#import "DanLi.h"
#import "LoginViewController.h"

@interface TripTableViewController ()<tripDetailsViewControllerDelegate>{

    NotData *_notDataImage;

}

@property (nonatomic,strong) NSMutableArray *tripbData;

//默认加载条数
@property (nonatomic,assign) int            limit;

@property (nonatomic,strong) UILabel        *Prompt;

@property (nonatomic,strong) UIButton       *login;

@end

@implementation TripTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _notDataImage = [NotData new];
    _notDataImage.y = (WIDTH / 3 / 279 )* 123 + 30;
    _notDataImage.x =WIDTH / 3;
    _notDataImage.centerX = WIDTH * 0.5 - (_notDataImage.x *0.5);
    _notDataImage.centerY = HEIGHT * 0.5 - WIDTH / 3* 0.5 -64;
    _notDataImage.hidden = YES;
    [self.view addSubview:_notDataImage];
    
    //隐藏
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
     [self notWithLogin];
//   加载缓存数据
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        [self.tripbData removeAllObjects];
        NSArray *modals =[LVFmdbTool queryData:nil];
        if (modals.count) {
            [self.tripbData addObjectsFromArray:modals];
        }
        [self.tableView reloadData];
        [self setupRefresh];
    }

}




- (int)limit{
    if (!_limit) {
        
        _limit = 15 ;
    }
    return _limit;
}
- (NSMutableArray *)tripbData{
    if (!_tripbData) {
        _tripbData = [[NSMutableArray alloc]init];
    }
    return _tripbData;
}

- (void)viewWillAppear:(BOOL)animated{
    //退出登入时，需要清除显示数据
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        self.login.hidden = YES;
        self.Prompt.hidden = YES;
        //    更新订单
        if ([@"UpOrder" isEqualToString:[DanLi sharedDanLi].UpOrder]) {
            [DanLi sharedDanLi].UpOrder  = @"NotOrder";
            self.limit = 15;
            //        self.tripbData = nil;
            [self setupRefresh];
        }
    }else{
        self.login.hidden = NO;
        self.Prompt.hidden = NO;
        _notDataImage.hidden = YES;
        self.tripbData = nil;
        [self.tableView reloadData];
    }
}

- (void)notWithLogin{
    self.Prompt = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.5 -84, WIDTH, 20)];
    self.Prompt.text = @"您还未登录，无法查看订单信息。";
    self.Prompt.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:self.Prompt];
    
    self.login = [[UIButton alloc]init];
    self.login.width = 120;
    self.login.height = 30;
    self.login.centerX = self.view.centerX ;
    self.login.y = HEIGHT * 0.5 - 54;
    [self.login setTitle:@"点击登录>>" forState:UIControlStateNormal];
    [self.login setTitleColor:COLOR_DeepBlue forState:UIControlStateNormal];
    [self.login addTarget:self action:@selector(loginWithPrompt) forControlEvents:UIControlEventTouchDown];
    [self.tableView addSubview:self.login];
}

- (void)loginWithPrompt{
    LoginViewController *log = [LoginViewController new];
    [self.navigationController pushViewController:log animated:YES];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tripbData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    listTripCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
    cell = [[listTripCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.tripbData[indexPath.row];

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//            解档赋值
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
            
            listTripCell *Llist = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
            
            tripDetailsViewController *details = [tripDetailsViewController new];
            details.MessageDelegate = self;
            [self.navigationController pushViewController:details animated:YES];
//             需要传ID过去
//            [NSString stringWithFormat:@"%@/%@.html",URLw,url]
            NSString *url  = [NSString stringWithFormat:@"%@/order/detail.html?order_id=%@&red_flag=%@",[URLstate URLstateWithString],Llist.ID,Llist.model.order_red_flag];
            details.tripId =url;
            details.row = (int)indexPath.row;
        }else{
            LoginViewController *login = [LoginViewController new];
            
            [self.navigationController pushViewController:login animated:YES];
        }
}

- (void)orderWithMessage:(int)row NavigationBar:(BOOL)Correct{

    if (Correct) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upOrder" object:nil userInfo:@{@"key":@"NO"}];
    }
    listTripCell *Llist = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
    Llist.model = self.tripbData[row];
    Llist.model.order_red_flag = [NSString stringWithFormat:@"0"];
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:row inSection:0]; //刷新第0段第2行
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];

}

//2.订单列表接口
//地址：/Api/List/get_orderlist
//参数:1.start 分页开始记录位置 默认0  2.limit  分页条数，默认10
//测试地址：http://fox.test.tripb.cn/Api/List/get_orderlist/
//暂时自动登录ID为1的用户
- (void)TripWithData:(int)start limit:(int)limit storing:(BOOL)tripData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/Api/List/get_orderlist.html",[URLstate URLstateWithString]];/*AFNurl(@"/Api/List/", @"get_orderlist");*/
    NSString *urlStr = [NSString stringWithFormat:@"%@?start=%d&limit=%d",url,start,limit];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"----===>responseObject:%@",responseObject);
        NSString *result       = [responseObject objectForKey:@"result"];
        NSMutableArray *array  = [NSMutableArray array];
        NSMutableArray *arrayM = [NSMutableArray array];
        NSMutableArray *arrayN  = [NSMutableArray array];
        if ([@"success" isEqualToString:result]) {
            array = [responseObject objectForKey:@"data"];
            if (array.count > 0) {
                _notDataImage.hidden= YES;
//                删除缓存
                 [LVFmdbTool deleteData:nil];
                for (NSDictionary *dict in array) {
                    tripbHistModel *model = [tripbHistModel objectWithKeyValues:dict];
//                   缓存数据
                    if (tripData) {
                        [LVFmdbTool insertModel:model];
                    }
                    [arrayM addObject:model];
                    [arrayN addObject:model.order_red_flag];
                }
                //是否取消导航栏
                if ([arrayN containsObject:[NSString stringWithFormat:@"1"]]) {
                    
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"upOrder" object:nil userInfo:@{@"key":@"YES"}];
                    
                }else{
                
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"upOrder" object:nil userInfo:@{@"key":@"NO"}];
                }

                if (tripData) {
                self.tripbData  = arrayM;
                    
                }else{
                    for (int i = 0 ; i<arrayM.count; i++) {
                        
                        [self.tripbData addObject:arrayM[i]];
                    }
                }
                [self.tableView reloadData];
            }else{
                if (tripData) {
                    
                    _notDataImage.hidden= NO;
                    [LVFmdbTool deleteData:nil];
                    [self.tripbData removeAllObjects];
                    [self.tableView reloadData];
                    
                }
                ZDBombBox *box = [ZDBombBox  new];
                
                [box bombBoxWithBtn:@"亲没有更多数据哦！" UIView:self.view];
            }
        }else{
            
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"服务器异常" UIView:self.view];
        }
   
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error==>%@",error);
    }];
    
}




/**
 *  集成刷新控件
 */
- (void)setupRefresh{
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(dataWithRefresh)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    //2.上拉加载更多(进入刷新状态就 会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];

    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在拼命加载中.....";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在拼命加载中....";
}

- (void)dataWithRefresh{

    ReachabilityBool *status = [ReachabilityBool new];
    if ([status reachabilityWithStatus]) {
        //   解档赋值
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
            
            [self headerRereshin];
            
        }else{
            
            [self.tableView headerEndRefreshing];
            
            ZDBombBox *box = [ZDBombBox  new];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [box bombBoxWithBtn:@"请检查登录状况!" UIView:self.view];
            });
        }
    }else{
        
        [self.tableView headerEndRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"请检查网络状况!" UIView:self.view];
        });
        
    }
    
}

- (void)headerRereshin{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self TripWithData:0 limit:self.limit storing:YES];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        
    });
    
}
- (void)footerRereshing{
    
    ReachabilityBool *status = [ReachabilityBool new];
    if ([status reachabilityWithStatus]) {
        
        //   解档赋值
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
            
            
            // 2.2秒后刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                [self TripWithData:(int)self.tripbData.count limit:self.limit+(int)self.tripbData.count storing:NO];
                
                // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                [self.tableView footerEndRefreshing];
            });
            
        }else{
            
            [self.tableView headerEndRefreshing];
            
            ZDBombBox *box = [ZDBombBox  new];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [box bombBoxWithBtn:@"请检查登录状况!" UIView:self.view];
            });
        }
    }else{
    
        [self.tableView footerEndRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"请检查网络状况!" UIView:self.view];
        });
        
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}

//- (void)tripWithData {
//    
//    // 0.获得沙盒中的数据库文件名
//    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"trip.sqlite"];
//    NSLog(@"filename:%@",filename);
//    // 1.创建数据库队列
//    _db = [FMDatabase databaseWithPath:filename];
//    BOOL flag = [_db open];
//    if (flag) {
//        NSLog(@"数据库打开成功");
//    }else{
//        NSLog(@"数据库打开失败");
//    }
////    id text,airline text,depCity text,arrTime text,depTimeShort text,depTime text,transNumber text,arrPort text,type text,arrTimeShort text,arrCity text,depPort text,currentTrip text,hotelName text,city text,hotelPhone text,inTime text,hotelAddress text,inTimeShort text
//    // 2.创表
//        BOOL result =  [_db executeUpdate:@"create table if not exists t_health(SerialNumber integer primary key  autoincrement,id text ,airline text,depCity text,arrTime text,depTimeShort text,depTime text,transNumber text,arrPort text,type text,arrTimeShort text,arrCity text,depPort text,currentTrip text,hotelName text,city text,hotelPhone text,inTime text,hotelAddress text,inTimeShort text)"];
//        if (result) {
//            NSLog(@"创表成功");
//        } else {
//            NSLog(@"创表失败");
//        }
//  
//    BOOL insert =[_db executeUpdate:@"insert into t_health (id,airline,depCity,arrTime,depTimeShort,depTime,transNumber,arrPort,type,arrTimeShort,arrCity,depPort,currentTrip,hotelName,city,hotelPhone,inTime,hotelAddress,inTimeShort) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了",@"登记方式更好看了"];
//    
//    if (insert) {
//        NSLog(@"插入数据成功");
//    }else{
//        NSLog(@"插入数据失败");
//    }
//
//}

@end
