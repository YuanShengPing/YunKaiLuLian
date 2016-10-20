//
//  UserinfomModel.h
//  tripb
//
//  Created by 云开互联 on 16/08/05
//  Copyright (c) tripb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Applysummary,Needapprove;

@interface UserinfomModel : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, strong) NSArray<NSString *> *roles;

@property (nonatomic, copy) NSString *js_version;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *latestmsg;

@property (nonatomic, strong) Applysummary *applysummary;

@property (nonatomic, copy) NSString *lastestlogin;

@property (nonatomic, copy) NSString *latestmsg_url;

@property (nonatomic, copy) NSString *account_id;

@end