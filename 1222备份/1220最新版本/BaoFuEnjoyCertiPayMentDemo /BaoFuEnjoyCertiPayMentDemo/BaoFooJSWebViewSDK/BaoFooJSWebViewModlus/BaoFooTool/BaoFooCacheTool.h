//
//  BaoFooCacheTool.h
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by zhoujun on 2016/12/16.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoFooCacheTool : NSObject

+ (NSString *)getDocumentFolderPath;
+ (NSString *)getDocumentFilePathWithName:(NSString *)filename;

+ (BOOL)fileExistsAtPath:(NSString *)path;
+ (BOOL)directoryExistsAtPath:(NSString *)path;

+ (BOOL)removeFileAtPath:(NSString *)path;
+ (BOOL)createDirectoryAtPath:(NSString *)path;
@end
