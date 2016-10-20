//
//  YKHLSaerchLetter.m
//  tripb
//
//  Created by 云开互联 on 16/5/12.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "YKHLSaerchLetter.h"
#import "ZDCitcyIdCell.h"
#import "SearchCityViewController.h"
#import "TravelWebView.h"


@interface YKHLSaerchLetter ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation YKHLSaerchLetter

- (void)viewDidLoad {
    [super viewDidLoad];
//   self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = COLOR_DeepBlue;
    UIView *fooer = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT - 20)];
    fooer.backgroundColor = COLOR_LightGray;
    [self.view addSubview:fooer];
    
    self.tableView.tableFooterView = [UIView new];
    [self creatUI];
}

-(void)creatUI{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    navView.backgroundColor = COLOR_DeepBlue;
    [self.view addSubview:navView];
    
    UILabel * labe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH , 44)];
    labe.text = self.letter;
    labe.font = fontX(20)
    labe.textAlignment = NSTextAlignmentCenter;
    labe.textColor = [UIColor whiteColor];
    [navView addSubview:labe];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"image_icon"];
    button.frame = CGRectMake(10, 0, 60,40);
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片右移15
    [button setImageEdgeInsets:UIEdgeInsetsMake(8, -5, 8, 40)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [navView addSubview:button];
    
    CGFloat height;
    CGFloat H = HEIGHT - 60;
    if (self.letterCity.count * 50 > H ) {
        
        height = H;
    }else{
        
        height = self.letterCity.count * 50;
        
    }
//    NSLog(@"height %f",height);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navView.frame), WIDTH, height) style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *viewQ = [[UIView alloc]init];
    viewQ.backgroundColor = [UIColor colorWithRed:245/255.0 green:241/255.0 blue:238/255.0 alpha:1];
    self.tableView.tableHeaderView = viewQ;
    
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5);
    [self.view addSubview:self.tableView];
}
//点击X，返回
-(void)btnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.letterCity.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"ZDCitcyIdCell";
    ZDCitcyIdCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZDCitcyIdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.city.text = self.letterCity[indexPath.row];
    
    return cell;
}

//点击城市
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDCitcyIdCell *nameCell = (ZDCitcyIdCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
    TravelWebView *viewCtl = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:viewCtl animated:YES];
    
    JSValue *picCallback = self.jsOc[@"area"];
//     NSLog(@"nameCell:%@ self.pla ：%@  picCallback:%@",nameCell.city.text,self.pla,picCallback);
    [picCallback callWithArguments:@[nameCell.city.text,self.pla]];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存泄露");
}
@end



