//
//  orderViewController.m
//  tripb
//
//  Created by 云开互联 on 16/5/6.
//  Copyright © 2016年 tripb. All rights reserved.
//
/**
 订单
 */
#import "orderViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "HomeViewController.h"

@interface orderViewController ()<UIWebViewDelegate>{
     UIWebView *myWebView;
}
@property (strong, nonatomic) YHWebViewProgress *progressProxy;

@property (atomic,strong)JSContext *context;

@end

@implementation orderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"加载中...";
    myWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    myWebView.height = HEIGHT - 64;
    myWebView.delegate=self;
//    NSString *httpStr=[NSString stringWithFormat:@"http://monkey.inc.tripb.cn/apply/check_apply.html?applyid=88"];
    NSString *httpStr=[NSString stringWithFormat:@"%@/apply/list_apply.html",[URLstate URLstateWithString]];/*HTML(@"apply/list_apply");*/
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [myWebView loadRequest:httpRequest];
    //添加webview到当前viewcontroller的view上
    [self.view addSubview:myWebView];
    
    self.context = [myWebView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        buttonClick
    __block __weak orderViewController *wself = self;
    self.context[@"jakilllog"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
             NSLog(@"===args:%@",args);
        
        if ([jsvlue isEqualToString:@"closeCurrentWindow"]) {
            //            关闭当前窗口
            [wself.navigationController popViewControllerAnimated:YES];
            
        }else if([jsvlue isEqualToString:@"setCompany"]){
            
            NSLog(@"已经注册企业");
            
//             0-企业支付 1-微信支付 2-支付宝支付
        }else if([jsvlue isEqualToString:@"0"]){
            NSLog(@"企业支付");
            
        }else if([jsvlue isEqualToString:@"1"]){
            
            
            NSString *pay = [NSString stringWithFormat:@"%@",args[1]];
            
            if ([WXApi isWXAppInstalled]) {
                NSString *res = [WXApiRequestHandler jumpToBizPay:pay];
                
                if( ![@"" isEqual:res] ){
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alter show];
                }
            }else{
                ZDBombBox *box = [ZDBombBox  new];
                
                [box bombBoxWithBtn:@"您还没有安装微信客服端!" UIView:wself.view];
            }
        }else if([jsvlue isEqualToString:@"2"]){
            
            NSLog(@"支付宝");
            
        }else{
            NSLog(@"没有注册企业");
        }
    };
    
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 4)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViewProgress
    myWebView.delegate = self.progressProxy;
    // 设置webview代理转发到self（可选）
    self.progressProxy.webViewProxy = self;
    // 添加到视图
    [self.view addSubview:progressView];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)viewWillAppear:(BOOL)animated{
   self.navigationController.navigationBarHidden = NO;
    NSArray *vcsArray = [self.navigationController viewControllers];
    NSInteger vcCount = vcsArray.count;
    UIViewController *lastVC = vcsArray[vcCount-2];
    
    HomeViewController * Reserve = [HomeViewController new];
    //     判断是从上一个控制器push过来的
    if( [lastVC isKindOfClass:[Reserve class]]){

    }
}

// 回调通知success   failed    cancel   这三个参数
- (void)tzAction:(NSNotification *)sender {
    NSLog(@"sfghdsrhd:%@",sender.object);
    
    if ([@"0" isEqualToString:sender.object]) {
        [self newsWithPush:@"success"];
   
    }else if([@"-1" isEqualToString:sender.object]){
        [self newsWithPush:@"failed"];
   
    }else if([@"-2" isEqualToString:sender.object]){
        [self newsWithPush:@"cancel"];
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"加载失败＝＝＝%@",error);
    self.title = @"加载失败";
}


- (void)newsWithPush:(NSString *)tepy{
     //     [myWebView reload];
//     JSValue *picCallback = self.context[@"payReseult"];
//     [picCallback callWithArguments:@[@"success"]];
    
    NSString *httpStr=[NSString stringWithFormat:@"%@/apply/list_apply.html",[URLstate URLstateWithString]];/*HTML(@"apply/list_apply");*/
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [myWebView loadRequest:httpRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}
@end
