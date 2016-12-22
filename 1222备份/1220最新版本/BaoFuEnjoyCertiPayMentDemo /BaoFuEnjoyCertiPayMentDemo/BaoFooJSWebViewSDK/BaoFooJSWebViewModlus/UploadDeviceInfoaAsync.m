//
//  UploadDeviceInfoaAsync.m
//  JSWebViewDemo
//
//  Created by zhoujun on 2016/12/19.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "UploadDeviceInfoaAsync.h"
#import "BaoFooJSTool.h"
#import "BaoFooCommonHeader.h"



typedef void(^_Nullable BFSuccessBlock)(id _Nullable responseObj, NSURLResponse * _Nullable response);
typedef void(^_Nullable BFFailureBlock)(NSURLResponse * _Nullable response, NSError * _Nullable error);


@implementation UploadDeviceInfoaAsync


+ (void)uploadDeviceInfoWith:(NSString *)orderId andAction:(NSString *)action {
    NSString * netStatus;
    if (![[BaoFooJSTool getNetWorkStates] isEqualToString:@"无网络"]) {
        if ([[BaoFooJSTool getNetWorkStates] isEqualToString:@"WIFI"]) {
            netStatus = @"WIFI";
        }
        else {
            netStatus = @"FLOW";
        }
        // sdk|model|platform|version|uuid|orderid|network|action|appname|appversion
        NSString * sign = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@",WebView_Version,[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion],[[[UIDevice currentDevice] identifierForVendor] UUIDString],netStatus,action,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        NSString * business = [NSString stringWithFormat:@"%@|%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString],orderId];
        [[self class] BFGET:[BaoFooJSTool baofooEncrypt:sign] andBusiness:[BaoFooJSTool baofooEncrypt:business] parameters:@"" success:^(id  _Nullable responseObj, NSURLResponse * _Nullable response) {
            NSLog(@"UploadDeviceInfoaAsync--%@",responseObj);
        } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"UploadDeviceInfoaAsync--%@",error);
        }];
    }
}

+ (void)BFGET:(NSString * _Nullable)sign andBusiness:(NSString *)business parameters:(nullable id)parameters success:(BFSuccessBlock)success failure:(BFFailureBlock)failure
{
    sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    business = [business stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sign=%@&business=%@",BaoFoo_UploadDeviceInfoBaseURL,sign,business]];
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    NSString *str = parameters;
    request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            return success(dict,response);
        }
        else {
            return failure(response, error);
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}
@end
