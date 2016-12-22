//
//  BaoFuenjoryCertiParment.m
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/7.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFuenjoryCerPayment.h"
#import "BaoFooJSWebViewManager.h"
#import "BaoFuBufferView.h"
#import "BaofooHttpsRequest.h"
#define urlkey      @"BaoFoo_NEW_URLSTRING"
//#define defaultUrl_test                 @"http://10.0.20.72:26000/rzsdkh5/index.html"

/*
 *
 *defaultUrl--开发环境 参数
 *
 *defaultUrl_test                 测试环境
 *defaultUrl_associateProduction  准生产环境
 *defaultUrl_true                 生产环境
 */
//#define defaultUrl_test                 @"http://10.0.20.72:26000/rzsdkh5/index.html"
//#define defaultUrl_associateProduction  @"http://10.0.203.131:8080/index.html"
#define defaultUrl_associateProduction  @"http://10.0.203.131:8080/index.html"
#define defaultUrl_true                 @"http://10.0.20.72:26000/rzsdkh5/index.html"
#define defaultUrl_test                 @"http://10.0.20.72:26000/index.html"

/*
 *
 *style--样式参数
 *
 *style_orange  橙色样式
 *style_white   白色样式
 *style_fang    房天下定制样式
*/
#define style_orange                    @"orange"
#define style_white                     @"white"
#define style_fang                      @"rzsdk-ftx"

@interface BaoFuenjoryCerPayment ()<BaoFooJSWebViewManagerDelegate>
{
    BaoFooJSWebViewManager*_manager;
    UIView*_baofuWebView;
}
@end

@implementation BaoFuenjoryCerPayment

#pragma mark - SDK's Private methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadBaseUrlString];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    }

-(void)returnPaymentResult:(NSString*)result{
    NSArray *resultArr = [result componentsSeparatedByString:@","];
    NSString *message = @"";
    if (resultArr.count > 2) {
        message = resultArr[1];
        for (int i = 2; i < resultArr.count; i ++) {
            message = [message stringByAppendingFormat:@",%@",resultArr[i]];
        }
    }
    else{
        message = [resultArr lastObject];
    }
    [_delegate callBack:[resultArr firstObject] andMessage:message];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)loadBaseUrlString{
    _manager = [[BaoFooJSWebViewManager alloc] init];
    _manager.delegate = self;
    NSString*urlString = [[NSUserDefaults standardUserDefaults] valueForKey:urlkey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:urlkey];
    if (!urlString.length) {
        switch (_operState) {
            case operational_test:
            {
                _manager.urlString = defaultUrl_test;
            }
                break;
            case operational_associateProduction:
            {
                _manager.urlString = defaultUrl_associateProduction;
            }
                break;
            case operational_true:
            {
                _manager.urlString = defaultUrl_true;
            }
                break;
                
            default:
            {
                [self returnPaymentResult:@"-1,8888:请传入正确的操作环境"];
            }
                break;
        }
    }
    else{
        _manager.urlString = urlString;
    }
    _baofuWebView = [_manager createWebviewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) isNeedNavbar:YES];
    [self.view addSubview:_baofuWebView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self jsCallShowBufferView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self jsCallHideBufferView];
}

#pragma mark Public class（bufferViewMethed）
-(void)jsCallShowBufferView{
    [[BaoFuBufferView sharedManager] showBufferAddedTo:self.view animated:YES];
}
-(void)jsCallHideBufferView{
    [[BaoFuBufferView sharedManager] hideBufferForView:self.view animated:YES];
}

#pragma mark - BaoFooJSWebViewManagerDelegate
// 拿到方法名去请求相应的方法，reqId，用于回调，若无回调则无用
- (void)extendMethodWithName:(NSString *)name params:(NSDictionary *)params reqId:(NSString *)reqId{
    NSLog(@"%s" ,__func__);
}

- (void)webviewInitWith:(NSDictionary *)params reqId:(NSString *)reqId{
    NSLog(@"%s" ,__func__);
    NSString*style = nil;
    switch (_nastyle) {
        case 0:
        {
            style = style_white;
        }
            break;
        case 1:{
            style = style_orange;
        }
            break;
            case 2:
        {
            style = style_fang;
        }
            break;
            
        default:
            break;
    }
    [_manager callBackWithObj:@{@"transId":_tradeNo,@"theme":style,@"skipResult":@"true"} reqId:reqId status:YES];
    [_manager uploadDeviceInfoWithOrderId:_tradeNo andAction:@"Open"];
}

- (void)loadingProgress:(NSDictionary *)params reqId:(NSString *)reqId{
    NSLog(@"%s" ,__func__);
    if ([params[@"sw"] isEqualToString:@"on"]) {
        [self jsCallShowBufferView];
    }
    else if ([params[@"sw"] isEqualToString:@"off"]) {
        [self jsCallHideBufferView];
    }
}

- (void)remoteRequestWith:(NSDictionary *)params reqId:(NSString *)reqId{
    [BaofooHttpsRequest posttoUrlStr:params[@"url"] WithPostOrgetData:params[@"params"] Sucessful:^(NSDictionary *dict) {
        NSLog(@"dict = %@",dict);
        NSError *parseError = nil;
        NSData*jsdata = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString*jsTr =[[NSString alloc] initWithData:[jsdata base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
        [_manager callBackWithObj:jsTr reqId:reqId status:YES];
    } failure:^(NSString *error) {
        [_manager callBackWithObj:error reqId:reqId status:NO];
    }];
}

- (void)openNewWebview:(NSString *)url{
    NSLog(@"%s" ,__func__);
    BaoFuenjoryCerPayment*new = [[BaoFuenjoryCerPayment alloc] init];
    [[BaoFuBufferView sharedManager] showBufferAddedTo:new.view animated:YES];
    
//    [BaofooHttpsRequest posttoUrlStr:@"http://www.baidu.com" WithPostOrgetData:@{} Sucessful:^(NSDictionary *dict) {
//        NSLog(@"dict = %@",dict);
//    } failure:^(NSString *error) {
//        NSLog(@"%@", error);
//    }];
//    
    [self presentViewController:new animated:YES completion:^{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:urlkey];
    }];
}
//加载成功后回调，弹出sdk
- (void)loadingFinish{
    [_delegate bfPreloadingcallBack];
    NSLog(@"%s" ,__func__);
}

//关闭弹框确定按钮调用方法
- (void)exitCurrentWebview:(NSDictionary *)params{
    [_manager uploadDeviceInfoWithOrderId:_tradeNo andAction:@"Close"];
    [self dismissViewControllerAnimated:YES completion:^{
        if (([params allKeys].count)) {
         [_delegate callBack:params[@"code"] andMessage:params[@"message"]];
        }
    }];
}

#pragma mark - H5's Private methods
- (void) callBackWith:(id)obj :(NSString *)reqId :(BOOL)isSuccess{
    NSLog(@"%s" ,__func__);
}

- (void)errorFromJswebWith:(NSDictionary *)params {
    if ([params[@"status"] integerValue] == 0) {
        if ([params[@"errorCode"] integerValue] == 404) {
            if ([_delegate respondsToSelector:@selector(callBack:andMessage:)]) {
                [_delegate callBack:@"0" andMessage:params[@"msg"]];
            }
        }
    }
    else{
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
