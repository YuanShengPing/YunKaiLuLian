//
//  personalDataController.m
//  tripb
//
//  Created by 云开互联 on 16/6/15.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "personalDataController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "JGGchijiuhua.h"
#import "ReachabilityBool.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface personalDataController ()<UIWebViewDelegate>{
    
    UIWebView *myWebView;
    
}
@property (strong, nonatomic) YHWebViewProgress *progressProxy;

@property (nonatomic, strong) JSContext         *jsContext;

@end

@implementation personalDataController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self rightBarButtonItem];
//    返回设置进行刷新数据
    [self StateRefresh];
    
    self.title = @"加载中...";
    self.view.backgroundColor = [UIColor whiteColor];
    
    myWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    myWebView.height = HEIGHT -64;
    myWebView.delegate=self;
    NSString *httpStr= [NSString stringWithFormat:@"%@/user/myself.html",[URLstate URLstateWithString]];/*[NSString stringWithFormat:@"%@",HTML(@"user/myself")];*/
    
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"加载完成");
    self.title = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
 
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __block __weak personalDataController *wself = self;
    self.jsContext[@"jakilllog"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
      
       if ([jsvlue isEqualToString:@"closeCurrentWindow"]) {
                       dispatch_async(dispatch_get_global_queue(0, 0), ^{
                           dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                           });});
            //        关闭当前窗口
        [wself.navigationController popViewControllerAnimated:YES];
        }
    };
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


- (void)StateRefresh{
    StateRefresh *Refresh = [StateRefresh new];
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"RefreshHome.data"];
    //            归档手机号码
    Refresh.StateRefresh = [NSString stringWithFormat:@"Refresh"];
    [NSKeyedArchiver archiveRootObject:Refresh toFile:file];
}


@end
