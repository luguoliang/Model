//
//  Book.h
//  kvc-model-0
//
//  Created by 路国良 on 16/1/5.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Author;
@interface Book : NSObject
@property(nonatomic,copy)NSString*province;
@property(nonatomic,copy)NSString*region;
@property(nonatomic,copy)NSString*pid;
@property(nonatomic,strong)Author*author;
-(id)initWithDict:(NSDictionary*)dict;
+(id)provinceWithDict:(NSDictionary*)dict;
@end
