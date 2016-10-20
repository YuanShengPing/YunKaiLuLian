//
//  SNSCodeCountdownButton.h
//  SNSCodeTimerDemo
//
//  Created by CHENYI LONG on 14-11-24.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//


#import <UIKit/UIKit.h>

@class SNSCodeCountdownButton;
@protocol SNSCodeCountdownButtonDelegate <NSObject>
@optional
- (void)snsCodeCountdownButtonClicked;
- (void)textfieldWithInteractive;
@end

@interface SNSCodeCountdownButton : UIButton

@property (nonatomic, assign) NSInteger countdownBeginNumber;
@property (nonatomic, weak) id<SNSCodeCountdownButtonDelegate> delegate ;
@property (nonatomic, copy) NSString *normalStateImageName;
@property (nonatomic, copy) NSString *highlightedStateImageName;
@property (nonatomic, copy) NSString *selectedStateImageName;
@property (nonatomic, copy) NSString *normalStateBgImageName;
@property (nonatomic, copy) NSString *highlightedStateBgImageName;
@property (nonatomic, copy) NSString *selectedStateBgImageName;
/**
 *  页面将要进入前台，开启定时器
 */
-(void)distantPastTimer;
/**
 *  页面消失，进入后台不显示该页面，关闭定时器
 *
 */
-(void)distantFutureTimer;
//调用倒计时

- (void)initWithCountdownBeginNumber;
@end
