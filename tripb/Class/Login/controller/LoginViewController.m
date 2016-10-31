//
//  LoginViewController.m
//  tripb
//
//  Created by 云开互联 on 16/4/13.
//  Copyright © 2016年 tripb. All rights reserved.
//



#import "LoginViewController.h"
#import "SNSCodeCountdownButton.h"
#import "AFNetworking.h"
#import "ToToolHelper.h"
#import "ZDBombBox.h"
#import "StudentModel.h"
#import "WebViewJSController.h"
#import "ReachabilityBool.h"
#import "MBProgressHUD.h"
#import "StateRefresh.h"
#import "DanLi.h"

@interface LoginViewController ()<UITextFieldDelegate,SNSCodeCountdownButtonDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>{

    SNSCodeCountdownButton * _sendButton;
}
@property (nonatomic,strong)MBProgressHUD *HUD;

@property (nonatomic,copy)NSString *enterprise_id;

@property (nonatomic,strong)UITextField *phoneNumber;
//验证码
@property (nonatomic,strong)UITextField *Verification;
//登入按钮
@property (nonatomic,strong)UIButton *loginButton;
//
@property (nonatomic,strong)UIButton *Selected;

@property (nonatomic, weak) NSTimer *timer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:COLOR_LightGray];
    self.title = @"登录/注册";
    
    [self MobilePhoneRegistrationInstructions];

//    登入按钮
    [self loginWithButton];
  
}

- (void)MobilePhoneRegistrationInstructions{

    NSString *explain = [NSString stringWithFormat:@"请输入手机号码，获取验证码后登录"];
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH - 20, 60)];
    textLable.numberOfLines = 0;
    textLable.text = explain;
    textLable.font = fontX(16);
    [self.view addSubview:textLable];
    
    UIView *inputPhone = [[UIView alloc]initWithFrame:CGRectMake(0, 60, WIDTH, 88)];
//    inputPhone.backgroundColor = [UIColor grayColor];
    [self.view addSubview:inputPhone];
    inputPhone.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44 , WIDTH, 1)];
    line.backgroundColor = RGB(242, 243, 245);
    [inputPhone addSubview:line];
    
//    倒计时
    CGRect snsButtonFrame=CGRectMake(WIDTH - 110 ,45 ,110,44);
    _sendButton = [[SNSCodeCountdownButton alloc] initWithFrame:snsButtonFrame];
    _sendButton.backgroundColor = RGB(0, 140, 223);
    _sendButton.countdownBeginNumber = 60;
    _sendButton.delegate = self;
    [inputPhone addSubview:_sendButton];
    
    
    UIImageView *imagepHone = [[UIImageView alloc]init];
    
    imagepHone.image = [UIImage imageNamed:@"phonemunber"];
    [inputPhone addSubview:imagepHone];
    imagepHone.frame = CGRectMake(15, 12, 20, 20);
    
    
    UIImageView *imagepPWD = [[UIImageView alloc]init];
    imagepPWD.image = [UIImage imageNamed:@"pwd"];
    [inputPhone addSubview:imagepPWD];
    imagepPWD.frame = CGRectMake(15, 56, 20, 20);
    
    self.phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(50,0,WIDTH-50,44)];
    self.phoneNumber.placeholder = @"请输入手机号码";
    self.phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;/*添加删除按钮*/
//    self.phoneNumber.layer.cornerRadius = 10;
//    self.phoneNumber.clipsToBounds = YES;
    //   解档赋值
    LoginState *state = [LoginState new];
    if ([state LoginStateWithBumber]) {
        
        self.phoneNumber.text = state.phone;
    }
    //    不可编辑状态
    //    self.phoneNumber.userInteractionEnabled = NO;
    self.phoneNumber.keyboardType =UIKeyboardTypeNumberPad;
    self.phoneNumber.tag = 101;
    
    
    [inputPhone addSubview:self.phoneNumber];
    
    self.Verification = [[UITextField alloc]initWithFrame:CGRectMake(50,45,WIDTH - 160,44)];
    self.Verification.keyboardType =UIKeyboardTypeNumberPad;
    self.Verification.tag = 102;
    self.Verification.placeholder = @"请输入验证码";
    [inputPhone addSubview:self.Verification];
    
    self.phoneNumber.delegate = self;
    self.Verification.delegate =self;

}



//
- (void)snsCodeCountdownButtonClicked {

    ToToolHelper *totoo = [ToToolHelper new];
    if ([totoo isMobileNumber:self.phoneNumber.text]){

        ReachabilityBool *status = [ReachabilityBool new];
        
        if ([status reachabilityWithStatus]) {
            
            //      倒计时
            [_sendButton initWithCountdownBeginNumber];
            self.phoneNumber.userInteractionEnabled = NO;
            
            [self phoneWithCode];
        }else{
            
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"请检查网络状况!" UIView:self.view];
        }

    }else{
    
        ZDBombBox *box = [ZDBombBox  new];
        
        [box bombBoxWithBtn:@"您输入的手机号码有误！" UIView:self.view];
        
    }
    
}

   
//获取验证码 只请求回来了数据
- (void)phoneWithCode{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url =[NSString stringWithFormat:@"%@/api/user/send_sms_verify_code.html",[URLstate URLstateWithString]]; /*AFNurl(@"/api/user/", @"send_sms_verify_code");*/
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobilenumber"] =self.phoneNumber.text;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"responseObject:%@",responseObject);
        NSString *result = [responseObject objectForKeyedSubscript:@"result"];
        if (![@"success"isEqualToString:result]){
            
            NSString *errormsg = [responseObject objectForKeyedSubscript:@"errormsg"];
//            关闭定时器
            [_sendButton distantFutureTimer];
            ZDBombBox *box = [ZDBombBox  new];
            [_sendButton setTitle:@"重新获取" forState:UIControlStateNormal];
            self.phoneNumber.userInteractionEnabled = YES;
            _sendButton.userInteractionEnabled = YES;
            [box bombBoxWithBtn:errormsg UIView:self.view];
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error=%@",error);
    }];


}

- (void)textfieldWithInteractive{

   // NSLog(@"进入发送验证码");
    if (_sendButton.selected == YES) {
      //  NSLog(@"重新发送");
        self.phoneNumber.userInteractionEnabled = NO;
    }else{
        //        允许输入
        self.phoneNumber.userInteractionEnabled = YES;
       // NSLog(@"60秒等待时间");
    }
}


//禁止用户输入超过11过数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumber) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >11) {
            return NO;
        }
    }
    
    if (textField == self.Verification) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength >6) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField.tag == 101){
        
        _phoneNumber.text =textField.text;
        
    }else if (textField.tag == 202){
        
        _Verification.text = textField.text;
        
    }
}
//退出键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneNumber  resignFirstResponder];
    [self.Verification resignFirstResponder];
}

- (void)loginWithButton{
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(10,168 ,WIDTH-20,44)];
    self.loginButton.backgroundColor =  MainTone;
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginWithActionButton) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.loginButton];
    
    
     self.Selected = [[UIButton alloc]initWithFrame:CGRectMake(15, 232 , 20, 20)];
    [self.view addSubview:self.Selected];
    [self.Selected setImage:[UIImage imageNamed:@"xuanze_weixuanzong"] forState:UIControlStateNormal];
    [self.Selected setImage:[UIImage imageNamed:@"xuanze_xuanzhong"] forState:UIControlStateSelected];
    self.Selected.selected = YES;
    [self.Selected addTarget:self action:@selector(State:) forControlEvents:UIControlEventTouchDown];

    
    UILabel *read = [[UILabel alloc]init];
    read.text = @"同意";
    read.font = fontX(14);
    read.width = 35;
    read.height = 20;
    read.centerY = self.Selected.centerY;
    read.x = 40;
    [self.view addSubview: read];
    
    UIButton *clause = [[UIButton alloc]init];
    [clause addTarget:self action:@selector(ServiceProvision) forControlEvents:UIControlEventTouchDown];
    [clause setTitle:@"《差旅管家用户服务协议》" forState:UIControlStateNormal];
    clause.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    clause.titleLabel.font = fontX(14);
    clause.width =200;
    clause.height =20;
    clause.centerY =self.Selected.centerY;
    clause.x =65;
    [self.view addSubview:clause];
    [clause setTitleColor:RGB(13, 98, 254) forState:UIControlStateNormal];
}
- (void)ServiceProvision{

    WebViewJSController *Sp = [WebViewJSController new];
    
    [self.navigationController pushViewController:Sp animated:YES];

    Sp.url = @"msg/clause";
}

- (void)State:(UIButton *)sender {
    
    if(self.Selected.selected == YES){
        
        self.Selected.selected = NO;
    }else{
        
        self.Selected.selected = YES;
    }
}

- (void)loginWithActionButton{
    [self.phoneNumber resignFirstResponder];
    [self.Verification resignFirstResponder];
    
    ToToolHelper *verification = [ToToolHelper new];
    
    if ([verification isMobileNumber:self.phoneNumber.text]) {
       
        if (self.Verification.text.length == 6) {
//            NSLog(@"post到服务器登陆");
            if(self.Selected.selected == YES){
                
                ReachabilityBool *status = [ReachabilityBool new];
                
                if ([status reachabilityWithStatus]) {

                    [self postWithPhoneCode];

                }else{
                    ZDBombBox *box = [ZDBombBox  new];
                    
                    [box bombBoxWithBtn:@"请检查网络状况!" UIView:self.view];
                }
            }else{
                
                ZDBombBox *box = [ZDBombBox  new];
                
                [box bombBoxWithBtn:@"请阅读服务条款" UIView:self.view];
            }
     
        }else{
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"请输入有效的验证码" UIView:self.view];
        }
        
    }else{
    
        ZDBombBox *box = [ZDBombBox  new];
        
        [box bombBoxWithBtn:@"请输入有效手机号码" UIView:self.view];
    
    }
}

- (void)postWithPhoneCode{

//    初始化进度框，置于当前的View当中
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    //如果设置此属性则当前的view置于后台
    self.HUD.dimBackground = NO;
    //设置对话框文字
    self.HUD.labelText = @"请稍等";
    [self.HUD show:YES];

   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = AFNTime;
    NSString *url =[NSString stringWithFormat:@"%@/api/user/login_user.html",[URLstate URLstateWithString]]; /*AFNurl(@"/api/user/", @"login_user");*/
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobilenumber"] = self.phoneNumber.text;
    dict[@"verifycode"] = self.Verification.text;
    dict[@"registerflag"] = @"true";
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"responseObject=%@",responseObject);
        
        NSString *result = [responseObject objectForKeyedSubscript:@"result"];

        if ([@"success"isEqualToString:result]) {
            
            [self channelIdPushSeve];
            //保存登入状态和手机号码
            [self dataWithFileData];
            [self StateRefresh];
            NSString *enterprise = [responseObject objectForKey:@"enterprise_id"];
            self.enterprise_id = enterprise;
            int number = [enterprise intValue];
//            NSLog(@"number:%d",number);
            if (number == 0) {
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFire) userInfo:nil repeats:NO];
            }

            [self pushWithImage:@"ok" title:@"登入成功"];
               
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
        
        }else{
         NSString *error = [responseObject objectForKey:@"errormsg"];
            [ self pushWithImage:@"no" title:error];
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error : %@",error);
        [_sendButton distantFutureTimer];
        [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.phoneNumber.userInteractionEnabled = YES;
        _sendButton.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
        [self pushWithImage:@"no" title:@"登入失败"];
    }];
}


//set_baiduchannel 上传channel id
- (void)channelIdPushSeve{
    
   
    NSString *url = [NSString stringWithFormat:@"%@/api/user/set_pushchannel.html?device=iOS&channelid=%@",[URLstate URLstateWithString],[DanLi sharedDanLi].channel_id];
//    NSLog(@"url : %@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"=======%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败");
        
    }];
    
    
}


- (void)pushWithImage:(NSString *)image title:(NSString *)title{
   [self.HUD removeFromSuperview];
    self.HUD = nil;
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    
    if (title.length > 7) {
  
    NSMutableString *strArray = [[NSMutableString alloc]initWithString:title];

        for (int i = 0; i < strArray.length / 5; i++) {
            int n = 5 * (i + 1) + i;
            if (n < strArray.length) {
                 [strArray insertString:@"\n" atIndex:n];
            }
        }
 
    self.HUD.labelText = strArray;
    }else{
    self.HUD.labelText = title;
    }
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }];


}



- (void)timerFire{

     [[NSNotificationCenter defaultCenter] postNotificationName:@"upCompany" object:nil];

}


- (void)StateRefresh{
    
    [DanLi sharedDanLi].UpData   = @"UpData";
    [DanLi sharedDanLi].UpOrder  = @"UpOrder";
    StateRefresh *Refresh = [StateRefresh new];
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"RefreshHome.data"];
        //            归档手机号码
        Refresh.StateRefresh = [NSString stringWithFormat:@"Refresh"];
        [NSKeyedArchiver archiveRootObject:Refresh toFile:file];
}


- (void)dataWithFileData{
    StudentModel *student = [StudentModel new];
    LoginState *state = [LoginState new];
    if ([state LoginStateWithBumber]) {
        //             删除归档数据
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"phoneNumber.data"];
     
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        [defaultManager removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"phoneNumber.data"] error:nil];
        //            归档手机号码
        student.phone = self.phoneNumber.text;
        student.login = [NSString stringWithFormat:@"state"];
        [NSKeyedArchiver archiveRootObject:student toFile:file];
    }else{ 
    
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"phoneNumber.data"];
        student.login = [NSString stringWithFormat:@"state"];
        student.phone = self.phoneNumber.text;
       
        [NSKeyedArchiver archiveRootObject:student toFile:file];
    }

}



@end
