//
//  ZDCarousel.h
//  zhidingwang
//
//  Created by 袁胜平 on 15/10/16.
//  Copyright © 2015年 直订网365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDCycleScrollView.h"

@interface ZDCarousel : NSObject 

@property (nonatomic,assign)NSArray *imagesURLStringsS;

- (void)headerView:(UIView *)controller imageViewArrar:(NSArray *)array;

@end
