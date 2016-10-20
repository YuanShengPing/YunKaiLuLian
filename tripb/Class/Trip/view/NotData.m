//
//  NotData.m
//  tripb
//
//  Created by 云开互联 on 16/8/18.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "NotData.h"

@implementation NotData

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH / 3, WIDTH / 3 / 279 * 123)];
        imageView.image = [UIImage imageNamed:@"no-order"];
        [self addSubview:imageView];
        
        UILabel *labelT = [[UILabel alloc]initWithFrame:CGRectMake(0, WIDTH / 3 / 279 * 123 +10 ,  WIDTH / 3, 20)];
        if (WIDTH < 375) {
            labelT.width = 120;
            labelT.x     = -8;
        }
        labelT.text = @"您当前没有数据";
        labelT.textAlignment = NSTextAlignmentCenter;
        labelT.textColor =  COLOR_Grey;
        [self addSubview:labelT];

    }
    return self;
}
@end
