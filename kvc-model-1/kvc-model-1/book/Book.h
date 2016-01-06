//
//  Book.h
//  kvc-model-1
//
//  Created by 路国良 on 16/1/5.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Author;
@interface Book : NSObject
@property(nonatomic,strong)NSString*bookName;
@property(nonatomic,strong)NSString*pubHouse;
@property(nonatomic)NSInteger price;
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)Author*author;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
