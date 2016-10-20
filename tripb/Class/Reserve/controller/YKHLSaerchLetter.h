//
//  YKHLSaerchLetter.h
//  tripb
//
//  Created by 云开互联 on 16/5/12.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface YKHLSaerchLetter : UIViewController

@property (nonatomic,copy)NSString *pla;

@property (nonatomic,strong)JSContext *jsOc;

@property (nonatomic,copy)NSString *letter;

@property (nonatomic,strong)NSMutableArray *letterCity;

@end
