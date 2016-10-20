//
//  MyNavViewController.m
//  tripb
//
//  Created by 云开互联 on 16/4/8.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "MyNavViewController.h"
#import "UIImage+Ex.h"

@interface MyNavViewController ()

@end

@implementation MyNavViewController


/*
 状态栏的管理：
 1> iOS7之前：UIApplication
 2> iOS7开始：交给对应的控制器去管理
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 白色样式
    return UIStatusBarStyleDefault;
}
#pragma mark 一个类只会调用一次
//仅仅调一次
+ (void)initialize
{

   
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
   
    navBar.barTintColor = COLOR_DeepBlue;
    navBar.translucent = NO;
//    navBar.backgroundColor =COLOR_DeepBlue;
//    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_theroad"] forBarMetrics:UIBarMetricsDefault];
    // 3.设置导航栏标题颜色为白色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
 
    // 4.设置导航栏按钮文字颜色为白色
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    //    返回按钮颜色
    
    [navBar setTintColor:[UIColor whiteColor]];
   
}




- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSString *title = @"返回";
    
    //如果发现里面已经存在有且仅有一个，执行到这句代码的时候，代表即将要往navCtrl添加第2个
    if (self.childViewControllers.count ==2) {
        title = [[self.childViewControllers firstObject] title];

    }
    
    //如果当前push进来是第一个控制器的话，（代表当前childViewCtrls里面是没有东西）我们就不要设置leftitem
    if (self.childViewControllers.count==1) {
        //设置左边item
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 22)];
        UIButton *button = [[UIButton alloc] initWithFrame:contentView.bounds];
        [button setBackgroundImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:contentView];
        self.navigationItem.leftBarButtonItem = barButtonItem;
        
        [self.navigationBar setBarTintColor:COLOR_DeepBlue];
        
        //如果当前不是第一个子控制器，那么在push出去的时候隐藏底部的tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }

    //这句代码的位置是一个关键
    [super pushViewController:viewController animated:animated];
    
}


- (void)backClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
