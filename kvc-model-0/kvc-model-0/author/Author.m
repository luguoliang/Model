//
//  Author.m
//  kvc-model-0
//
//  Created by 路国良 on 16/1/5.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "Author.h"

@implementation Author
-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = dict[@"name"];
    }
    return self;
}
+(id)authWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end
