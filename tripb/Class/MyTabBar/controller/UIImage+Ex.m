//
//  UIImage+Ex.m
//  A01-CZ彩票
//
//  Created by apple on 15-6-13.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIImage+Ex.h"

@implementation UIImage (Ex)
- (UIImage *)originalImage{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
