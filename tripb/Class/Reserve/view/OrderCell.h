//
//  OrderCell.h
//  tripb
//
//  Created by 云开互联 on 16/8/3.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderDataModel.h"

@interface OrderCell : UITableViewCell
//出行理由
@property (nonatomic,strong)UILabel *travel;
//出差申请时间
@property (nonatomic,strong)UILabel *time;
//审批状态
@property (nonatomic,strong)UILabel *state;
//出行工具
@property (nonatomic,strong)UILabel *toos;
//总预算
@property (nonatomic,strong)UILabel *money;
//id
@property (nonatomic,copy)NSString *ID;

@property (nonatomic,strong)orderDataModel *model;

@property (nonatomic,strong)UIImageView *apply_red;

@end
