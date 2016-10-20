//
//  StudentModel.m
//  tripb
//
//  Created by 云开互联 on 16/4/18.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "StudentModel.h"
#import <objc/message.h>

@implementation StudentModel
// 存档的时候需要实现
- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.phone forKey:@"tel"];
    [aCoder encodeObject:self.login forKey:@"state"];
    [aCoder encodeObject:self.StateRefresh forKey:@"refresh"];
}

// 解档的时候需要实现
- (id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {
        
        self.phone        = [aDecoder decodeObjectForKey:@"tel"];
        self.login        = [aDecoder decodeObjectForKey:@"state"];
        self.StateRefresh = [aDecoder decodeObjectForKey:@"refresh"];
    }
    return self;
}
@end
