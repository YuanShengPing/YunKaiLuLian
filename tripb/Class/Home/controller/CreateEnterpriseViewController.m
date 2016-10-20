//
//  CreateEnterpriseViewController.m
//  tripb
//
//  Created by 云开互联 on 16/5/6.
//  Copyright © 2016年 tripb. All rights reserved.
//
/**
 创建企业
 */
#import "CreateEnterpriseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"


@interface CreateEnterpriseViewController ()<UIWebViewDelegate,UINavigationControllerDelegate>{

    UIWebView *myWebView;
}

@property (strong, nonatomic) YHWebViewProgress *progressProxy;

@end

@implementation CreateEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self rightBarButtonItem];
    self.title = @"加载中...";
    self.view.backgroundColor = [UIColor whiteColor];
    
    myWebView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    myWebView.height = HEIGHT - 64;
    myWebView.delegate=self;
   
    NSString *httpStr =[NSString stringWithFormat:@"%@/enterprise/show.html",[URLstate URLstateWithString]]; /*HTML(@"enterprise/show");*/
    NSURL *httpUrl    =[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [myWebView loadRequest:httpRequest];
    //添加webview到当前viewcontroller的view上
    [self.view addSubview:myWebView];
    
    JSContext *context    = [myWebView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        buttonClick
    context[@"jakilllog"] = ^() {
    NSArray *args         = [JSContext currentArguments];
    NSString *jsvlue      = [NSString stringWithFormat:@"%@",args[0]];

        if ([jsvlue isEqualToString:@"closeCurrentWindow"]) {
//            NSLog(@"关闭窗口%@",jsvlue);
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    [myWebView addSubview:progressView];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载完成");
   self.title = [myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


- (void)rightBarButtonItem{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"image_icon"];
    button.frame = CGRectMake(0, 0, 60,40);
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片右移15
    [button setImageEdgeInsets:UIEdgeInsetsMake(8, -15, 8, 45)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, - 35, 0, 0)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeCurrentWindow) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font                = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightItem            = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightItem;
    
}

- (void)closeCurrentWindow{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
//    NSLog(@"加载失败＝＝＝%@",error);
    self.title = @"加载失败";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}
@end
