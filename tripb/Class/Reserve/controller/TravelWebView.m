

#import "TravelWebView.h"
#import "SearchCityViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ReserveViewController.h"
#import "ReachabilityBool.h"
#import "DanLi.h"
@interface TravelWebView ()<UIWebViewDelegate>

@property (nonatomic, strong) JSContext         *jsContext;
@property (nonatomic, strong) UIWebView         *webView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;

@end


@implementation TravelWebView


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"加载中...";
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightBarButtonItem];
     self.webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.height = HEIGHT - 64;
     self.webView.delegate=self;
    //网址
    NSString *httpStr= [NSString stringWithFormat:@"%@/apply/apply.html",[URLstate URLstateWithString]];/*HTML(@"apply/apply");*/
    NSURL *httpUrl=[NSURL URLWithString:httpStr];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [self.webView loadRequest:httpRequest];
    //添加webview到当前viewcontroller的view上
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
 
}


- (void)closeCurrentWindow{

    [self.navigationController popViewControllerAnimated:YES];

}


-(void)webViewDidFinishLoad:(UIWebView *)webView{

    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __block __weak TravelWebView *wself = self;
    self.jsContext[@"jakilllog"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSString *jsvlue = [NSString stringWithFormat:@"%@",args[0]];
//        NSLog(@"==---->%@",args);
        
        if ([jsvlue isEqualToString:@"tripUpData"]) {
             [DanLi sharedDanLi].UpData = @"UpData";
             [DanLi sharedDanLi].UpOrder  = @"UpOrder";
        }else if ([jsvlue isEqualToString:@"closeCurrentWindow"]) {
            
            //    在主线程下执行
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //        关闭当前窗口
                    [wself.navigationController popViewControllerAnimated:YES];
                });});
            

            
        }else if(args.count > 1){
            
         NSString *pla = [NSString stringWithFormat:@"%@",args[1]];
        
        [wself addWithCityAirport:pla tool:jsvlue nav:wself];
        }
//        清除缓存
//        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
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
- (void)NearbyWithLocation{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
//航班tool：toolPlane  动车：toolTrain 住宿：toolHotel
- (void)addWithCityAirport:(NSString *)string  tool:(NSString *)tool nav:(UIViewController *)nav{
//    在主线程下执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                
        SearchCityViewController *Search = [SearchCityViewController new];
        [nav.navigationController pushViewController:Search animated:YES];
        Search.pla = string;
        Search.tool = tool;
        Search.jsOc = self.jsContext;
                
            });
    });
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}

@end
