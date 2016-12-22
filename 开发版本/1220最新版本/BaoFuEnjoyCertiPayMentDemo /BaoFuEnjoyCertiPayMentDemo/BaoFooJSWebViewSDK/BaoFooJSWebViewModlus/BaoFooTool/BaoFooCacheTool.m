//
//  BaoFooCacheTool.m
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by zhoujun on 2016/12/16.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooCacheTool.h"

@implementation BaoFooCacheTool
+ (NSString *)getDocumentFolderPath {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [array firstObject];
}

+ (NSString *)getDocumentFilePathWithName:(NSString *)filename {
    NSString *folderPath = [[self class] getDocumentFolderPath];
    if (![[self class] directoryExistsAtPath:[folderPath stringByAppendingPathComponent:filename]]) {
        [[self class] createDirectoryAtPath:[folderPath stringByAppendingPathComponent:filename]];
    }
    return [folderPath stringByAppendingPathComponent:filename];
}
+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)directoryExistsAtPath:(NSString *)path {
    
    BOOL isDir;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (exist && isDir) {
        return YES;
    }
    return NO;
}
+ (BOOL)removeFileAtPath:(NSString *)path {
    if ([[self class] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return YES;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path {
    
    if (![[self class] directoryExistsAtPath:path]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}
@end
