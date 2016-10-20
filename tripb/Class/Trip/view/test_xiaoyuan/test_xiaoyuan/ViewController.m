//
//  ViewController.m
//  test_xiaoyuan
//
//  Created by 云开互联 on 16/9/21.
//  Copyright © 2016年 YunKai HuLian. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) JSContext         *jsContext;
@property (nonatomic, strong) UIWebView         *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"加载中...";
    self.navigationController.navigationBarHidden = NO;
    self.webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
     [self.view addSubview:self.webView];
    self.webView.delegate=self;
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"ceshi.html" withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [self.webView loadRequest:request];
    // 添加webview到当前viewcontroller的view上
   
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    NSLog(@"加载完成");
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.jsContext = [self.webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //        buttonClick
//    __block __weak ViewController *wself = self;
    self.jsContext[@"jakilllog"] = ^() {
       
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
      NSLog(@"jsvlue:%@-- %ld",jsvlue,(unsigned long)args.count);
    };
    
    }



- (void)closeCurrentWindow{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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

    
}
@end
