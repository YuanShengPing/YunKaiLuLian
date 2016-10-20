//
//  WebViewJSController.m
//  tripb
//
//  Created by 云开互联 on 16/5/27.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "WebViewJSController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import  <JavaScriptCore/JavaScriptCore.h>
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "DanLi.h"
#import "ZDBombBox.h"
#import "ReachabilityBool.h"
#import "CLOrderTool.h"
#import "LVFmdbTool.h"
#import "DanLi.h"

@interface WebViewJSController ()<UIWebViewDelegate,WXApiManagerDelegate,UIAlertViewDelegate,WXApiManagerDelegate>{
    
    UIWebView *myWebView;
    
}
@property (strong, nonatomic) YHWebViewProgress *progressProxy;

@property (nonatomic,strong)JSContext *context;

@property (nonatomic,copy)NSString *Result;

@end

@implementation WebViewJSController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = COLOR_DeepBlue;
    [WXApiManager sharedManager].delegate = self;
    
    [self rightBarButtonItem];
    self.title = @"加载中...";
    self.view.backgroundColor = [UIColor yellowColor];

    myWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    myWebView.height = HEIGHT - 64;
    myWebView.delegate=self;

    NSString *httpStr=[NSString stringWithFormat:@"%@/%@.html",[URLstate URLstateWithString],self.url];
   
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [myWebView loadRequest:httpRequest];
    //添加webview到当前viewcontroller的view上
    [self.view addSubview:myWebView];

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
    [myWebView addSubview:progressView];
//    去除底线navigationBar
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    
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

    if ([myWebView canGoBack]) {
        
        [myWebView goBack];
    }else{
        [self closeCurrentWindow];
    }
}

- (void)closeCurrentWindow{
    
    
    if (self.WebDelegate && [self.WebDelegate conformsToProtocol:@protocol(WebViewJSControllerDelegata)]) {
        
        [self.WebDelegate homeWithIndex];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"加载完成");

    self.title = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
   
    self.context = [myWebView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        buttonClick
    __block __weak WebViewJSController *wself = self;
    self.context[@"jakilllog"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
//        NSLog(@"===--args:%@",args);
        if ([jsvlue isEqualToString:@"closeCurrentWindow"]) {
            //    在主线程下执行
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
             [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                    //            关闭当前窗口
             [wself.navigationController popViewControllerAnimated:YES];
            });});
            
//
        }else if([jsvlue isEqualToString:@"setCompany"]){
            // 注册了企业..
            [DanLi sharedDanLi].homeData = @"UphomeData";
            [DanLi sharedDanLi].UpData   = @"UpData";
            [DanLi sharedDanLi].UpOrder  = @"UpOrder";
            //    清除行程缓存数据申请单跟订单
            [CLOrderTool deleteData:nil];
            
            [LVFmdbTool deleteData:nil];

        }
    };
    //获取当前URL
//    NSString *URL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    NSLog(@"URL===%@",URL);
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([myWebView canGoBack]) {
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
    
    self.title = @"加载失败";
    
        ReachabilityBool *status = [ReachabilityBool new];
    
        if ([status reachabilityWithStatus]) {
//       解档赋值
            return;
        }else{
    
            [AlertActionTool NetworkTips:self];
        }
    
}

//webView的每次页面跳转都会执行，在这里可以得到想要的数据
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSLog(@"页面跳转");
    
    return YES;
    
}
//退出键盘
//[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//支付结果传给JS
- (void)payWithResult:(NSString *)result{
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
        JSValue *picCallback = self.context[@"payReseult"];
        [picCallback callWithArguments:@[self.Result]];
    }
    
    

}

@end
