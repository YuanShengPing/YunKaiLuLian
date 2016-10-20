//
//  SearchCityViewController.m
//  tripb
//
//  Created by 云开互联 on 16/5/11.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "SearchCityViewController.h"
#import "CCLocationManager.h"
#import "FMDB.h"
#import "YKHLSaerchLetter.h"
#import <sqlite3.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
@interface SearchCityViewController ()<CLLocationManagerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationmanager;
}
@property (nonatomic,strong ) UIView          *viewsearch;

@property (nonatomic,strong ) UITextField     *City;

@property (nonatomic,strong ) UIScrollView    *scroll;

@property (nonatomic, strong) FMDatabaseQueue *db;

@property (nonatomic,strong ) NSMutableArray  *arrayCity;

@property (nonatomic,strong ) UITableView     * tableView;


@property (nonatomic,strong ) UIButton        *confirm;
@end

@implementation SearchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"城市或目的地";
    [self lbsdidload];
    [self LBS];
    //    输入框
    [self searchView];
    [self tableViewNew];
    
    [self ViewNew];
    
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPinchGestureRecognizer)];//定义一个手势
    //    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    //    [self.view addGestureRecognizer:tap];
}



- (void)ViewNew{
    
    NSArray  *CityNew = @[@"北京",@"上海",@"广州",@"深圳",@"长沙",@"杭州",@"天津",@"海口",@"南昌",@"郑州",@"昆明",@"成都",@"重庆",@"厦门",@"武汉",@"西安"];
    
    CGFloat kWIDTH = WIDTH;
    
    UIView *DataView = [[UIView alloc]initWithFrame:CGRectMake(5, 44, kWIDTH - 10, 176)];
    // 每一个格子的宽/高
    CGFloat BtnW = (kWIDTH - 13)/4;
    CGFloat BtnH = 44 ;
    for (int i = 0; i < CityNew.count; i++) {
        // 确定格子所在的行和列
        int col =i % 4;
        int row = i / 4;
        // 确定每一个格子的X和Y
        CGFloat BtnX = (BtnW +1 )* col;
        CGFloat BtnY = (BtnH + 1) * row;
        
        UIButton *BtnView = [[UIButton alloc] initWithFrame:CGRectMake(BtnX, BtnY, BtnW, BtnH)];
        [BtnView setTitle:CityNew[i] forState:UIControlStateNormal];
        [BtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        BtnView.titleLabel.font = [UIFont systemFontOfSize:16];
        [BtnView setTitleColor:[UIColor colorWithRed:75/255 green:75/255 blue:75/255 alpha:1]forState:UIControlStateNormal];
        [BtnView addTarget:self action:@selector(remenWithCity:) forControlEvents:UIControlEventTouchUpInside];
        BtnView.backgroundColor = [UIColor whiteColor];
        [BtnView setBackgroundImage:[UIImage imageNamed:@"sousuo2_03"] forState:UIControlStateSelected];
        
        [DataView addSubview:BtnView];
        
    }
    [self.scroll addSubview:DataView];
    
    
    [self zimufenlei];
}


- (void)zimufenlei{
    NSArray  *NewCity = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    
    CGFloat kWIDTH = [UIScreen mainScreen].bounds.size.width;
    
    UIView *DataView = [[UIView alloc]initWithFrame:CGRectMake(5, 266, kWIDTH - 10, 308)];
    // 每一个格子的宽/高
    CGFloat BtnW = (kWIDTH -13)/4;
    CGFloat BtnH = 44 ;
    for (int i = 0; i < 22; i++) {
        // 确定格子所在的行和列
        int col =i % 4;
        int row = i / 4;
        // 确定每一个格子的X和Y
        CGFloat BtnX = (BtnW +1 )* col;
        CGFloat BtnY = (BtnH + 1) * row;
        
        UIButton *BtnView = [[UIButton alloc] initWithFrame:CGRectMake(BtnX, BtnY, BtnW, BtnH)];
        [BtnView setTitle:NewCity[i] forState:UIControlStateNormal];
        [BtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        BtnView.titleLabel.font = [UIFont systemFontOfSize:16];
        [BtnView setTitleColor:[UIColor colorWithRed:75/255 green:75/255 blue:75/255 alpha:1]forState:UIControlStateNormal];
        BtnView.tag =i;
        [BtnView addTarget:self action:@selector(classViewClick:) forControlEvents:UIControlEventTouchUpInside];
        BtnView.backgroundColor = [UIColor whiteColor];
        [BtnView setBackgroundImage:[UIImage imageNamed:@"sousuo2_03"] forState:UIControlStateSelected];
        
        [DataView addSubview:BtnView];
        
    }
    [self.scroll addSubview:DataView];
}

- (void)remenWithCity:(UIButton *)btn{
    [self.City resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
    JSValue *picCallback = self.jsOc[@"area"];
    if (picCallback != nil ||  ![picCallback isEqual:[NSNull null]]) {
        if ([NSString stringWithFormat:@"%@",btn.titleLabel.text]) {
           [picCallback callWithArguments:@[btn.titleLabel.text,self.pla]];
        }
//        NSLog(@"完成 - %@", [NSThread currentThread]);
    }else{
    
        NSLog(@"失败：%@ - %@ - %@",picCallback,btn.titleLabel.text,self.pla);
    }
    
}
/**
 @param btn	<#btn description#>
 */
- (void)classViewClick:(UIButton *)btn{
    
    NSArray  *NewCity =@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    
    NSString *str = [NewCity[btn.tag] uppercaseString];
    //
    NSString *deleteStatement = [self getDatabasePath];
    
    FMDatabase *db = [FMDatabase databaseWithPath:deleteStatement];
    [db open];
    FMResultSet *rs;
    //航班tool：toolPlane  动车：toolTrain 住宿：toolHotel
    //    飞机
    if ([self.tool isEqualToString:@"toolPlane"]) {
        rs=[db executeQuery:[NSString stringWithFormat:@"select * from flight where name like '%@%%' or pinyin like '%@%%'",str,str]];
    }else if([self.tool isEqualToString:@"toolTrain"]){
        //    火车
        //        FMResultSet *rs=[db executeQuery:@"SELECT * FROM station"];
        rs=[db executeQuery:[NSString stringWithFormat:@"select * from station where name like '%@%%' or pinyin like '%@%%'",str,str]];
    }else{
        //    住宿酒店
        rs=[db executeQuery:[NSString stringWithFormat:@"select * from city where name like '%@%%' or pinyin like '%@%%'",str,str]];
    }
 
    self.arrayCity = [NSMutableArray array];
    while ([rs next]){
        
        [self.arrayCity addObject:[rs stringForColumn:@"name"]];
        
//        NSLog(@"%@",[rs stringForColumn:@"name"]);
    }
    
    
    [rs close];
    
    
    YKHLSaerchLetter *Letter = [YKHLSaerchLetter new];
    [self.navigationController pushViewController:Letter animated:NO];
    Letter.letterCity = self.arrayCity;
    Letter.pla = self.pla;
    Letter.jsOc = self.jsOc;
    Letter.letter =str;
}
- (void)tableViewNew{
    
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49)];
    self.scroll.contentSize =  CGSizeMake(0, 600);
    self.scroll.showsVerticalScrollIndicator = FALSE;
    self.scroll.showsHorizontalScrollIndicator = FALSE;
    [self.scroll setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:self.scroll];
    
    UIView *ermen = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [ermen setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UILabel *Chengshi = [[UILabel alloc]init];
    Chengshi.text = @"热门城市";
    Chengshi.font = [UIFont systemFontOfSize:16];
    Chengshi.textAlignment = NSTextAlignmentCenter;
    Chengshi.width = 100;
    Chengshi.height = 44;
    Chengshi.centerX = ermen.centerX;
    [ermen addSubview:Chengshi];
    //    ermen.backgroundColor = [UIColor orangeColor];
    
    [self.scroll addSubview:ermen];
    
    
    
    UIView *fenlei = [[UIView alloc]initWithFrame:CGRectMake(0, 222, [UIScreen mainScreen].bounds.size.width, 44)];
    [fenlei setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UILabel *zimu = [[UILabel alloc]init];
    zimu.text = @"分类城市";
    zimu.font = [UIFont systemFontOfSize:16];
    zimu.textAlignment = NSTextAlignmentCenter;
    zimu.width = 100;
    zimu.height = 44;
    zimu.centerX = fenlei.centerX;
    //    Chengshi.centerY = ermen.centerY;
    [fenlei addSubview:zimu];
    //    ermen.backgroundColor = [UIColor orangeColor];
    
    [self.scroll addSubview:fenlei];
    
}

- (void)searchView{
    
    self.viewsearch = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.viewsearch.alpha = 1.0f;
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    //设置imageView的内容模式
    leftView.contentMode = UIViewContentModeCenter;
    leftView.width = 35;
    self.City = [[UITextField alloc]initWithFrame:CGRectMake(10, 4, [UIScreen mainScreen].bounds.size.width - 70 , 36)];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.backgroundColor = COLOR_DeepBlue;
    [self.City addSubview:imageV];
    [self.City  sendSubviewToBack: imageV];
    self.City.leftView = leftView;
    self.City.leftViewMode = UITextFieldViewModeAlways;
    
    self.City.delegate = self;
    
    self.confirm = [[UIButton alloc]initWithFrame:CGRectMake(self.City.width +10, 0, 60, 44)];
    [self.confirm setTitle:@"确定" forState:UIControlStateNormal];
    self.confirm.hidden = YES;
//    self.confirm.enabled = YES;
    [self.confirm addTarget:self action:@selector(sousuo) forControlEvents:UIControlEventTouchDown];
    [self.confirm setTitleColor:COLOR_DeepBlue forState:UIControlStateNormal];
    self.confirm.titleLabel.font = [UIFont systemFontOfSize:16];
    //    zhiding01
    //设置layer圆角
    self.City.layer.cornerRadius =16;
    self.City.layer.masksToBounds = YES;
    self.City.layer.borderColor = nil;
    self.City.layer.borderWidth = 0;
//    self.City.background = [UIImage imageNamed:@"zhiding01"];
    UIColor *color = [UIColor whiteColor];
    self.City.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入城市或目的地" attributes:@{NSForegroundColorAttributeName: color}];
    self.City.font = [UIFont systemFontOfSize:14];
    self.City.textColor = [UIColor whiteColor];
    [self.City addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.City.backgroundColor = COLOR_DeepBlue;
    [self.viewsearch addSubview:self.City];
    [self.viewsearch addSubview:self.confirm];
    [self.view addSubview:self.viewsearch];
    
    
}

- (void)sousuo{
    
    if ([self.arrayCity containsObject:self.City.text]) {
        
        [self.City resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        JSValue *picCallback = self.jsOc[@"area"];
        [picCallback callWithArguments:@[self.City.text,self.pla]];
        
    }else{
        ZDBombBox *box = [ZDBombBox  new];
        
        [box bombBoxWithBtn:@"数据库暂无该城市数据!" UIView:self.view];
    
    }
}

//监听textfield
-(void)textFieldDidChange:(UITextField *)textField{
    
    [self.tableView removeFromSuperview];
    if(textField.text.length > 0){
        self.confirm.hidden = NO;
//        self.confirm.userInteractionEnabled = NO;
        NSString *str = [textField.text uppercaseString];
        
        //    NSString *url = [[NSBundle mainBundle]pathForResource:@"tripb_cities" ofType:@"db"];
        NSString *deleteStatement = [self getDatabasePath];
        FMDatabase *db = [FMDatabase databaseWithPath:deleteStatement];
        
        
        [db open];
        FMResultSet *rs;
        //        NSLog(@"=====>TOOL:%@",self.tool);
        //航班tool：toolPlane  动车：toolTrain 住宿：toolHotel
        //    飞机
        if ([self.tool isEqualToString:@"toolPlane"]) {
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from flight where name like '%@%%' or pinyin like '%@%%'",str,str]];
            
        }else if([self.tool isEqualToString:@"toolTrain"]){
            //    火车
            //        FMResultSet *rs=[db executeQuery:@"SELECT * FROM station"];
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from station where name like '%@%%' or pinyin like '%@%%'or shortcode like '%@%%'",str,str,str]];
            
        }else{
            //    住宿酒店
            rs=[db executeQuery:[NSString stringWithFormat:@"select * from city where name like '%@%%' or pinyin like '%@%%'",str,str]];
            
        }
        self.arrayCity = [NSMutableArray array];
        while ([rs next]){
            
            [self.arrayCity addObject:[rs stringForColumn:@"name"]];
        }
        
        [rs close];
   
        
        CGFloat tabH;
        if (self.arrayCity.count * 44 > HEIGHT - 108) {
            
            tabH = (HEIGHT - 108);
        }else{
            tabH = self.arrayCity.count * 44;
        }
        //        NSLog(@"%@", self.arrayCity);
        //显示城市列表
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.viewsearch.frame), WIDTH,  tabH) style:UITableViewStylePlain];
        self.tableView.bounces = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.view addSubview:self.tableView];
        
    }else{
    
         self.confirm.hidden = YES;
    
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.arrayCity.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"ID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.arrayCity[indexPath.row];
    
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:75/255.0 green:75/255.0 blue:75/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//点击城市
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
    //    NSLog(@"%@",cell.textLabel.text);
    [self.navigationController popViewControllerAnimated:YES];
    JSValue *picCallback = self.jsOc[@"area"];
    [picCallback callWithArguments:@[cell.textLabel.text,self.pla]];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.City resignFirstResponder];
    return YES;
}

//监听滑动事件、text退出第一响应者
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.City resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.City resignFirstResponder];
}

- (void)lbsdidload{
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        locationmanager = [[CLLocationManager alloc] init];
        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        locationmanager.delegate = self;
    }
}
//定位
- (void)LBS{
    
    UIImage* backImage = [UIImage imageNamed:@"location"];
    CGRect backframe = CGRectMake(0,0,25,25);
    UIButton* backButton= [[UIButton alloc] initWithFrame:backframe];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    //    backButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [backButton addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}

-(void)getCity{
    __block __weak SearchCityViewController *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            
            
            [wself setLabelText:cityString];
        }];
    }
    
    
}
-(void)setLabelText:(NSString *)text{
    
    
    int number = (int)text.length;
    self.confirm.hidden = NO;
    self.arrayCity =  [NSMutableArray array];
    NSString *city = [text substringFromIndex:number - 1];
    
    if ([city isEqualToString:@"市"]) {
        
        NSString *cityN = [text substringToIndex:number - 1];
        
        self.City.text = cityN;
       
        [self.arrayCity addObject:cityN];
        
    }else{
        self.City.text = text;
        [self.arrayCity addObject:text];
    }
    
    
    
}


-(NSString *)getDatabasePath
{
    NSString *url = [[NSBundle mainBundle]pathForResource:@"tripb_cities" ofType:@"db"];
    return url;
} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}

@end
