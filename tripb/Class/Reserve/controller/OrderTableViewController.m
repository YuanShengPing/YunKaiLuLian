

#import "OrderTableViewController.h"
#import "OrderCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "orderDataModel.h"
#import "ReachabilityBool.h"
#import "CLOrderTool.h"
#import "LoginViewController.h"
#import "tripDetailsViewController.h"
#import "NotData.h"
#import "DanLi.h"
@interface OrderTableViewController ()<tripDetailsViewControllerDelegate>{
    
    NotData *_notDataImage;
    
}
//默认加载条数
@property (nonatomic,assign) int            limit;

@property (nonatomic,strong) NSMutableArray *orderData;

@property (nonatomic,strong) UILabel        *Prompt;
//登入
@property (nonatomic,strong) UIButton       *login;
//
@property (nonatomic,strong) UIImageView    *NotData;
@end

@implementation OrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _notDataImage = [NotData new];
    _notDataImage.y = (WIDTH / 3 / 279 )* 123 + 30;
    _notDataImage.x =WIDTH / 3;
    _notDataImage.centerX = WIDTH * 0.5 - (_notDataImage.x * 0.5);
    _notDataImage.centerY = HEIGHT * 0.5 - WIDTH / 3 * 0.5 -64;
    _notDataImage.hidden = YES;
    [self.view addSubview:_notDataImage];
     [self notWithLogin];
    //隐藏
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
//    [self setupRefresh];
    
    
    //   加载缓存数据
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        [self.orderData removeAllObjects];
        NSArray *modals = [CLOrderTool queryData:nil];
    
        if (modals.count) {
            [self.orderData addObjectsFromArray:modals];
        }
        [self.tableView reloadData];
        [self setupRefresh];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    //退出登入时，需要清除显示数据
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        self.login.hidden = YES;
        self.Prompt.hidden = YES;
//        [self.tableView reloadData];

        if ([@"UpData" isEqualToString:[DanLi sharedDanLi].UpData]) {
            [DanLi sharedDanLi].UpData  = @"NotUpData";
            self.limit = 15;
            //         self.orderData = nil;
            [self setupRefresh];
        }
    }else{
        self.login.hidden = NO;
        self.Prompt.hidden = NO;
         _notDataImage.hidden= YES;
        self.orderData = nil;
        [self.tableView reloadData];
    }

}


- (NSMutableArray *)orderData{
    if (!_orderData) {
        _orderData = [NSMutableArray array];
    }
    return _orderData;
}

- (int)limit{
    
    if (!_limit) {
        
        _limit = 15 ;
    }
    return _limit;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.orderData.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"orderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.orderData[indexPath.row];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //   解档赋值
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        
        OrderCell *Llist = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];

        tripDetailsViewController *details = [tripDetailsViewController new];
        details.MessageDelegate =self;
        
        [self.navigationController pushViewController:details animated:YES];
        /**
         需要传ID过去
         applyid=15  Llist.model.apply_red_flag
         */

        NSString *url = [NSString stringWithFormat:@"%@/apply/approvedetail.html?apply_id=%@&red_flag=%@",[URLstate URLstateWithString],Llist.ID,Llist.model.apply_red_flag];
        details.tripId =url;
        details.row = (int)indexPath.row;
        
    }else{
        LoginViewController *login = [LoginViewController new];
        
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)remindWithMessage:(int)row NavigationBar:(BOOL)Correct{

    if (Correct) {
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applyOrder" object:nil userInfo:@{@"key":@"NO"}];
    }

    OrderCell *Llist = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
    Llist.model = self.orderData[row];
    Llist.model.apply_red_flag = [NSString stringWithFormat:@"0"];
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:row inSection:0]; //刷新第0段第2行
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];


}


- (void)notWithLogin{
    
    self.Prompt = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.5 -84, WIDTH, 20)];
    self.Prompt.text = @"您还未登录，无法查看申请单信息。";
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
- (void)orderWithData:(int)start limit:(int)limit storing:(BOOL)tripData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@/Api/List/get_applylist/?start=%d&limit=%d",[URLstate URLstateWithString],start,limit]; /*[NSString stringWithFormat:@"%@?start=%d&limit=%d",URLy,start,limit];*/
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"----===>responseObject:%@",responseObject);
        [self requestWithData:responseObject storing:(BOOL)tripData];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"error==>%@",error);
    }];
}

- (void)requestWithData:(id )responseObject storing:(BOOL)tripData{


    NSString *result = [responseObject objectForKey:@"result"];
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableArray *arrayN = [NSMutableArray array];
    if ([@"success" isEqualToString:result]) {
        array = [responseObject objectForKey:@"data"];
        if (array.count > 0) {
            _notDataImage.hidden= YES;
            //                删除缓存
            [CLOrderTool deleteData:nil];
            for (NSDictionary *dict in array) {
                orderDataModel *order = [orderDataModel objectWithKeyValues:dict];
                //                    缓存数据
                if (tripData) {
                    [CLOrderTool insertModel:order];
                }
                [arrayM addObject:order];
                [arrayN addObject:order.apply_red_flag];
            }
            //是否取消导航栏
            if ([arrayN containsObject:[NSString stringWithFormat:@"1"]]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"applyOrder" object:nil userInfo:@{@"key":@"YES"}];
                
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"applyOrder" object:nil userInfo:@{@"key":@"NO"}];
            }
            
            if (tripData) {
                self.orderData = arrayM;
            }else{
                for (int i = 0 ; i<arrayM.count; i++) {
                    
                    [self.orderData addObject:arrayM[i]];
                }
            }
            [self.tableView reloadData];
        }else{
            
            if (tripData) {
                
                _notDataImage.hidden= NO;
                [CLOrderTool deleteData:nil];
                [self.orderData removeAllObjects];
                [self.tableView reloadData];
            }
            
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"亲没有更多数据哦！" UIView:self.view];
        }
    }else{
        ZDBombBox *box = [ZDBombBox  new];
        
        [box bombBoxWithBtn:@"服务器异常" UIView:self.view];
    }


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
            
            [self headerRereshinOrder];
            
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
- (void)headerRereshinOrder{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self orderWithData:0 limit:self.limit storing:YES];
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
                
                
                [self orderWithData:(int)self.orderData.count limit:self.limit+(int)self.orderData.count storing:NO];
                
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
@end
