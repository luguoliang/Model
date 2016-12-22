//
//  ViewController.m
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/7.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "ViewController.h"
#import "BaoFuenjoryCerPayment.h"
#import "BaoFuBufferView.h"
#import "BFProgressHUD.h"
#import "RequestManager.h"
#import "BankListViewController.h"
@interface ViewController ()<UITextFieldDelegate,UIScrollViewDelegate,BaoFuenjoryCerPaymentDelegate,UIAlertViewDelegate>{
    BaoFuenjoryCerPayment*_web;
    BaoFuenjoryCerPayment*_payment;
    UIBarButtonItem *leftBarBtn;
    UIBarButtonItem *rightBarBtn;
}
@property(nonatomic,strong)UIScrollView *rootScrollView;
@property(nonatomic,strong)UITextField *moneyField;//充值金额
@property(nonatomic,strong)UITextField *bankField;//银行名称
@property(nonatomic,strong)UIImageView *bankNameLeftImageView;//银行图片
@property(nonatomic,strong)UITextField *bankCardField;//银行卡号
@property(nonatomic,strong)UITextField *nameField;//用户名称
@property(nonatomic,strong)UITextField *idCardField;//身份证号码
@property(nonatomic,strong)UITextField *telPhoneField;//身份证号码
@property(nonatomic,strong)UIButton *comfireRechargeBtn;//确认充值按钮
@property(nonatomic,copy)NSString *bankCode;//银行简称
@property(nonatomic,copy)NSString *bankId;//银行ID
@property(nonatomic,copy)NSString *textorture;//测试或者正式环境 1正式环境 2测试环境
@property(nonatomic,copy)NSString*nastyle;//0是白色，1，橘橙色
@end

@implementation ViewController
static UILabel *__bankNameLabel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.bankDict != nil) {
        for (UIView *view in self.bankField.leftView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                [label removeFromSuperview];
                __bankNameLabel = label;
                [self.bankField.leftView addSubview:self.bankNameLeftImageView];
            }
        }
        self.bankId = self.bankDict[@"bankId"];
        self.bankCode = self.bankDict[@"bankCode"];
        self.bankField.text = self.bankDict[@"bankName"];
        NSString *mainPath = [[NSBundle mainBundle] pathForResource:@"bankImage" ofType:@"bundle"];
        NSString *imagePath = [mainPath stringByAppendingPathComponent:[NSString stringWithFormat:@"logo/%@.png",self.bankDict[@"bankId"]]];
        self.bankNameLeftImageView.image = [UIImage imageWithContentsOfFile:imagePath];
        [self judgeMethod];
    }
     NSLog(@"%@",self.bankDict);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试demo";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGB(BACKGROUND_COLOR);
    self.textorture = @"2";//默认测试环境
    _nastyle = @"0";//默认样式为白色
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"demo默认是测试环境" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"切换环境" style:UIBarButtonItemStylePlain target:self action:@selector(ceshiEnvironment)];
    [leftBarBtn setTintColor:[UIColor colorWithRed:255.0f/255.0f green:131.0f/255.0f blue:40.0f/255.0f alpha:1]];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"设置主题" style:UIBarButtonItemStylePlain target:self action:@selector(zhengshiEnvironment)];
    [rightBarBtn setTintColor:[UIColor colorWithRed:255.0f/255.0f green:131.0f/255.0f blue:40.0f/255.0f alpha:1]];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.moneyField];
    [self.rootScrollView addSubview:self.bankField];
    [self.rootScrollView addSubview:self.bankCardField];
    [self.rootScrollView addSubview:self.nameField];
    [self.rootScrollView addSubview:self.idCardField];
    [self.rootScrollView addSubview:self.telPhoneField];
    [self.rootScrollView addSubview:self.comfireRechargeBtn];
}
//测试环境
- (void)ceshiEnvironment
{
//    self.textorture = @"2";
//    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"切换为测试环境" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    UIAlertView*envirAlert =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"选择运行环境" delegate:self cancelButtonTitle:@"测试环境" otherButtonTitles:@"正式环境", nil];
    envirAlert.tag = 101;
    [envirAlert show];
}
//正式环境
- (void)zhengshiEnvironment
{
//    self.textorture = @"1";
   UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"选择样式" delegate:self cancelButtonTitle:@"白色主题" otherButtonTitles:@"橙色主题",@"房天下定制主题", nil];
    alert.tag = 011;
    [alert show];
}
#pragma mark--滑动视图
- (UIScrollView *)rootScrollView
{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0f, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _rootScrollView.backgroundColor = UIColorFromRGB(BACKGROUND_COLOR);
        _rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _rootScrollView.alwaysBounceVertical = YES;
        _rootScrollView.delegate = self;
    }
    return _rootScrollView;
}
#pragma mark--充值金额
- (UITextField *)moneyField
{
    if (!_moneyField) {
        _moneyField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 40.0f)];
        _moneyField.backgroundColor = [UIColor whiteColor];
        _moneyField.leftView = [self leftViewLabelWithText:@"金   额"];
        _moneyField.leftViewMode = UITextFieldViewModeAlways;
        _moneyField.font = FONT(14.0f);
        _moneyField.placeholder = @"请输入金额";
        _moneyField.text = @"1";
        [_moneyField addTarget:self action:@selector(textFieldChangeMethod:) forControlEvents:UIControlEventEditingChanged];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 39.5f, SCREEN_WIDTH-10.0f, 0.5f)];
        lineLabel.backgroundColor = UIColorFromRGB(LINE_COLOR);
        [_moneyField addSubview:lineLabel];
    }
    return _moneyField;
}
#pragma mark--银行卡信息

- (UITextField *)bankField
{
    if (!_bankField) {
        _bankField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, _moneyField.frame.origin.y+_moneyField.frame.size.height, SCREEN_WIDTH, 40.0f)];
        _bankField.backgroundColor = [UIColor whiteColor];
        _bankField.leftView = [self leftViewLabelWithText:@"银   行"];
        _bankField.leftViewMode = UITextFieldViewModeAlways;
        _bankField.placeholder = @"请选择银行";
        _bankField.font = FONT(14.0f);
        _bankField.delegate = self;
        [_bankField addTarget:self action:@selector(textFieldChangeMethod:) forControlEvents:UIControlEventEditingChanged];
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 28.5f, 40.0f)];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 13.0f, 8.5f, 14.0f)];
        arrowImageView.image = [UIImage imageNamed:@"kih.png"];
        [rightView addSubview:arrowImageView];
        _bankField.rightView = rightView;
        _bankField.rightViewMode = UITextFieldViewModeAlways;
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 39.5f, SCREEN_WIDTH-10.0f, 0.5f)];
        lineLabel.backgroundColor = UIColorFromRGB(LINE_COLOR);
        [_bankField addSubview:lineLabel];
    }
    return _bankField;
}
- (UITextField *)bankCardField
{
    if (!_bankCardField) {
        _bankCardField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, _bankField.frame.origin.y+_bankField.frame.size.height, SCREEN_WIDTH, 40.0f)];
        _bankCardField.backgroundColor = [UIColor whiteColor];
        _bankCardField.leftView = [self leftViewLabelWithText:@"卡   号"];
        _bankCardField.leftViewMode = UITextFieldViewModeAlways;
        _bankCardField.placeholder = @"请输入银行卡号";
        _bankCardField.text = @"6228480031572810914";
        _bankCardField.font = FONT(14.0f);
        [_bankCardField addTarget:self action:@selector(textFieldChangeMethod:) forControlEvents:UIControlEventEditingChanged];
        _bankCardField.keyboardType = UIKeyboardTypeNumberPad;
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 39.5f, SCREEN_WIDTH-10.0f, 0.5f)];
        lineLabel.backgroundColor = UIColorFromRGB(LINE_COLOR);
        [_bankCardField addSubview:lineLabel];
    }
    return _bankCardField;
}
#pragma mark--银行名左边的图片
- (UIImageView *)bankNameLeftImageView
{
    if (!_bankNameLeftImageView) {
        _bankNameLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 3.5f, 33.0f, 33.0f)];
        
    }
    return _bankNameLeftImageView;
}


#pragma mark--姓名输入框
- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, _bankCardField.frame.origin.y+_bankCardField.frame.size.height, SCREEN_WIDTH, 40.0f)];
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.leftView = [self leftViewLabelWithText:@"姓   名"];
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        _nameField.font = FONT(14.0f);
        _nameField.placeholder = @"持卡人真实姓名";
        _nameField.text = @"赵娟";
        [_nameField addTarget:self action:@selector(textFieldChangeMethod:) forControlEvents:UIControlEventEditingChanged];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 39.5f, SCREEN_WIDTH-10.0f, 0.5f)];
        lineLabel.backgroundColor = UIColorFromRGB(LINE_COLOR);
        [_nameField addSubview:lineLabel];
    }
    return _nameField;
}
#pragma mark--身份证输入框
- (UITextField *)idCardField
{
    if (!_idCardField) {
        _idCardField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, _nameField.frame.origin.y+_nameField.frame.size.height, SCREEN_WIDTH, 40.0f)];
        _idCardField.backgroundColor = [UIColor whiteColor];
        _idCardField.leftView = [self leftViewLabelWithText:@"身份证"];
        _idCardField.leftViewMode = UITextFieldViewModeAlways;
        _idCardField.placeholder = @"请输入身份证号码";
        _idCardField.text = @"342221199007250541";
        _idCardField.font = FONT(14.0f);
        [_idCardField addTarget:self action:@selector(textFieldChangeMethod:) forControlEvents:UIControlEventEditingChanged];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 39.5f, SCREEN_WIDTH-10.0f, 0.5f)];
        lineLabel.backgroundColor = UIColorFromRGB(LINE_COLOR);
        [_idCardField addSubview:lineLabel];
    }
    return _idCardField;
}
#pragma mark--号码输入框
- (UITextField *)telPhoneField
{
    if (!_telPhoneField) {
        _telPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, _idCardField.frame.origin.y+_idCardField.frame.size.height, SCREEN_WIDTH, 40.0f)];
        _telPhoneField.backgroundColor = [UIColor whiteColor];
        _telPhoneField.leftView = [self leftViewLabelWithText:@"手机号"];
        _telPhoneField.leftViewMode = UITextFieldViewModeAlways;
        _telPhoneField.placeholder = @"请输入银行绑定的手机号码";
        _telPhoneField.text = @"13386166769";
        _telPhoneField.delegate = self;
        [_telPhoneField addTarget:self action:@selector(textFieldChangeMethod:) forControlEvents:UIControlEventEditingChanged];
        _telPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        _telPhoneField.font = FONT(14.0f);
    }
    return _telPhoneField;
}
#pragma mark--输入框左边的视图
- (UIView *)leftViewLabelWithText:(NSString *)text
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 65.0f, 40.0f)];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 45.0f, 40.0f)];
    
    leftLabel.font = FONT(14.0f);
    leftLabel.textColor = UIColorFromRGB(BLACK_COLOR);
    leftLabel.text = text;
    [leftView addSubview:leftLabel];
    return leftView;
}
#pragma mark--确认充值按钮
- (UIButton *)comfireRechargeBtn
{
    if (!_comfireRechargeBtn) {
        _comfireRechargeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _comfireRechargeBtn.frame = CGRectMake(0.0f,_telPhoneField.frame.origin.y+_telPhoneField.frame.size.height+20.0f,SCREEN_WIDTH,40.0f);
        [_comfireRechargeBtn addTarget:self action:@selector(nextMethod)forControlEvents:UIControlEventTouchUpInside];
        [_comfireRechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfireRechargeBtn setTitle:@"确认充值" forState:UIControlStateNormal];
        _comfireRechargeBtn.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:131.0f/255.0f blue:40.0f/255.0f alpha:1];
        _comfireRechargeBtn.enabled = NO;
    }
     _comfireRechargeBtn.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:131.0f/255.0f blue:40.0f/255.0f alpha:1];
    return _comfireRechargeBtn;
}

- (IBAction)sumitButton:(id)sender{
}

#pragma mark--监控输入框的变化
- (void)textFieldChangeMethod:(UITextField *)textField
{
    [self judgeMethod];
}
- (void)judgeMethod
{
    if (self.moneyField.text.length>0&&self.bankField.text.length>0&&self.bankCardField.text.length>12&&self.nameField.text.length>0&&self.idCardField.text.length>12) {
        self.comfireRechargeBtn.backgroundColor = [UIColor colorWithRed:26.0f/255.0f green:165.0f/255.0f blue:249.0f/255.0f alpha:1.0];
        self.comfireRechargeBtn.enabled = YES;
    }else
    {
        self.comfireRechargeBtn.backgroundColor = [UIColor colorWithRed:26.0f/255.0f green:165.0f/255.0f blue:249.0f/255.0f alpha:0.5];
        self.comfireRechargeBtn.enabled = NO;
    }
}
#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.bankField) {
        [self.view endEditing:YES];
        [self requestBankListWithStyle:1];
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger charLen = toBeString.length;
    if (textField == self.telPhoneField) {
        if (charLen>11) {
            return NO;
        }
    }
    return YES;
}
#pragma mark--UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)requestBankListWithStyle:(int)style
{
    BankListViewController *listVC = [BankListViewController new];
    listVC.selectStyle = style;
    listVC.addBankVC = self;
    listVC.bankId = self.bankId;
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - SDK相关业务代码
- (void)nextMethod
{
    WEAKSELF
    [[BaoFuBufferView sharedManager] showBufferAddedTo:self.view animated:YES];
    //[BFProgressHUD showHUDAddedTo:self.view animated:YES];
    //NSURL*url = [NSURL URLWithString:@"http://tgw.baofoo.com/rsa/merchantPost.action"];
    NSURL*url = [NSURL URLWithString:@"http://10.0.20.243:8380/rsa/merchantPost.action?cg=2"];
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *para = [NSString stringWithFormat:@"txn_amt=%f&pay_code=%@&acc_no=%@&id_card=%@&id_holder=%@&mobile=%@&cg=%@",[self.moneyField.text floatValue]*100,self.bankCode,self.bankCardField.text,self.idCardField.text,[self.nameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.telPhoneField.text,self.textorture];
    //添加请求数据
    [request setTimeoutInterval:20];
    [request setHTTPBody:[para dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError) {
                NSLog(@"网络请求失败");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"商户订单号请求失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"retCode"] isEqualToString:@"0000"]) {
                /*
                 *传入tradeNo
                 *遵守代理函数
                 *设置支付环境
                 *调用预加载函数
                 */
                NSLog(@"dict = %@",dict);
                _payment = [[BaoFuenjoryCerPayment alloc] init];
                _payment.delegate = self;
                _payment.nastyle = [_nastyle integerValue];
                _payment.tradeNo = dict[@"tradeNo"];
            }
            else
            {
                [[BaoFuBufferView sharedManager] hideBufferForView:self.view animated:YES];
                NSString*str = [dict objectForKey:@"retMsg"];
                if (!str) {
                    str = @"创建订单号失败";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    }];
    
    
    
    
//    [BFProgressHUD showHUDAddedTo:self.view animated:YES];
//    _payment = [[BaoFuenjoryCerPayment alloc] init];
//    _payment.delegate = self;
//    _payment.nastyle = [_nastyle integerValue];
//    _payment.tradeNo = @"201612190110001213234936";
}



#pragma mark - BaofooDelegate

-(void)callBack:(NSString*)statusCode andMessage:(NSString *)message
{
    NSLog(@"返回的参数是：%@%@",statusCode,message);
    
    [[BaoFuBufferView sharedManager] hideBufferForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"支付结果:%@",message] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

//sdk初始化成功会回调预加载函数bfPreloadingcallBack
-(void)bfPreloadingcallBack{
    [[BaoFuBufferView sharedManager] hideBufferForView:self.view animated:YES];
    [self presentViewController:_payment animated:YES completion:^{
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 010) {
        switch (buttonIndex) {
            case 0:
            {
                self.textorture = @"2";
                self.title = @"测试环境";
            }
                break;
            case 1:{
                self.textorture = @"1";
                self.title = @"正式环境";
            }
                break;
                
            default:
                break;
        }
    }
    
    if (alertView.tag == 011) {
        switch (buttonIndex) {
            case 0:
            {
                _nastyle = @"0";
               [rightBarBtn setTitle:@"白色主题"];
            }
                break;
            case 1:{
                _nastyle = @"1";
                [rightBarBtn setTitle:@"橙色主题"];
            }
                break;
            case 2:
            {
                _nastyle = @"2";
                [rightBarBtn setTitle:@"房天下定制"];
            }
                break;
            default:
                break;
        }
    }
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
