//
//  BaofooHttpsRequest.h
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/13.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaofooHttpsRequest : NSObject
/**
 *  post字典数据方法
 *
 *  @param urlString url字符串
 *  @param dict post请求需要传递的参数
 *  @param Sucessful 请求成功回调
 *  @param failure 请求失败回调
 *
 */
+(void)posttoUrlStr:(NSString *)urlString WithPostOrgetData:(NSDictionary *)dict Sucessful:(void (^)(NSDictionary *))Sucessful failure:(void (^)(NSString *))failure;

/**
 *  post字符串数据方法
 *
 *  @param urlString url字符串
 *  @param parameter post请求需要传递的参数
 *  @param Sucessful 请求成功回调
 *  @param failure 请求失败回调
 *
 */
+(void)posttoUrlStr:(NSString*)urlString WithparameterString:(NSString*)parameter Sucessful:(void (^)(NSDictionary *))Sucessful failure:(void (^)(NSString *))failure;

//+(void)bfposttoUrlStr:(NSString *)urlString WithPostOrgetData:(NSDictionary *)dict Sucessful:(void (^)(NSData *))Sucessful failure:(void (^)(NSString *))failure;
@end
