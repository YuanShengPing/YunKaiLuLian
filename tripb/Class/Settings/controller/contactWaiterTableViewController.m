//
//  contactWaiterTableViewController.m
//  tripb
//
//  Created by 云开互联 on 16/8/17.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "contactWaiterTableViewController.h"
#import "contactWaiterCell.h"


@interface contactWaiterTableViewController ()

@end

@implementation contactWaiterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =COLOR_LightGray;
    self.tableView.tableFooterView = [UIView new];
    self.title = @"联系客服";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        static NSString *ID = @"cellId";
        contactWaiterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            cell = [[contactWaiterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *ID = @"indexId";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        UIImage *icon = [UIImage imageNamed:@"tel_phone"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"管家电话 18010485492";
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 170;
    }else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, 10)];
    view.backgroundColor = COLOR_LightGray;
    
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
    }else{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://18010485492"]];
    }
    
    
}


@end
