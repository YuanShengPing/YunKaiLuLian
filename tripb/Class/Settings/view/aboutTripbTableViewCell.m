//
//  aboutTripbTableViewCell.m
//  tripb
//
//  Created by 云开互联 on 16/5/10.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "aboutTripbTableViewCell.h"

@implementation aboutTripbTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.update.layer.cornerRadius = 5;
//    self.bacView.layer.cornerRadius = 10;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"aboutTripbTableViewCell" owner:nil options:nil]lastObject];
//        NSLog(@"%@",[NSString stringWithFormat:@"企业差旅管家 %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]);
        
        self.update.text = [NSString stringWithFormat:@"企业差旅管家 V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    
    return self;
}






@end
