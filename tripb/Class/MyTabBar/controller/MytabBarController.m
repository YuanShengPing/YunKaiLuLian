//
//  MytabBarController.m
//  tripb
//
//  Created by 云开互联 on 16/4/8.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "MytabBarController.h"
#import "MyNavViewController.h"
#import "HomeViewController.h"
#import "OrderTableViewController.h"
#import "TripTableViewController.h"
#import "SettingsTableViewController.h"

@interface MytabBarController ()

@end

@implementation MytabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}

- (void)setUp{
    
    HomeViewController *one1 = [HomeViewController new];
    [self addTableViewP:one1 imageName:@"Tabar_home1" title:@"首页"];
    
    OrderTableViewController *two = [OrderTableViewController new];
    [self addTableView:two imageName:@"Tabar_home2" title:@"申请单"];
    
    TripTableViewController *three = [TripTableViewController new];
    [self addTableView:three imageName:@"Tabar_home3" title:@"订单"];
    
    SettingsTableViewController *four = [SettingsTableViewController new];
    [self addTableView:four imageName:@"Tabar_home4" title:@"我的"];
    
    
    
}


- (void)addTableView:(UITableViewController *)table imageName:(NSString *)image title:(NSString *)title{
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor =COLOR_Blue ;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    table.title = title;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = fontX(20);
    titleLabel.textColor = [UIColor whiteColor];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    table.navigationItem.titleView = titleLabel;
    
    table.tabBarItem.image = [UIImage imageNamed:image];
    
    table.tabBarItem.selectedImage =[[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",image]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MyNavViewController *SB = [[MyNavViewController alloc]initWithRootViewController:table];
  
    [self addChildViewController:SB];
    
    
    
}


- (void)addTableViewP:(UIViewController *)table imageName:(NSString *)image title:(NSString *)title{
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor = COLOR_Blue;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleHighlightedColor, NSForegroundColorAttributeName ,nil] forState:UIControlStateNormal];
    
    table.title = title;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = fontX(20);
    titleLabel.textColor = [UIColor whiteColor];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    table.navigationItem.titleView = titleLabel;
    
    table.tabBarItem.image = [UIImage imageNamed:image];
    
    table.tabBarItem.selectedImage =[[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",image]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

     MyNavViewController *Nav = [[MyNavViewController alloc]initWithRootViewController:table];
    
    [self addChildViewController:Nav];
    
    
    
}


@end
