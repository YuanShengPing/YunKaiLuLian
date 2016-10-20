//
//  tripDetailsViewController.m
//  tripb
//
//  Created by 云开互联 on 16/5/26.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "tripDetailsViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YHWebViewProgressView.h"
#import "YHWebViewProgress.h"
#import "ReachabilityBool.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "DanLi.h"
#import "CompanyPlay.h"


@interface tripDetailsViewController ()<UIWebViewDelegate,WXApiManagerDelegate,UIAlertViewDelegate,WXApiManagerDelegate>

@property (nonatomic, strong) JSContext         *jsContext;
@property (nonatomic, strong) UIWebView         *webView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (nonatomic,copy   ) NSString          *Result;

@end

@implementation tripDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    [self rightBarButtonItem];
    // Do any additional setup after loading the view.
    [WXApiManager sharedManager].delegate = self;
    self.title = @"加载中...";
//    self.navigationController.navigationBarHidden = NO;
    self.webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.height = HEIGHT -64;
    self.webView.delegate=self;
    //             http://monkey.test.tripb.cn/apply/approvedetail.html?applyid=15
    //             http://monkey.test.tripb.cn/order/detail.html?order_id = 5
    //网址apply order_id=23
    //    NSString *httpStr= [NSString stringWithFormat:@"%@?tripid=%@",HTML(@"trip/show_trip"),self.tripId];
    NSString *httpStr= self.tripId;
    //    NSLog(@"httpStr:%@",httpStr);
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.webView loadRequest:httpRequest];
    // 添加webview到当前viewcontroller的view上
    [self.view addSubview:self.webView];
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 4)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViewProgress
    self.webView.delegate = self.progressProxy;
    // 设置webview代理转发到self（可选）
    self.progressProxy.webViewProxy = self;
    // 添加到视图
    [self.view addSubview:progressView];
    
    self.jsContext = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        buttonClick
    __block __weak tripDetailsViewController *wself = self;
    self.jsContext[@"jakilllog"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
        if ([jsvlue isEqualToString:@"apply_red_flag"]){
            //申请单cell刷新
            if ([wself.MessageDelegate respondsToSelector:@selector(remindWithMessage:NavigationBar:)]) {
                
                [wself.MessageDelegate remindWithMessage:wself.row NavigationBar:NO];
            }
            
        }else if ([jsvlue isEqualToString:@"apply_total_red_flag"]){
            //申请全部红点清除order_red_flag
            if ([wself.MessageDelegate respondsToSelector:@selector(remindWithMessage:NavigationBar:)]) {
                [wself.MessageDelegate remindWithMessage:wself.row NavigationBar:YES];
            }
            
        }else if ([jsvlue isEqualToString:@"order_red_flag"]){
            
            if ([wself.MessageDelegate respondsToSelector:@selector(orderWithMessage:NavigationBar:)]) {
                
                [wself.MessageDelegate orderWithMessage:wself.row NavigationBar:NO];
            }
            
        }else if ([jsvlue isEqualToString:@"order_total_red_flag"]){
            //订单全部红点清除  触发通知，导航栏取消红点
            if ([wself.MessageDelegate respondsToSelector:@selector(orderWithMessage:NavigationBar:)]) {
                
                [wself.MessageDelegate orderWithMessage:wself.row NavigationBar:YES];
            }
        }
    };
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    NSLog(@"加载完成");
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    
    self.jsContext = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        buttonClick
    __block __weak tripDetailsViewController *wself = self;
    self.jsContext[@"jakilllog"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
        if([jsvlue isEqualToString:@"0"]){
            //    在主线程下执行
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //             NSLog(@"企业支付");
                    CompanyPlay *Company = [CompanyPlay new];
                    [wself.navigationController pushViewController:Company animated:YES];
                    Company.jsString = wself.jsContext;
                });});
        }else if([jsvlue isEqualToString:@"1"]){
            
            if ([WXApi isWXAppInstalled]) {
                
                if([WXApi isWXAppSupportApi]){
                    NSString *pay = [NSString stringWithFormat:@"%@",args[1]];
                    
                    NSString *res = [WXApiRequestHandler jumpToBizPay:pay];
                    //                    NSLog(@"pay == %@",res);
                    if( ![@"" isEqual:res] ){
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alter show];
                    }
                    
                }else{
                    ZDBombBox *box = [ZDBombBox  new];
                    
                    [box bombBoxWithBtn:@"当前微信版本过低!" UIView:wself.view];
                }
                
            }else{
                ZDBombBox *box = [ZDBombBox  new];
                
                [box bombBoxWithBtn:@"您没有安装微信!" UIView:wself.view];
            }
        }else if([jsvlue isEqualToString:@"2"]){
            
            NSLog(@"支付宝");
            
        }else if ([jsvlue isEqualToString:@"closeCurrentWindow"]){
            
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            //            关闭当前窗口
            [wself.navigationController popToRootViewControllerAnimated:YES];
            
            if (args.count > 1) {
                
                if ([[NSString stringWithFormat:@"%@",args[1]] isEqualToString:@"orderUpData"]) {
                    
                    [DanLi sharedDanLi].UpData = @"UpData";
                    
                }else if([[NSString stringWithFormat:@"%@",args[1]] isEqualToString:@"orderUpData"]){
                    
                    [DanLi sharedDanLi].UpData = @"UpOrder";
                }
            }
        }
    };
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.webView canGoBack]) {
        UIImage *backImage = [UIImage imageNamed:@"close_01"];
        backButton.frame = CGRectMake(0, 0, 60,40);
        // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
        // 让按钮图片右移15
        //    [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(5, 38, 5, -10)];
        [backButton setImage:backImage forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(closeCurrentWindow) forControlEvents:UIControlEventTouchUpInside];
        backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        UIBarButtonItem *right= [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIButton *btn = [[UIButton alloc]init];
        UIBarButtonItem *right= [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem =right;
    }
    
}

- (void)closeCurrentWindow{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightBarButtonItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"fanhui"];
    button.frame = CGRectMake(0, 0, 60,40);
    //     这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    //     让按钮图片右移15
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10, 58)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeBack) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *leftBar= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBar;
}

- (void)closeBack{
    
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];
    }else{
        [self closeCurrentWindow];
    }
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    //    NSLog(@"加载失败＝＝＝%@",error);
    self.title = @"加载失败";
    
    ReachabilityBool *status = [ReachabilityBool new];
    
    if ([status reachabilityWithStatus]) {
        //       解档赋值
        return;
    }else{
        
        [AlertActionTool NetworkTips:self];
    }
    
}


//退出键盘
//[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//支付结果传给JS
- (void)payWithResult:(NSString *)result{
    //    更新订单状态
    [DanLi sharedDanLi].UpOrder  = @"UpOrder";
    //    NSString *strres = [NSString stringWithFormat:@"%@",result];
    //    [myWebView reload];
    //     success   failed    cancel   这三个参数
    self.Result =result;
    NSString *strres;
    if ([@"success" isEqualToString:result]) {
        strres = @"成功！";
        
    }else if([@"failed" isEqualToString:result]){
        strres = @"失败！";
        
    }else{
        
        strres = @"用户取消支付！";
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付结果：%@",strres] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        JSValue *picCallback = self.jsContext[@"payReseult"];
        [picCallback callWithArguments:@[self.Result]];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}

@end
