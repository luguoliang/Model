//
//  Book.m
//  kvc-model-1
//
//  Created by 路国良 on 16/1/5.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "Book.h"
#import "Author.h"
@interface Book(){
    Author*_author;
}
@end

@implementation Book
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"author"]) {
        if (!_author) {
            _author = [[Author alloc] init];
            [_author setValuesForKeysWithDictionary:value];
        }
        else{
            [_author setValuesForKeysWithDictionary:value];
        }
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
