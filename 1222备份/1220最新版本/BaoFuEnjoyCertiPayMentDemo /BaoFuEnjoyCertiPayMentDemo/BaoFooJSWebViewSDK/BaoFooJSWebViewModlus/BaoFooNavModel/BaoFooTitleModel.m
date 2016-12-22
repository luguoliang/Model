//
//  BaoFooTitleModel.m
//  BaoFooJSDemo
//
//  Created by zhoujun on 2016/11/25.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooTitleModel.h"
#import "BaoFooBtnModel.h"

@implementation BaoFooTitleModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"headMain" : [BaoFooBtnModel class],
             @"headSub" : [BaoFooBtnModel class],
             @"leftBtn" : [BaoFooBtnModel class],
             @"rightBtn" : [BaoFooBtnModel class]};
}

@end
