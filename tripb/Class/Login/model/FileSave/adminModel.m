//
//  adminModel.m
//  tripb
//
//  Created by 云开互联 on 16/5/13.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "adminModel.h"
#import <objc/message.h>

@implementation adminModel


// 存档的时候需要实现
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.admin forKey:@"admin"];
    
}
// 解档的时候需要实现
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.name  = [aDecoder decodeObjectForKey:@"name"];
        self.admin = [aDecoder decodeObjectForKey:@"admin"];
    }
    return self;
}

@end
