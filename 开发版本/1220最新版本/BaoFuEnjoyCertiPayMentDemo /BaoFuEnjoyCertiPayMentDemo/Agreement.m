//
//  Agreement.m
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/22.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "Agreement.h"
#import "BaoFooJSWebViewManager.h"
#import "BaoFuBufferView.h"
#import "BaofooHttpsRequest.h"
@interface Agreement ()<BaoFooJSWebViewManagerDelegate>
{
    BaoFooJSWebViewManager*_manager;
    UIView*_baofuWebView;
  

}

@end

@implementation Agreement
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadBaseUrlString];
    }
    return self;
}

-(void)loadBaseUrlString{
    _manager = [[BaoFooJSWebViewManager alloc] init];
    _manager.delegate = self;
    
    _manager.urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"BaoFoo_NEW_URLSTRING"];;

    _baofuWebView = [_manager createWebviewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) isNeedNavbar:YES];
    [self.view addSubview:_baofuWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
       [_manager callBackWithObj:@{@"transId":@"",@"theme":style,@"skipResult":@"true"} reqId:reqId status:YES];
    [_manager uploadDeviceInfoWithOrderId:@"" andAction:@"Open"];
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
   
}
//加载成功后回调，弹出sdk
- (void)loadingFinish:(NSDictionary *)params reqId:(NSString *)reqId{
    [_delegate bfPreloadingcallBackaaa];
   }

//关闭弹框确定按钮调用方法
- (void)exitCurrentWebview:(NSDictionary *)params{
   
}

#pragma mark - H5's Private methods
- (void) callBackWith:(id)obj :(NSString *)reqId :(BOOL)isSuccess{
    NSLog(@"%s" ,__func__);
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
