//
//  listTripCell.h
//  tripb
//
//  Created by 云开互联 on 16/4/28.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tripbHistModel.h"

@interface listTripCell : UITableViewCell

@property (nonatomic,strong)UIImageView *toolImage;

@property (nonatomic,strong)UILabel *city;

@property (nonatomic,strong)UILabel *time;

@property (nonatomic,strong)UILabel *money;

@property (nonatomic,strong)UILabel *address;

@property (nonatomic,strong)UILabel *state;

@property (nonatomic,strong)UILabel *reapply;

@property (nonatomic,copy)NSString *ID;

@property (nonatomic,strong)tripbHistModel *model;

@property (nonatomic,strong)UIImageView *order;



@end
