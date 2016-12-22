//
//  RequestManager.h
//  makr
//
//  Created by mac on 15/4/23.
//  Copyright (c) 2015年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject

+(void)requestWithUrl:(NSString *)url completion:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;
@end
