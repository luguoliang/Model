//
//  BaoFooJSTool.h
//  BaoFooSDK
//
//  Created by zhoujun on 16/10/17.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface BaoFooJSTool : NSObject
/***********************************   JS交互获取参数的方法   ***************************************/
+ (BOOL)isLocalRequest:(NSURLRequest *)request;
+ (BOOL)isCacheRequest:(NSURLRequest *)request;
+ (NSDictionary *)getParams:(NSString *)idStr webView:(UIWebView *)webView;
+ (NSString *)callBackStringFrom:(id)obj idStr:(NSString *)idStr isSuccess:(BOOL)isSuccess webView:(UIWebView *)webView;
+ (NSString *)doJavaScriptString:(NSString *)script webView:(UIWebView *)webView;

/***********************************   JS交互原生方法   ***************************************/
+ (void)actionAlert:(NSDictionary *)params andReqID:(NSString *)reqID atWebView:(UIWebView *)webView;

+ (void)comfirmAlert:(NSDictionary *)params andReqID:(NSString *)reqID atWebView:(UIWebView *)webView;

+ (void)saveData:(NSDictionary *)params;

+ (void)readDate:(NSDictionary *)params andReqID:(NSString *)reqID atWebView:(UIWebView *)webView;

//TODO:调用系统打电话
+ (void)actionCall:(NSDictionary *)params;
+ (NSString *)phoneNumberFormat:(NSString *)phone;
//TODO:base64解码
+ (void)actionBase64Decode:(NSString *)params reqID:(NSString *)reqID webView:(UIWebView *)webView;
//TODO:base64加密
+ (void)actionBase64Encode:(NSString *)params reqID:(NSString *)reqID webView:(UIWebView *)webView;
//TODO:返回系统设备信息
+ (void)systemInfoWithReqID:(NSString *)reqID atWebView:(UIWebView *)webview;

/**************************************** 其它方法 *****************************************/
//判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string;
//根据十六进制生成颜色
+ (UIColor *)BaoFoocolorWithHexString:(NSString *)str;
+ (NSString *)BaoFooMd5:(NSString *)key;
// 获取网络状态
+ (NSString *)getNetWorkStates;
//加密
+ (NSString *)base64EncodeStr:(NSString *)str;
//解密
+ (NSString *)base64DecodeStr:(NSString *)str;
//3DES加密
+ (NSString *)desEncryptStr:(NSString *)originalStr;
//3DES解密
+ (NSString*)desDecEncryptStr:(NSString *)str;
//baofoo加密
+ (NSString *)baofooEncrypt:(NSString *)str;

/***********************************   Json 处理方法   ***************************************/
+ (id)getObjectFromJSONString:(NSString *)jsonStr;
+ (id)getObjectFromJSONString:(NSString *)jsonStr WithOption:(NSJSONReadingOptions)option;
+ (id)getObjectFromJSONData:(NSData *)jsonData;
+ (NSString *)getJSONStringFromObject:(id)obj;
+ (NSData *)getJSONDataFromObject:(id)obj;
@end
