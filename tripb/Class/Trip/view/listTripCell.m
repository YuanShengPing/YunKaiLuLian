//
//  listTripCell.m
//  tripb
//
//  Created by 云开互联 on 16/4/28.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "listTripCell.h"
#import "FMDB.h"
#import "LVFmdbTool.h"


@interface listTripCell ()

@property (nonatomic,strong)UIImageView *arrow;

//@property(nonatomic,strong) FMDatabase *db;

@end

@implementation listTripCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self initWithView];
    }
    return self;
}

- (void)initWithView{
    
    self.backgroundColor = [UIColor whiteColor];

    self.toolImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    [self.toolImage setImage:[UIImage imageNamed:@"plane_32×32"]];
    [self addSubview:self.toolImage];

    self.order = [[UIImageView alloc]initWithFrame:CGRectMake(35, 8, 8, 8)];
    self.order.image = [UIImage imageNamed:@"red_point_small"];
    [self addSubview:self.order];
    
    self.city = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 100, 30)];
    [self.city setFont:[UIFont systemFontOfSize:16.0]];
    self.city.text = @"上海 - 北京";
    [self addSubview:self.city];
    
    self.time = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH *0.5 - 40, 5, 80, 30)];
//    在5下city丶time会重合，需要做判断
    if (WIDTH < 375) {
        self.time.x = 150;
    }
    [self.time setTextColor:[UIColor lightGrayColor]];
//    self.time.text = @"7月20日";
    self.time.font = fontX(14)
    self.time.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.time];
    
    self.money = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, 200, 20)];
    [self.money setTextColor:[UIColor lightGrayColor]];
//    self.money.text = @"金额 ￥2011.5 元";
    self.money.font = fontX(14)
    [self addSubview:self.money];
    
    self.address = [[UILabel alloc]initWithFrame:CGRectMake(50, 65, WIDTH - 120, 20)];
    self.address.textColor = [UIColor lightGrayColor];
    self.address.font = fontX(14)
//    self.address.text = @"所属申请: 去杭州与马云共进晚餐";
    [self addSubview:self.address];
    
    self.state = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 70, 40, 60, 20)];
//    self.state.text = @"出票中";
    self.state.font = fontX(14);
    self.state.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.state];
    
    self.reapply = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 70, 65, 60, 20)];
    self.reapply.text = @"重新预订";
    self.reapply.font = fontX(14);
    self.reapply.textColor =COLOR_DeepBlue ;
    self.reapply.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.reapply];
    
   }

- (void)setModel:(tripbHistModel *)model{

    _model = model;
    
    if ([@"航班"isEqualToString:self.model.order_type ]) {
        self.toolImage.image = [UIImage imageNamed:@"order_flight"];
    }else if([@"火车"isEqualToString:self.model.order_type ]){
    self.toolImage.image = [UIImage imageNamed:@"order_train"];
    }else if([@"酒店"isEqualToString:self.model.order_type ]){
        self.toolImage.image = [UIImage imageNamed:@"order_hotel"];
    }
    self.city.text = self.model.order_city_title;
    self.time.text = self.model.order_starttime;
    
    
    if ([self.model.order_step intValue] > 1) {
         NSMutableAttributedString *tools = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付金额 ￥%@",self.model.order_true_total_money]];
         [tools addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]range:NSMakeRange(5,(int)self.model.order_true_total_money.length+1)];
//        实际金额
        self.money.attributedText = tools ;
    }else{
        
        NSMutableAttributedString *tool = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估金额 ￥%@",self.model.order_total_estimate]];
        [tool addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]range:NSMakeRange(5,(int)self.model.order_total_estimate.length+1)];
        self.money.attributedText = tool ;
//        预估金额
//        self.money.text = tool;
    }
    
        self.address.text = [NSString stringWithFormat:@"所属申请:%@",self.model.order_applyreason];
    
    self.state.text =  self.model.order_status;
    
    if ([self.model.order_status isEqualToString:@"待支付"]) {
      
        self.state.textColor = COLOR_Blue;
    }else{
    
        self.state.textColor = [UIColor blackColor];
    }

    
    self.ID = self.model.order_id;
    
   
    if ([self.model.order_reapply_flag intValue] == 1) {
      
        self.reapply.hidden = NO;
    }else{
        self.reapply.hidden = YES;
        
    }      
    
    if ([self.model.order_red_flag isEqualToString:@"1"]) {
    
        self.order.hidden = NO;
    }else{
    
      self.order.hidden = YES;
      
    }

}






@end
