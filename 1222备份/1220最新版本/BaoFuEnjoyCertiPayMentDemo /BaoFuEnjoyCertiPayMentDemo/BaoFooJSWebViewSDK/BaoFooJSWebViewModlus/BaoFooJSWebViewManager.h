//
//  BaoFooJSWebViewManager.h
//  BaoFooJSWebViewSDK
//
//  Created by zhoujun on 2016/11/29.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaoFooJSWebViewManagerDelegate <NSObject>
// 拿到方法名去请求相应的方法，reqId，用于回调，若无回调则无用
- (void)extendMethodWithName:(NSString *)name params:(NSDictionary *)params reqId:(NSString *)reqId;
// 页面初始化
- (void)webviewInitWith:(NSDictionary *)params reqId:(NSString *)reqId;
// 加载菊花
- (void)loadingProgress:(NSDictionary *)params reqId:(NSString *)reqId;
// 远程网络请求
- (void)remoteRequestWith:(NSDictionary *)params reqId:(NSString *)reqId;
// 打开新的webview
- (void)openNewWebview:(NSString *)url;
// 加载完成通知
- (void)loadingFinish;
// 关闭当前页面
- (void)exitCurrentWebview:(NSDictionary *)params;
// 错误回调
- (void)errorFromJswebWith:(NSDictionary *)params;
@end

@interface BaoFooJSWebViewManager : NSObject

// 初始化方法: 实例化manager,添加属性后，初始化webview
- (UIView *)createWebviewWithFrame:(CGRect)frame isNeedNavbar:(BOOL)isNeedNavbar;

// 回调方法,obj一般为json字符串，或纯字符串,若失败，返回失败原因
- (void) callBackWithObj:(id)obj reqId:(NSString *)reqId status:(BOOL)isSuccess;

// 收集设备信息接口
- (void)uploadDeviceInfoWithOrderId:(NSString *)orderId andAction:(NSString *)action; // action: Open | Close

@property (nonatomic, weak) id<BaoFooJSWebViewManagerDelegate> delegate;

// 二者选一，优先为urlString
@property (nonatomic, copy) NSString * urlString;   // URL string
@property (nonatomic, copy) NSString * htmlString;  // HTML string

// 注册拓展方法名数组, SDK中未实现的JS交互方法，可在外部实现，并将方法名以字符串形式放于数组中，SDK找不到的方法会在数组中寻找
@property (nonatomic, strong) NSMutableArray * extendMethodNamesArray;



@end
