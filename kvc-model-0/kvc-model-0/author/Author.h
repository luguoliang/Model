//
//  Author.h
//  kvc-model-0
//
//  Created by 路国良 on 16/1/5.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Author : NSObject
@property(nonatomic,copy)NSString*name;
-(id)initWithDict:(NSDictionary*)dict;
+(id)authWithDict:(NSDictionary*)dict;
@end
