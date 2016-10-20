//
//  ZDCitcyIdCell.h
//  lazy-hotel
//
//  Created by 袁胜平 on 15/11/22.
//  Copyright © 2015年 直 订网365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDCitcyIdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *city;



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
