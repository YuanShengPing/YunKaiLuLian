//
//  WebViewJSController.h
//  tripb
//
//  Created by 云开互联 on 16/5/27.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewJSControllerDelegata <NSObject>

@required

- (void)homeWithIndex;

@end


@interface WebViewJSController : UIViewController
//title
@property (nonatomic,copy)NSString *titleX;
//网站地址
@property (nonatomic,copy)NSString *url;

@property (nonatomic,weak)id<WebViewJSControllerDelegata> WebDelegate;

@end
