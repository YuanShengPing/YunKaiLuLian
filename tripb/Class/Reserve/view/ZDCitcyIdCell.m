//
//  ZDCitcyIdCell.m
//  lazy-hotel
//
//  Created by 袁胜平 on 15/11/22.
//  Copyright © 2015年 直 订网365. All rights reserved.
//

#import "ZDCitcyIdCell.h"

@implementation ZDCitcyIdCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"ZDCitcyIdCell" owner:nil options:nil]lastObject];
        
        
    }
    
    return self;
}


@end
