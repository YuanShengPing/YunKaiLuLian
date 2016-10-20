//
//  SettingsTableViewCell.h
//  tripb
//
//  Created by 云开互联 on 16/4/20.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UserNameModel.h"

@interface SettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *NotLogin;

//@property (nonatomic,strong)UserNameModel *model;

@end
