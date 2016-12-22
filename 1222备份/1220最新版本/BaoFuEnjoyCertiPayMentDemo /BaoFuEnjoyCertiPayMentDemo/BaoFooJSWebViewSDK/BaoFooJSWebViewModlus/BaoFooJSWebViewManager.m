//
//  BaoFooJSWebViewManager.m
//  BaoFooJSWebViewSDK
//
//  Created by zhoujun on 2016/11/29.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooJSWebViewManager.h"
#import "BaoFooURLProtocol.h"

#import "BFSDK_WebViewProgress.h"
#import "BFSDK_WebViewProgressView.h"

#import "BaoFooCommonHeader.h"
#import "BaoFooJSTool.h"
#import "BaoFooBlockAlert.h"
#import "BaoFooTitleModel.h"
#import "BaoFooBtnModel.h"
#import "BaoFooModel.h"

#import "UIButton+BaoFooWebCache.h"
#import "UIImageView+BaoFooWebCache.h"
#import "BaoFooToastView.h"

#import <objc/message.h>
#import "UploadDeviceInfoaAsync.h"

@interface BaoFooJSWebViewManager ()<UIWebViewDelegate,BFSDK_WebViewProgressDelegate>
// 组件
@property (nonatomic, strong) UIView * baofooWebview;
@property (nonatomic, strong) UIView * navbarView;
@property (nonatomic, strong) UIWebView * jsWebview;
// 进度条
@property (nonatomic, strong) BFSDK_WebViewProgress *webViewProgress;
@property (nonatomic, strong) BFSDK_WebViewProgressView *webViewProgressView;

@property (nonatomic, strong) UIView * titleBgview;
@property (nonatomic, strong) UIView * leftBtnBgview;
@property (nonatomic, strong) UIView * rightBtnBgview;
@property (nonatomic, strong) UIView * splitlineView;


// Navbar 定制化主题样式，当BaoFooNavbarDefaultStyleCustom被选择时，下面属性生效，若为空，则使用默认主题1
@property (nonatomic, strong) UIColor * navbarBackgroudColor; // 背景颜色
@property (nonatomic, strong) UIColor * navbarMainTitleColor;      // 导航栏主标题字体颜色
@property (nonatomic, strong) UIColor * navbarSubTitleColor;      // 导航栏副标题字体颜色
@property (nonatomic, strong) UIColor * navbarBtnTextColor;      // 导航栏按钮字体颜色
@property (nonatomic, strong) UIFont * navbarMainTitleFont;      // 导航栏主标题字体
@property (nonatomic, strong) UIFont * navbarSubTitleFont;      // 导航栏副标题字体
@property (nonatomic, strong) UIFont * navbarBtnTextFont;       // 导航栏按钮字体

@property (nonatomic, copy) NSString * navbarMainTitle;
@property (nonatomic, copy) NSString * navbarSubTitle;
@property (nonatomic, strong) UIImage * navbarImageTitle;

// 进度条颜色
@property (nonatomic, strong) UIColor * progressColor; // 默认为#7cc576

@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;
// 导航栏左右按钮的回调方法名
@property (nonatomic, copy) NSString * onLeft;
@property (nonatomic, copy) NSString * onRight;
@property (nonatomic, strong) NSMutableDictionary *reqIdDict;
// 参数
@property (nonatomic, assign) CGRect webviewFrame;

@property (nonatomic, strong) UILabel * singleTitleLable;
@property (nonatomic, strong) UILabel * mainTitleLable;
@property (nonatomic, strong) UILabel * subTitleLable;

// js交互逻辑参数
@property (nonatomic, copy) NSString *requestID;    //交互ID

// 用户收集动作确认
@property (nonatomic, assign) BOOL isUploadInfo;

@property (nonatomic, assign) BOOL isBtnSetting;

@end

@implementation BaoFooJSWebViewManager

#pragma mark 初始化方法
- (UIView *)createWebviewWithFrame:(CGRect)frame isNeedNavbar:(BOOL)isNeedNavbar {
    self.webviewFrame = frame;
    if (isNeedNavbar) {
        self.navbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 64)];
        self.jsWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height - 64)];
        self.titleBgview = [[UIView alloc] initWithFrame:CGRectMake(self.webviewFrame.size.width/4, 20, self.webviewFrame.size.width/2, 44)];
        self.leftBtnBgview = [[UIView alloc] initWithFrame:CGRectMake(15, 20, self.webviewFrame.size.width/4-15, 44)];
        self.rightBtnBgview = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleBgview.frame), 20, self.webviewFrame.size.width/4-15, 44)];
        self.splitlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, frame.size.width, 1)];
        [self.navbarView addSubview:self.titleBgview];
        [self.navbarView addSubview:self.leftBtnBgview];
        [self.navbarView addSubview:self.rightBtnBgview];
        [self.navbarView addSubview:self.splitlineView];
    }
    else {
        self.jsWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
    // 初始化参数
    _reqIdDict = [NSMutableDictionary dictionary];
    self.baofooWebview = [[UIView alloc] initWithFrame:frame];
    self.baofooWebview.backgroundColor = [UIColor whiteColor];
    [self.baofooWebview addSubview:self.navbarView];
    [self.baofooWebview addSubview:self.jsWebview];
    [self setupJswebview];
    [self setupProgress];
    return self.baofooWebview;
}

#pragma mark 设置jswebview
- (void)setupJswebview {
    self.jsWebview.backgroundColor = [UIColor clearColor];
    self.jsWebview.delegate = self;
    //注册protocol
    [NSURLProtocol registerClass:[BaoFooURLProtocol class]];
    if ([BaoFooJSTool isEmptyString:self.urlString]) {
        [self.jsWebview loadHTMLString:self.htmlString baseURL:nil];
    }
    else {
        NSURLRequest  *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        [self.jsWebview loadRequest:request];
    }
}

#pragma mark 设置进度条
- (void)setupProgress {
    self.webViewProgress = [[BFSDK_WebViewProgress alloc] init];
    self.jsWebview.delegate = self.webViewProgress;
    self.webViewProgress.webViewProxyDelegate = self;
    self.webViewProgress.progressDelegate = self;
    
    CGRect barFrame = CGRectMake(0,0,BaoFooScreenWidth,2);
    self.webViewProgressView = [[BFSDK_WebViewProgressView alloc] initWithFrame:barFrame];
    self.webViewProgressView.progressColor = _progressColor?_progressColor:[BaoFooJSTool BaoFoocolorWithHexString:@"#7cc576"];
    self.webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.webViewProgressView setProgress:0 animated:YES];
    [self.jsWebview addSubview:_webViewProgressView];
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([BaoFooJSTool isLocalRequest:request]) {
        NSString * urlString = [[request URL] absoluteString];
        NSString * urlScheme = [urlString substringFromIndex: @"mandaobridge://".length];
        NSArray *splitFuncInfo = [urlScheme componentsSeparatedByString:@"/"];
        self.requestID = [[splitFuncInfo lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (splitFuncInfo.count>=3) {
            NSString *action = [NSString stringWithFormat:@"%@_%@",splitFuncInfo[0],splitFuncInfo[1]];
            NSDictionary *params = [BaoFooJSTool getParams:self.requestID webView:webView];
            [self doAction:action params:params];
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('h1')[0].innerHTML";
    NSString *HTMLSource = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    if ([HTMLSource rangeOfString:@"404"].location != NSNotFound) {
        [self performSelector:@selector(webviewErrorHandler) withObject:nil afterDelay:1.0];
    }
    if (!_isBtnSetting) {
        [self.leftBtn removeFromSuperview];
        BaoFooBtnModel * closeBtnModel = [[BaoFooBtnModel alloc] init];
        closeBtnModel.title = @"关闭";
        [self.leftBtnBgview addSubview:[self setBarBtnItemWith:closeBtnModel Target:self action:@selector(closeBtnAction:)]];
    }
}
- (void)webviewErrorHandler {
    if ([_delegate respondsToSelector:@selector(errorFromJswebWith:)]) {
        [_delegate errorFromJswebWith:@{@"message":@"请求出现异常，请确认您的网络环境是否正常！",
                                         @"code":@"0"}];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (error.code  == -1009) {
        [self performSelector:@selector(webviewErrorHandler) withObject:nil afterDelay:1.0];
    }
    if (!_isBtnSetting) {
        [self.leftBtn removeFromSuperview];
        BaoFooBtnModel * closeBtnModel = [[BaoFooBtnModel alloc] init];
        closeBtnModel.title = @"关闭";
        [self.leftBtnBgview addSubview:[self setBarBtnItemWith:closeBtnModel Target:self action:@selector(closeBtnAction:)]];
    }
}
#pragma mark 进度条代理
-(void)webViewProgress:(BFSDK_WebViewProgress *)webViewProgress updateProgress:(float)progress {
    
    [self.webViewProgressView setProgress:progress animated:YES];
}

// 交互事件
- (void)doAction:(NSString *)action params:(NSDictionary *)params{
    
    unsigned int count;
    BOOL isHaveLocalMethod = NO;
    //获取方法列表
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Method method = methodList[i];
        if ([NSStringFromSelector(method_getName(method)) rangeOfString:action].location != NSNotFound) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@::",action]);
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL, NSString *, NSDictionary *) = (void *)imp;
            func(self, selector,self.requestID,params);
            isHaveLocalMethod = YES;
        }
    }
    if (!isHaveLocalMethod && self.extendMethodNamesArray.count) {
        for (NSString * str in self.extendMethodNamesArray) {
            if ([str isEqualToString:action]) {
                if ([_delegate respondsToSelector:@selector(extendMethodWithName:params:reqId:)]) {
                    [_delegate extendMethodWithName:action params:params reqId:self.requestID];
                }
            }
        }
    }
}

// 回调方法,obj一般为json字符串，或纯字符串,若失败，返回失败原因
- (void) callBackWithObj:(id)obj reqId:(NSString *)reqId status:(BOOL)isSuccess{
    [BaoFooJSTool callBackStringFrom:obj idStr:reqId isSuccess:isSuccess webView:_jsWebview];
}

// 具体方法实现
#pragma mark JS定义方法：UI_Alert
- (void)UI_Alert:(NSString *)reqId :(NSDictionary *)params {
    __weakself__
    [BaoFooBlockAlert showWithTitle:params[@"options"][@"title"] message:params[@"content"] cancelButtonTitle:params[@"options"][@"confirmBtn"][@"title"] otherButtonTitles:nil operation:^(NSInteger index) {
        [BaoFooJSTool callBackStringFrom:params[@"options"][@"confirmBtn"][@"action"] idStr:reqId isSuccess:YES webView:weakself.jsWebview];
    }];
}
#pragma mark JS定义方法：UI_Confirm
- (void)UI_Confirm:(NSString *)reqId :(NSDictionary *)params {
    [BaoFooJSTool comfirmAlert:params andReqID:reqId atWebView:_jsWebview];
}
#pragma mark JS定义方法：UI_Toast
- (void)UI_Toast:(NSString *)reqId :(NSDictionary *)params {
    if (![BaoFooJSTool isEmptyString:params[@"options"][@"duration"]]) {
        CFTimeInterval time = [params[@"options"][@"duration"] integerValue]/1000;
        [BaoFooToastView show:params[@"content"] delay:time];
    }
    else {
        [BaoFooToastView show:params[@"content"]];
    }
    
}
#pragma mark JS定义方法：UI_Init
- (void)UI_Init:(NSString *)reqId :(NSDictionary *)params {
    if ([_delegate respondsToSelector:@selector(webviewInitWith:reqId:)]) {
        [_delegate webviewInitWith:params reqId:reqId];
    }
}
#pragma mark JS定义方法：UI_Loading
- (void)UI_Loading:(NSString *)reqId :(NSDictionary *)params {
    if ([_delegate respondsToSelector:@selector(loadingProgress:reqId:)]) {
        [_delegate loadingProgress:params reqId:reqId];
    }
}
#pragma mark JS定义方法：Remote_Ajax
- (void)Remote_Ajax:(NSString *)reqId :(NSDictionary *)params {
    if ([_delegate respondsToSelector:@selector(remoteRequestWith:reqId:)]) {
        [_delegate remoteRequestWith:params reqId:reqId];
    }
}
#pragma mark JS定义方法：UI_LoadFinish
- (void)UI_LoadFinish:(NSString *)reqId :(NSDictionary *)params {
    if ([_delegate respondsToSelector:@selector(loadingFinish)]) {
        [_delegate loadingFinish];
    }
}
#pragma mark JS定义方法：UI_Exit
- (void)UI_Exit:(NSString *)reqId :(NSDictionary *)params {
    if ([_delegate respondsToSelector:@selector(exitCurrentWebview:)]) {
        if (!_isUploadInfo) {
            // 外层SDK未实现文该方法时，内部上传信息，orderId缺失
            [UploadDeviceInfoaAsync uploadDeviceInfoWith:@"" andAction:@"Close"];
        }
        [_delegate exitCurrentWebview:params];
    }
}
#pragma mark JS定义方法：UI_NavTitle
- (void)UI_NavTitle:(NSString *)reqId :(NSDictionary *)params {
    BOOL isLeftBtnSetting = NO;
    BOOL isRightBtnSetting = NO;
    BaoFooTitleModel * model = [BaoFooTitleModel bf_modelWithDictionary:params];
    if (model.background_color.length) {
        self.navbarView.backgroundColor = [BaoFooJSTool BaoFoocolorWithHexString:model.background_color];
    }
    if (model.splitline_color.length) {
        self.splitlineView.backgroundColor = [BaoFooJSTool BaoFoocolorWithHexString:model.splitline_color];
    }
    if (model.leftBtn) {
        if (![BaoFooJSTool isEmptyString:model.leftBtn.action]) {
            _onLeft = model.leftBtn.action;
        }
        [self.leftBtn removeFromSuperview];
        [self.leftBtnBgview addSubview:[self setBarBtnItemWith:model.leftBtn Target:self action:@selector(leftBtnAction:)]];
        isLeftBtnSetting = YES;
    }
    if (model.rightBtn) {
        if (![BaoFooJSTool isEmptyString:model.rightBtn.action]) {
            _onRight = model.rightBtn.action;
        }
        [self.rightBtn removeFromSuperview];
        [self.rightBtnBgview addSubview:[self setBarBtnItemWith:model.rightBtn Target:self action:@selector(rightBtnAction:)]];
        isRightBtnSetting = YES;
    }
    if (isLeftBtnSetting || isRightBtnSetting) {
        _isBtnSetting = YES;
    }
    else {
        _isBtnSetting = NO;
    }
    [self setNavTitleWith:model];
    [_reqIdDict setValue:self.requestID forKey:@"webViewTitle"];
}

- (void)setNavTitleWith:(BaoFooTitleModel *)model {
    if (![BaoFooJSTool isEmptyString:model.headMain.icon]) {
        if ([model.headMain.icon rangeOfString:@"http"].location != NSNotFound) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.titleBgview.frame.size.width, self.titleBgview.frame.size.height)];
            [imgView bf_setImageWithURL:[NSURL URLWithString:model.headMain.icon] completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, NSURL *imageURL) {
                imgView.frame = CGRectMake((self.titleBgview.frame.size.width - image.size.width/3)/2, (self.titleBgview.frame.size.height - image.size.height/3)/2, image.size.width/3, image.size.height/3);
            }];
            [self.titleBgview addSubview:imgView];

        }
    }
    else {
        if ([BaoFooJSTool isEmptyString:model.headSub.title]) {
            self.navbarMainTitle = model.headMain.title;
            if (model.headMain.style) {
                self.navbarMainTitleColor = [BaoFooJSTool isEmptyString:model.headMain.style[@"font_color"]]?[BaoFooJSTool BaoFoocolorWithHexString:NavbarMainTitleBlackColor]:[BaoFooJSTool BaoFoocolorWithHexString:model.headMain.style[@"font_color"]];
                self.navbarMainTitleFont = [BaoFooJSTool isEmptyString:model.headMain.style[@"font_size"]]?NavbarSingleMainTitleFont:[UIFont systemFontOfSize:[model.headMain.style[@"font_size"] integerValue]];
                [self setupSingleTitle];
            }
        }
        else {
            self.navbarMainTitle = model.headMain.title;
            if (model.headMain.style) {
                self.navbarMainTitleColor = [BaoFooJSTool isEmptyString:model.headMain.style[@"font_color"]]?[BaoFooJSTool BaoFoocolorWithHexString:NavbarMainTitleBlackColor]:[BaoFooJSTool BaoFoocolorWithHexString:model.headMain.style[@"font_color"]];
                self.navbarMainTitleFont = [BaoFooJSTool isEmptyString:model.headMain.style[@"font_size"]]?NavbarDoubleMainTitleFont:[UIFont systemFontOfSize:[model.headMain.style[@"font_size"] integerValue]];
            }
            self.navbarSubTitle = model.headSub.title;
            if (model.headSub.style) {
                self.navbarSubTitleColor = [BaoFooJSTool isEmptyString:model.headSub.style[@"font_color"]]?[BaoFooJSTool BaoFoocolorWithHexString:NavbarSubTitleGrayColor]:[BaoFooJSTool BaoFoocolorWithHexString:model.headSub.style[@"font_color"]];
                self.navbarSubTitleFont = [BaoFooJSTool isEmptyString:model.headSub.style[@"font_size"]]?NavbarSubTitleFont:[UIFont systemFontOfSize:[model.headSub.style[@"font_size"] integerValue]];
            }
            [self setupDoubleTitle];
        }
    }
}

- (void)setupSingleTitle {
    self.singleTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.webviewFrame.size.width/2, 44)];
    self.singleTitleLable.backgroundColor = [UIColor clearColor];
    self.singleTitleLable.font = self.navbarMainTitleFont;
    self.singleTitleLable.textColor = self.navbarMainTitleColor;
    self.singleTitleLable.text = self.navbarMainTitle;
    self.singleTitleLable.textAlignment = NSTextAlignmentCenter;
    [self.titleBgview addSubview:self.singleTitleLable];
}

- (void)setupDoubleTitle {
    self.mainTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, self.webviewFrame.size.width/2, 23)];
    self.subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainTitleLable.frame), self.webviewFrame.size.width/2, 15)];
    
    self.mainTitleLable.backgroundColor = [UIColor clearColor];
    self.mainTitleLable.font = self.navbarMainTitleFont;
    self.mainTitleLable.textColor = self.navbarMainTitleColor;
    self.mainTitleLable.text = self.navbarMainTitle;
    self.mainTitleLable.textAlignment = NSTextAlignmentCenter;
    
    self.subTitleLable.backgroundColor = [UIColor clearColor];
    self.subTitleLable.font = self.navbarSubTitleFont;
    self.subTitleLable.textColor = self.navbarSubTitleColor;
    self.subTitleLable.text = self.navbarSubTitle;
    self.subTitleLable.textAlignment = NSTextAlignmentCenter;
    
    [self.titleBgview addSubview:self.mainTitleLable];
    [self.titleBgview addSubview:self.subTitleLable];
}

- (void)leftBtnAction:(UIButton *)sender {
    [BaoFooJSTool callBackStringFrom:@{@"action":_onLeft?_onLeft:@""} idStr:[_reqIdDict objectForKey:@"webViewTitle"] isSuccess:YES webView:_jsWebview];
}

- (void)rightBtnAction:(UIButton *)sender {
    [BaoFooJSTool callBackStringFrom:@{@"action":_onRight?_onRight:@""} idStr:[_reqIdDict objectForKey:@"webViewTitle"] isSuccess:YES webView:_jsWebview];
}
- (void)closeBtnAction:(UIButton *)sender {
    [self UI_Exit:@"" :@{}];
}

- (UIButton *)setBarBtnItemWith:(BaoFooBtnModel *)model Target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.webviewFrame.size.width/4-15, 44);
    if (![BaoFooJSTool isEmptyString:model.icon]) {
        if ([model.icon rangeOfString:@"http"].location != NSNotFound) {
            
            [button bf_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, NSURL *imageURL) {
                if ([NSStringFromSelector(action) isEqualToString:@"rightBtnAction:"]) {
                    button.imageEdgeInsets = UIEdgeInsetsMake((44 - image.size.height/3)/2, button.frame.size.width - image.size.width/3, (44 - image.size.height/3)/2, 0);
                }
                else {
                    button.imageEdgeInsets = UIEdgeInsetsMake((44 - image.size.height/3)/2, 0, (44 - image.size.height/3)/2, button.frame.size.width - image.size.width/3);
                }
                
            }];
            /*
            首先得拿到照片的路径，也就是下边的string参数，转换为NSData型。
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]];
            
            然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
            [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
             */
        }
    }
    else {
        
        if (![BaoFooJSTool isEmptyString:model.title]) {
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:model.title forState:UIControlStateNormal];
            [button setTitle:model.title forState:UIControlStateHighlighted];
            [button setTitleColor:[BaoFooJSTool isEmptyString:model.style[@"font_color"]]?[BaoFooJSTool BaoFoocolorWithHexString:NavbarBtnTitleBlackColor]:[BaoFooJSTool BaoFoocolorWithHexString:model.style[@"font_color"]] forState:UIControlStateNormal];
            [button setTitleColor:[BaoFooJSTool isEmptyString:model.style[@"font_color"]]?[BaoFooJSTool BaoFoocolorWithHexString:NavbarBtnTitleBlackColor]:[BaoFooJSTool BaoFoocolorWithHexString:model.style[@"font_color"]] forState:UIControlStateHighlighted];
            [button.titleLabel setFont:[BaoFooJSTool isEmptyString:model.style[@"font_size"]]?NavbarBtnTitleFont:[UIFont systemFontOfSize:[model.style[@"font_size"] integerValue]]];
        }
    }
    if ([NSStringFromSelector(action) isEqualToString:@"rightBtnAction:"]) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    else {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark JS定义方法：UI_JumpTo
- (void)UI_JumpTo:(NSString *)reqId :(NSDictionary *)params {
    if ([params[@"target"] isEqualToString:@"_new"]) {
        if ([_delegate respondsToSelector:@selector(openNewWebview:)]) {
            [_delegate openNewWebview:params[@"view"]];
        }
    }
    else if ([params[@"target"] isEqualToString:@"_browser"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:params[@"view"]]];
    }
}

#pragma mark JS定义方法：Storage_SaveData
- (void)Storage_SaveData:(NSString *)reqId :(NSDictionary *)params {
    [BaoFooJSTool saveData:params];
}
#pragma mark JS定义方法：Storage_ReadData
- (void)Storage_ReadData:(NSString *)reqId :(NSDictionary *)params {
    [BaoFooJSTool readDate:params andReqID:reqId atWebView:_jsWebview];
}
#pragma mark JS定义方法：Codec_Encode
- (void)Codec_Encode:(NSString *)reqId :(NSDictionary *)params {
    if ([params[@"type"] isEqualToString:@"base64"]) {
        [BaoFooJSTool actionBase64Encode:params[@"data"] reqID:reqId webView:_jsWebview];
    }
}
#pragma mark JS定义方法：Codec_Decode
- (void)Codec_Decode:(NSString *)reqId :(NSDictionary *)params {
    if ([params[@"type"] isEqualToString:@"base64"]) {
        [BaoFooJSTool actionBase64Decode:params[@"data"] reqID:reqId webView:_jsWebview];
    }
}
#pragma mark JS定义方法：Device_CellCall
- (void)Device_CellCall:(NSString *)reqId :(NSDictionary *)params {
    [BaoFooJSTool actionCall:params];
}
#pragma mark JS定义方法：Device_Env
- (void)Device_Env:(NSString *)reqId :(NSDictionary *)params {
    [BaoFooJSTool systemInfoWithReqID:reqId atWebView:_jsWebview];
}


// 收集设备信息接口
- (void)uploadDeviceInfoWithOrderId:(NSString *)orderId andAction:(NSString *)action {
    _isUploadInfo = YES;
    [UploadDeviceInfoaAsync uploadDeviceInfoWith:orderId andAction:action];
}

@end
