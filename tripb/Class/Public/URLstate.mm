//
//  URLstate.m
//  tripb
//
//  Created by 云开互联 on 2016/10/18.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "URLstate.h"

@implementation URLstate


+ (NSString *)URLstateWithString{

    if([[DanLi sharedDanLi].UpEnvironmental isEqualToString:@"mantis"]){
        
        return [NSString stringWithFormat:@"http://mantis.test.tripb.cn"];
        
    }else if ([[DanLi sharedDanLi].UpEnvironmental isEqualToString:@"monkey"]){
        
        return [NSString stringWithFormat:@"http://monkey.test.tripb.cn"];
        
    }else if ([[DanLi sharedDanLi].UpEnvironmental isEqualToString:@"pre"]){
        
        return [NSString stringWithFormat:@"http://pre.tripb.cn"];
        
    }else if ([[DanLi sharedDanLi].UpEnvironmental isEqualToString:@"master"]){
        
        return [NSString stringWithFormat:@"http://master.test.tripb.cn"];
        
    }else /*if ([[DanLi sharedDanLi].UpEnvironmental isEqualToString:@"m"])*/{
        
        return [NSString stringWithFormat:@"http://m.tripb.cn"];
        
    }

}

@end
