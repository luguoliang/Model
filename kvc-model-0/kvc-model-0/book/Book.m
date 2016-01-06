//
//  Book.m
//  kvc-model-0
//
//  Created by 路国良 on 16/1/5.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "Book.h"
#include "Author.h"
@implementation Book
-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.province = dict[@"province"];
        self.region = dict[@"region"];
        self.pid = dict[@"pid"];
        self.author = [[Author alloc] initWithDict:dict[@"author"]];
    }
    return self;
}
+(id)provinceWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
