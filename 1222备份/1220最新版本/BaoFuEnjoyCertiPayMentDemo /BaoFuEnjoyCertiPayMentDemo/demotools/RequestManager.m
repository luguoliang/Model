//
//  RequestManager.m
//  makr
//
//  Created by mac on 15/4/23.
//  Copyright (c) 2015年 baofoo. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager


+(void)requestWithUrl:(NSString *)url completion:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    dispatch_queue_t aqueue = dispatch_queue_create("com.getData", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(aqueue, ^{
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
    });
    

}

@end
