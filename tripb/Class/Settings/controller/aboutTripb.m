//
//  aboutTripb.m
//  tripb
//
//  Created by 云开互联 on 16/5/10.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "aboutTripb.h"
#import "aboutTripbTableViewCell.h"
#import "WebViewJSController.h"


@interface aboutTripb ()<UIAlertViewDelegate>
@property (nonatomic,strong)NSURL *urlTel;


@end

@implementation aboutTripb

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于企业差旅管家";
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = COLOR_LightGray;
    self.tableView.scrollEnabled = NO;

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0) {
      static NSString *ID = @"tripb";
       aboutTripbTableViewCell *cell = [[aboutTripbTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if (! cell) {
            cell = [[aboutTripbTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
        
    }else{
    
        NSString *ID =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
    
        if (indexPath.section == 1) {
            cell.textLabel.text = @"企业差旅管家服务条款";
        }else if (indexPath.section == 2){
        
        cell.textLabel.text = @"给差旅管家好评";
        }
    cell.textLabel.font = fontX(16);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {

            WebViewJSController *Sp = [WebViewJSController new];
            
            [self.navigationController pushViewController:Sp animated:YES];
            
            Sp.url = @"msg/clause";
    }else if(indexPath.section == 2){
    
          [self updataEditionWithData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 230;
    }else{
        return 44;
    }
    
}

//http://itunes.apple.com/app/id1103625202
- (void)updataEditionWithData{

     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1103625202"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存泄露");
}




@end
