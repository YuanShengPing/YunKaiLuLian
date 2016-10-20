//
//  ZDBombBox.h
//  zhidingwang
//
//  Created by 袁胜平 on 15/10/23.
//  Copyright © 2015年 直订网365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ZDBombBox : NSObject<MBProgressHUDDelegate>

- (void)bombBoxWithBtn:(NSString *)text UIView:(UIView *)View;

@end
