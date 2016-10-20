//
//  CompanyPlay.m
//  tripb
//
//  Created by 云开互联 on 16/9/19.
//  Copyright © 2016年 tripb. All rights reserved.
//

#import "CompanyPlay.h"
#import "SNSCodeCountdownButton.h"
#import "ToToolHelper.h"
#import "ReachabilityBool.h"
#import "AFNetworking.h"

@interface CompanyPlay ()<SNSCodeCountdownButtonDelegate,UITextFieldDelegate>{

    SNSCodeCountdownButton * _sendButton;
}

@property (nonatomic,strong)UITextField *textPhone;

@property (nonatomic,copy)NSString *phone;

@end

@implementation CompanyPlay

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"单位支付";
    [self playWithView];
}


- (void)playWithView{


    LoginState *state = [LoginState new];
    if ([state LoginStateWithBumber]) {
        
        self.phone = state.phone;
    }

    NSString *str = [NSString stringWithFormat:@"%@****%@",[self.phone substringToIndex:3],[self.phone substringFromIndex:7]];
    
    UILabel *Prompt = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, WIDTH, 30)];
    [self.view addSubview:Prompt];
    NSMutableAttributedString *tools = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已将支付验证码发送到手机%@",str]];
 
    [tools addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1D89E4"]range:NSMakeRange(12,11)];
    Prompt.attributedText = tools;
    Prompt.textAlignment = NSTextAlignmentCenter;
  
    UILabel *Notes = [UILabel new];
    Notes.width = 150;
    Notes.height = 30;
    Notes.y = 120;
    Notes.x = (WIDTH - 260) * 0.5;
    Notes.text = @"请输入验证码";
    Notes.textColor = COLOR_DarkGrey;
    Notes.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:Notes];
    
    self.textPhone = [UITextField new];
    [self.view addSubview:self.textPhone];
    self.textPhone.width = 150;
    self.textPhone.height = 40;
    self.textPhone.y = 150;
    self.textPhone.x =  (WIDTH - 260) * 0.5 ;
    self.textPhone.delegate = self;
    self.textPhone.layer.borderWidth = 1;
    self.textPhone.layer.borderColor = [COLOR_DarkGrey CGColor];
    self.textPhone.layer.cornerRadius = 5;
    self.textPhone.keyboardType =UIKeyboardTypeNumberPad;
    
    _sendButton = [SNSCodeCountdownButton new] ;
//    _sendButton.backgroundColor = RGB(0, 140, 223);
    _sendButton.countdownBeginNumber = 60;
    _sendButton.delegate = self;
    [self.view addSubview:_sendButton];
    _sendButton.width = 100;
    _sendButton.height = 40;
    _sendButton.x = (WIDTH - 260) * 0.5 + 160;
    _sendButton.y = 150;
    [_sendButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _sendButton.tintColor = COLOR_DarkGrey;
    _sendButton.layer.cornerRadius = 5;
    _sendButton.layer.borderWidth = 1;
    _sendButton.layer.borderColor = [COLOR_DarkGrey CGColor];
 
    UIButton *Verification = [UIButton new];
    Verification.width = 250;
    Verification.height = 40;
    Verification.centerX = self.view.centerX;
    Verification.y = 220;
    [self.view addSubview:Verification];
    
    [Verification setTitle:@"确定" forState:UIControlStateNormal];
    Verification.backgroundColor = COLOR_DeepBlue;
    [Verification addTarget:self action:@selector(VerificationWithCode) forControlEvents:UIControlEventTouchDown];
    Verification.layer.cornerRadius = 5;
  

}

//禁止用户输入超过11过数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textPhone) {
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


- (void)snsCodeCountdownButtonClicked {
    
    [self.textPhone resignFirstResponder];

    ReachabilityBool *status = [ReachabilityBool new];
        
        if ([status reachabilityWithStatus]) {
            
            //      倒计时
            [_sendButton initWithCountdownBeginNumber];
           
            [self phoneWithCode];
           
        }else{
            
            ZDBombBox *box = [ZDBombBox  new];
            
            [box bombBoxWithBtn:@"请检查网络状况!" UIView:self.view];
        }
        
        
}

- (void)VerificationWithCode{
    
    
    [self.textPhone resignFirstResponder];
    
    if (self.textPhone.text.length == 6) {
        
         self.textPhone.userInteractionEnabled = NO;
       
        [self.navigationController popViewControllerAnimated:YES];
        
        JSValue *picCallback = self.jsString[@"epayReseult"];
        [picCallback callWithArguments:@[self.textPhone.text]];
        
    }else{
    
        ZDBombBox *box = [ZDBombBox  new];
        
        [box bombBoxWithBtn:@"您输入的验证码有误!" UIView:self.view];
    
    }

}


//获取验证码 只请求回来了数据
- (void)phoneWithCode{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url =[NSString stringWithFormat:@"%@/api/user/send_sms_verify_code.html",[URLstate URLstateWithString]];/*AFNurl(@"/api/user/", @"send_sms_verify_code");*/
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobilenumber"] =self.phone;
    dict[@"send_type"] =@"epay";
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"responseObject:%@",responseObject);
        NSString *result = [responseObject objectForKeyedSubscript:@"result"];
        if (![@"success"isEqualToString:result]){
            
            NSString *errormsg = [responseObject objectForKeyedSubscript:@"errormsg"];
            //            关闭定时器
            [_sendButton distantFutureTimer];
            ZDBombBox *box = [ZDBombBox  new];
            [_sendButton setTitle:@"重新获取" forState:UIControlStateNormal];
            self.textPhone.userInteractionEnabled = YES;
            _sendButton.userInteractionEnabled = YES;
            [box bombBoxWithBtn:errormsg UIView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error=%@",error);
    }];
    
    
}

@end
