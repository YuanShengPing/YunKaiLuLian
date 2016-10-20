//
//  ReserveViewController.m
//  tripb
//
//  Created by 云开互联 on 16/4/21.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "ReserveViewController.h"
#import "TravelWebView.h"
#import "AFNetworking.h"
#import "ReachabilityBool.h"
#import "LoginViewController.h"
#import "WebViewJSController.h"
#import "DanLi.h"

@interface ReserveViewController ()<UIWebViewDelegate,UITextFieldDelegate>

@end

@implementation ReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_LightGray;
    self.title = @"出差";
    [self BusinessApplicationWithButton];
}

- (void)BusinessApplicationWithButton{

    UIButton *business = [[UIButton alloc]init];
    business.width = WIDTH / 3 *2;
    business.height = 60;
    business.centerX = self.view.centerX;
    business.centerY = self.view.centerY - 60;
    [business setTitle:@"发起出差申请" forState:UIControlStateNormal];
    business.layer.cornerRadius = 3.0;
    [business addTarget:self action:@selector(businessWithButton) forControlEvents:UIControlEventTouchDown];
    business.backgroundColor = COLOR_DeepBlue;
    [self.view addSubview:business];
    
    UIView *line = [[UIView alloc]init];
    line.width = WIDTH / 3 *2;
    line.height = 1;
    line.y =self.view.centerY +10;
    line.centerX = self.view.centerX;
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.8;
    [self.view addSubview:line];
    
    NSArray * processA = @[@"申请",@"审批",@"预定",@"出票"];
    CGFloat wid = (line.width - 140) / 3;
    for (int i = 0; i <processA.count; i++) {
        UIButton *process = [[UIButton alloc]init];
        [process setTitle:processA[i] forState:UIControlStateNormal];
        process.backgroundColor = [UIColor whiteColor];
        [process setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        process.titleLabel.font = fontX(12);
        process.layer.cornerRadius = 18;
        process.tag = i;
        process.width = 35;
        process.height = 35;
        process.centerY =line.centerY;
        process.x = WIDTH / 6  + wid * i + 35 * i ;
        [self.view addSubview:process];
    }
    
    UIButton *order = [[UIButton alloc]init];
    [order setTitle:@"查看您的订单>>" forState:UIControlStateNormal];
    [order addTarget:self action:@selector(orderWithButton) forControlEvents:UIControlEventTouchDown];
    [order setTitleColor:MainTone forState:UIControlStateNormal];
    order.width = WIDTH / 3 *2;
    order.height = 30;
    
    order.centerX = self.view.centerX;
    order.y = self.view.centerY  * 1.5 - 75;
    [self.view addSubview:order];
}

- (void)businessWithButton{
        //   解档赋值
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
            NSLog(@"发起出差申请");
            TravelWebView *Travel = [[TravelWebView alloc]init];
            [self.navigationController pushViewController:Travel animated:YES];
        }else{
            LoginViewController *login = [LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        }
}

- (void)orderWithButton{
        //   解档赋值
        LoginState *state = [LoginState new];
        if ([state NotLoginWithLogin]) {
//            NSLog(@"查看订单");
            WebViewJSController *WebView = [WebViewJSController new];
            [self.navigationController pushViewController:WebView animated:YES];
            WebView.url = [NSString stringWithFormat:@"apply/list_apply"];
            WebView.titleX = @"出差申请";
        }else{
            LoginViewController *login = [LoginViewController new];
            
            [self.navigationController pushViewController:login animated:YES];
        }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存泄露");
}


@end
