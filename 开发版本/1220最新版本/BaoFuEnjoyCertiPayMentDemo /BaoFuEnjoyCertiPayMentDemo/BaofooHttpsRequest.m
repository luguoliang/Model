//
//  BaofooHttpsRequest.m
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/13.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaofooHttpsRequest.h"

@implementation BaofooHttpsRequest
+(void)posttoUrlStr:(NSString *)urlString WithPostOrgetData:(NSDictionary *)dict Sucessful:(void (^)(NSDictionary *))Sucessful failure:(void (^)(NSString *))failure{
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[self serializeToUrlByDicString:dict] dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue*queue =[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"网络请求失败");
            failure(@"当前网络不可用，\n请检查您的网络设置");
            return ;
        }
        else
        {
            NSError*resolve;
            NSDictionary*RequestDataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&resolve];
            if (resolve) {
                NSLog(@"解析失败");
                failure(@"解析失败");
            }
            else
            {
                if (RequestDataDict) {
                        if ([RequestDataDict[@"retCode"] isEqualToString:@"0000"]) {
                        NSLog(@"网络请求成功");
                            Sucessful(RequestDataDict);
                    }
                    else
                    {
                        NSLog(@"请求失败");
                        failure([NSString stringWithFormat:@"%@",RequestDataDict[@"retMsg"]]);
                    }
                }
                else
                {
                    NSLog(@"服务器正在维护");
                    failure(@"服务器正在维护");
                }
            }
        }
    }];
}

+ (NSString *)serializeToUrlByDicString:(NSDictionary *)dic
{
    NSString *result = @"";
    if (dic == nil || dic.count == 0)
    {
        return result;
    }
    for (id key in dic)
    {
        result = [NSString stringWithFormat:@"%@%@%@%@%@",result,key,@"=",dic[key],@"&"];
    }
    if (result.length > 0)
    {
        result = [result substringToIndex:result.length - 1];
    }
    return result;
}

+(void)posttoUrlStr:(NSString*)urlString WithparameterString:(NSString*)parameter Sucessful:(void (^)(NSDictionary *))Sucessful failure:(void (^)(NSString *))failure{
    NSURL*url = [NSURL URLWithString:urlString];
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString*para = parameter;
    //添加请求数据
    [request setHTTPBody:[para dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([[dict objectForKey:@"retCode"] isEqualToString:@"0000"]) {
                Sucessful(dict);
            }
            else
            {
                failure(dict[@"retMsg"]);
            }
        });
    }];

}

@end
