//
//  OrderCell.m
//  tripb
//
//  Created by 云开互联 on 16/8/3.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "OrderCell.h"



@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initWithView];
    }
    return self;
}


- (void)initWithView{
    
    self.apply_red = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 8, 8)];
    self.apply_red.image = [UIImage imageNamed:@"red_point_small"];
    [self addSubview:self.apply_red];
    
    self.travel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, WIDTH - 140, 20)];
    [self addSubview:self.travel];
    self.travel.text = @"去杭州与马云见面";
    
    self.time = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, WIDTH - 160, 20)];
    self.time.font = fontX(14);
    self.time.text = @"申请时间: 7月25日 周一 15:00";
    self.time.textColor = [UIColor lightGrayColor];
    [self addSubview:self.time];
    
    self.state = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 120,35, 100, 20)];
    self.state.font = fontX(14);
    self.state.text = @"未审批";
    self.state.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.state];
    
    self.toos = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, WIDTH - 160 , 20)];
    self.toos.font = fontX(14);
    self.toos.text = @"航班 1 次 火车 2 次 酒店 3 次";
    self.toos.textColor = [UIColor lightGrayColor];
    [self addSubview:self.toos];
    
    self.money = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 140,60, 120, 20)];
    self.money.font = fontX(14);
    self.money.text = @"预估总价￥2000";
    self.money.textAlignment = NSTextAlignmentRight;
    self.money.textColor = [UIColor lightGrayColor];
    [self addSubview:self.money];
    
   

}

- (void)setModel:(orderDataModel *)model{

    _model = model;
    
    self.travel.text = [NSString stringWithFormat:@"%@",self.model.apply_reason];
    self.time.text = [NSString stringWithFormat:@"申请时间:%@",self.model.apply_applytime];
    self.state.text = [NSString stringWithFormat:@"%@",self.model.apply_approvedstatus];
//    self.toos.text = [NSString stringWithFormat:@"飞机 %@ 次 火车 %@ 次 酒店 %@ 间夜",self.model.flight_count,self.model.train_count,self.model.hotel_count];

    NSMutableAttributedString *tools = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"航班 %@ 次 火车 %@ 次 酒店 %@ 次",self.model.flight_count,self.model.train_count,self.model.hotel_count]];
    [tools addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1D89E4"]range:NSMakeRange(3,(int)self.model.flight_count.length)];
    [tools addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1D89E4"]range:NSMakeRange(3 + (int)self.model.flight_count.length +6,(int)self.model.train_count.length)];
    [tools addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1D89E4"]range:NSMakeRange(3 + (int)self.model.flight_count.length +6+(int)self.model.train_count.length+6,(int)self.model.hotel_count.length)];
    self.toos.attributedText = tools;
    
    
    self.ID = [NSString stringWithFormat:@"%@",self.model.apply_id];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预估总价￥%@",self.model.estimate]];
    int a ;
    a = 1 + (int)self.model.estimate.length;
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FEA733"]range:NSMakeRange(4,a)];
    
    self.money.attributedText = str;
    
       if ([self.model.apply_red_flag isEqualToString:@"1"]) {
        
        self.apply_red.hidden = NO;
        
    }else{
        
        self.apply_red.hidden = YES;
    }
    




}

@end
