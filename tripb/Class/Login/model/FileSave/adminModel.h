//
//  adminModel.h
//  tripb
//
//  Created by 云开互联 on 16/5/13.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "iKYSerialization.h"

@interface adminModel : iKYSerialization <NSCoding>

@property (nonatomic,copy)NSString *admin;

@property (nonatomic,copy)NSString *name;


@end
