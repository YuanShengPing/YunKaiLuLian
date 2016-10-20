//
//  AppDelegate.h
//  test_xiaoyuan
//
//  Created by 云开互联 on 16/9/21.
//  Copyright © 2016年 YunKai HuLian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

