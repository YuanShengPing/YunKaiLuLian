//
//  ZDCarousel.m
//  zhidingwang
//
//  Created by 袁胜平 on 15/10/16.
//  Copyright © 2015年 直订网365. All rights reserved.
//

#import "ZDCarousel.h"

#define ZDWIDTH [UIScreen mainScreen].bounds.size.width

@interface ZDCarousel ()<SDCycleScrollViewDelegate>

@end


@implementation ZDCarousel

- (void)headerView:(UIView *)controller imageViewArrar:(NSArray *)array{
    // 情景二：采用网络图片实现
   
    self.imagesURLStringsS = array;
    
    // 情景三：图片配文字
//    NSArray *titles = @[@"直订网感谢您的支持，如果下载的",
//                        @"如果代码在使用过程中出现问题",
//                        @"您可以发邮件到",
//                        @"感谢您的支持",
//                        @"感谢您的支持"
//                        
//                        ];
//    
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ZDWIDTH-40, 180) imageURLStringsGroup:nil]; // 模拟网络延时情景
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.delegate = self;
//    cycleScrollView2.titlesGroup = titles;
    ///轮播时间间隔
    cycleScrollView2.autoScrollTimeInterval = 3.0;
    
    // cycleScrollView2.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    ///占位图
    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    cycleScrollView2.imageURLStringsGroup = array;
    
    
    
    [controller addSubview:cycleScrollView2];
    
    ///清除图片缓存
//    [cycleScrollView2 clearCache];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
}


@end
