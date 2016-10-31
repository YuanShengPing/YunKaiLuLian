//
//  pushViewController.m
//  tripb
//
//  Created by 云开互联 on 16/5/24.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "pushViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "CompanyPlay.h"

@interface pushViewController ()<UIWebViewDelegate,UIAlertViewDelegate,WXApiManagerDelegate>

@property (strong, nonatomic) YHWebViewProgress *progressProxy;

@property (nonatomic, strong) UIWebView         *webView;
@property (nonatomic,strong ) JSContext         *context;

@property (nonatomic,copy   ) NSString          *Result;

@end

@implementation pushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightBarButtonItem];
    
    LoginState *state = [LoginState new];
    if ([state NotLoginWithLogin]) {
        
        [self loadWithWebView];
        
    }else{
    
        ZDBombBox *box = [ZDBombBox  new];
        
        [box bombBoxWithBtn:@"获取首页数据失败!" UIView:self.view];
    
    }
    
}

- (void)loadWithWebView{


    self.webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.height = HEIGHT - 64;
    self.webView.delegate=self;
    //添加webview到当前viewcontroller的view上
    [self.view addSubview:self.webView];
    //网址
    NSURL *httpUrl=[NSURL URLWithString:self.urlString];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.webView loadRequest:httpRequest];
    
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
}


- (void)viewWillAppear:(BOOL)animated{
   
    self.navigationController.navigationBarHidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.context = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        buttonClick
    __block __weak pushViewController *wself = self;
    
    self.context[@"jakilllog"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
        NSLog(@"=========%@",args);
        
        if ([jsvlue isEqualToString:@"closeCurrentWindow"]) {
            //    在主线程下执行
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                    //            关闭当前窗口
                    [wself.navigationController popViewControllerAnimated:YES];
                });});

        }else if([jsvlue isEqualToString:@"setCompany"]){
            
            NSLog(@"已经注册企业");
            //             0-企业支付 1-微信支付 2-支付宝支付
        }else if([jsvlue isEqualToString:@"0"]){
            NSLog(@"企业支付");
            //             NSLog(@"企业支付");
            CompanyPlay *Company = [CompanyPlay new];
            [wself.navigationController pushViewController:Company animated:YES];
            Company.jsString = wself.context;
            
        }else if([jsvlue isEqualToString:@"1"]){
     
            NSString *pay = [NSString stringWithFormat:@"%@",args[1]];
            
            if ([WXApi isWXAppInstalled]) {
                
                
                 if([WXApi isWXAppSupportApi]){
                NSString *res = [WXApiRequestHandler jumpToBizPay:pay];
                
                if( ![@"" isEqual:res] ){
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alter show];
                }}else{
                
                    ZDBombBox *box = [ZDBombBox  new];
                    
                    [box bombBoxWithBtn:@"当前微信版本过低!" UIView:wself.view];
                }
            }else{
//                NSLog(@"没有安装微信");
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有安装微信，无法完成订单支付!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alter show];
            }
        }else if([jsvlue isEqualToString:@"2"]){
            
            NSLog(@"支付宝");
            
        }if ([[NSString stringWithFormat:@"%@",args[0]] isEqualToString:@"orderUpData"]) {
            
            [DanLi sharedDanLi].UpData = @"UpData";
            
        }else if([[NSString stringWithFormat:@"%@",args[0]] isEqualToString:@"orderUpData"]){
            
            [DanLi sharedDanLi].UpData = @"UpOrder";
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


- (void)closeCurrentWindow{

    [self.navigationController popViewControllerAnimated:YES];
}

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

//    NSLog(@"alertView : %@ == buttonIndex :%d",alertView,buttonIndex);-
    JSValue *picCallback = self.context[@"payReseult"];
    [picCallback callWithArguments:@[self.Result]];
    
}

@end
