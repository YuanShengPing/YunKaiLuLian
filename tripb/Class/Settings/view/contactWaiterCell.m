//
//  contactWaiterCell.m
//  tripb
//
//  Created by 云开互联 on 16/8/17.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "contactWaiterCell.h"

@implementation contactWaiterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"contactWaiterCell" owner:nil options:nil]lastObject];
      
    }
    
    return self;
}

@end
