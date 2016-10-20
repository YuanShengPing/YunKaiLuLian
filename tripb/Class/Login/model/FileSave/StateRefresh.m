//
//  StateRefresh.m
//  tripb
//
//  Created by 云开互联 on 16/6/12.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "StateRefresh.h"
#import <objc/message.h>

@implementation StateRefresh


// 存档的时候需要实现
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.StateRefresh forKey:@"refresh"];
}

// 解档的时候需要实现
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.StateRefresh = [aDecoder decodeObjectForKey:@"refresh"];
    }
    return self;
}

@end
