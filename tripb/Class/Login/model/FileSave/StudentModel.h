//
//  StudentModel.h
//  tripb
//
//  Created by 云开互联 on 16/4/18.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "iKYSerialization.h"


@interface StudentModel : iKYSerialization <NSCoding>

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *login;

@property (nonatomic,copy)NSString *StateRefresh;

@end
