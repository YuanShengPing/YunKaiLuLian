//
//  SearchCityViewController.h
//  tripb
//
//  Created by 云开互联 on 16/5/11.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface SearchCityViewController : UIViewController

@property (nonatomic,copy)NSString *pla;

@property (nonatomic,copy)NSString *tool;

@property (nonatomic,strong)JSContext *jsOc;

@end
