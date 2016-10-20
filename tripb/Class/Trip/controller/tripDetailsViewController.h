//
//  tripDetailsViewController.h
//  tripb
//
//  Created by 云开互联 on 16/5/26.
//  Copyright © 2016年 tripb. All rights reserved.
//
/**
 行程详情
 */
#import <UIKit/UIKit.h>

@protocol tripDetailsViewControllerDelegate <NSObject>

@optional
//申请单
- (void)remindWithMessage:(int)row NavigationBar:(BOOL)Correct;
//订单
- (void)orderWithMessage:(int)row NavigationBar:(BOOL)Correct;

@end


@interface tripDetailsViewController : UIViewController

@property (nonatomic,copy)NSString *tripId;

@property (nonatomic,assign)int row;

@property (nonatomic,strong)id<tripDetailsViewControllerDelegate> MessageDelegate;

@end
