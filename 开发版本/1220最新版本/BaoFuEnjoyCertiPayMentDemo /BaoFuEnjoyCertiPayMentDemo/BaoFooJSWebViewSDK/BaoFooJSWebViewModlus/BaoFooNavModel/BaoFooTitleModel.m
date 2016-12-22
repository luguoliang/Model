//
//  BaoFooTitleModel.m
//  BaoFooJSDemo
//
//  Created by zhoujun on 2016/11/25.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooTitleModel.h"
#import "BaoFooBtnModel.h"

@interface BaoFooTitleModel () {
    BaoFooBtnModel *btnModel;
}

@end

@implementation BaoFooTitleModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"headMain"] || [key isEqualToString:@"headSub"] || [key isEqualToString:@"leftBtn"] || [key isEqualToString:@"rightBtn"]) {
        btnModel = [[BaoFooBtnModel alloc] init];
        [btnModel setValuesForKeysWithDictionary:value];
        [super setValue:btnModel forKey:key];
    }
    else{
        [super setValue:value forKey:key];
    }
    
    if ([key isEqualToString:@"id"]) {
        key = @"id";
        [super setValue:value forKey:key];
    }
}

@end
