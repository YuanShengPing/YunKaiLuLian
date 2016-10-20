//
//  SettingsTableViewCell.m
//  tripb
//
//  Created by 云开互联 on 16/4/20.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "SettingsTableViewCell.h"
@interface SettingsTableViewCell ()

@end

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.layer.cornerRadius =29;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:nil options:nil]lastObject];
 
    }
    
    return self;
}


@end
