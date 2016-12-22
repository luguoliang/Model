//
//  BaoFooJSTool.m
//  BaoFooSDK
//
//  Created by zhoujun on 16/10/17.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooJSTool.h"
#import "BaoFooCommonHeader.h"
#import "BaoFooBlockAlert.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@interface BaoFooJSTool ()
{
    
}
@end

@implementation BaoFooJSTool

+ (BOOL)isLocalRequest:(NSURLRequest *)request {
    
    if ([[[request URL] scheme] isEqualToString:@"mandaobridge"]) {
        
        return YES;
    }
    return NO;
}

+ (BOOL)isCacheRequest:(NSURLRequest *)request {
    if ([[[request URL] scheme] isEqualToString:@"http"] || [[[request URL] scheme] isEqualToString:@"https"]) {
        return YES;
    }
    return NO;
}


+ (NSDictionary *)getParams:(NSString *)idStr webView:(UIWebView *)webView{
    NSString *params = [[self class] doJavaScriptString:[NSString stringWithFormat:@"mandaobridge.getParams('%@')",idStr] webView:webView];
    if ([params isEqual:@""]) {
        params = @"{}";
    }
    
    return  [BaoFooJSTool getObjectFromJSONString:params WithOption:NSJSONReadingAllowFragments];
}


+ (NSString *)callBackStringFrom:(id)obj idStr:(NSString *)idStr isSuccess:(BOOL)isSuccess webView:(UIWebView *)webView {
    NSDictionary *dictionary;
    if (isSuccess) {
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"1",@"status",
                                    @"",@"failreson",
                                    obj,@"data",nil];
    }
    else {
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"0",@"status",
                      obj,@"failreson",
                      @"",@"data",nil];
    }
    NSString *jsonStr = [BaoFooJSTool getJSONStringFromObject:dictionary];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"];
    NSString *script = [NSString stringWithFormat:@"mandaobridge.native2web('%@','%@');", idStr,jsonStr];
    
    return [[self class] doJavaScriptString:script webView:webView];
}

+ (NSString *)doJavaScriptString:(NSString *)script webView:(UIWebView *)webView{
    return [webView stringByEvaluatingJavaScriptFromString:script];
}

+ (void)actionAlert:(NSDictionary *)params andReqID:(NSString *)reqID atWebView:(UIWebView *)webView{
    [BaoFooBlockAlert showWithTitle:params[@"options"][@"title"] message:params[@"content"] cancelButtonTitle:params[@"options"][@"confirmBtn"][@"title"] otherButtonTitles:nil operation:^(NSInteger index) {
        [[self class] callBackStringFrom:@{@"action":params[@"options"][@"confirmBtn"][@"action"]} idStr:reqID isSuccess:YES webView:webView];
    }];
}

+ (void)comfirmAlert:(NSDictionary *)params andReqID:(NSString *)reqID atWebView:(UIWebView *)webView {
    
    [BaoFooBlockAlert showWithTitle:params[@"options"][@"title"] message:params[@"content"] cancelButtonTitle:params[@"options"][@"cancelBtn"][@"title"] otherButtonTitles:params[@"options"][@"confirmBtn"][@"title"] operation:^(NSInteger index) {
        if (index == 0) {
            [[self class] callBackStringFrom:@{@"action":params[@"options"][@"cancelBtn"][@"action"]} idStr:reqID isSuccess:YES webView:webView];
        }
        else {
            [[self class] callBackStringFrom:@{@"action":params[@"options"][@"confirmBtn"][@"action"]} idStr:reqID isSuccess:YES webView:webView];
        }
    }];
}//TODO:存储数据
+ (void)saveData:(NSDictionary *)params {
    NSString *key = params[@"key"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:params[@"data"] forKey:key];
}
//TODO:读取数据
+ (void)readDate:(NSDictionary *)params andReqID:(NSString *)reqID atWebView:(UIWebView *)webView{
    NSString *key = params[@"key"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[self class] callBackStringFrom:[userDefaults objectForKey:key] idStr:reqID isSuccess:YES webView:webView];
}

+ (NSDictionary *)getDeviceInfo {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"sdk"] = WebView_Version;
    dic[@"model"] = [[UIDevice currentDevice] model];
    dic[@"platform"] = [[UIDevice currentDevice] systemName];
    dic[@"version"] = [[UIDevice currentDevice] systemVersion];
    dic[@"uuid"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return dic;
}
//TODO:返回系统设备信息
+ (void)systemInfoWithReqID:(NSString *)reqID atWebView:(UIWebView *)webview {
    [[self class] callBackStringFrom:[[self class] getDeviceInfo] idStr:reqID isSuccess:YES webView:webview];
}
//TODO:调用系统打电话
+ (void)actionCall:(NSDictionary *)params{
    if ([params[@"isDerect"] integerValue]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", params[@"cellnum"]]]];
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", params[@"cellnum"]]]];
    }
}

//TODO:base64解码
+ (void)actionBase64Decode:(NSString *)params reqID:(NSString *)reqID webView:(UIWebView *)webView {
    [[self class] callBackStringFrom:[[self class] base64DecodeStr:params] idStr:reqID isSuccess:YES webView:webView];
}

//TODO:base64加密
+ (void)actionBase64Encode:(NSString *)params reqID:(NSString *)reqID webView:(UIWebView *)webView {
    [[self class] callBackStringFrom:[[self class] base64EncodeStr:params] idStr:reqID isSuccess:YES webView:webView];
}

//解密
+ (NSString *)base64DecodeStr:(NSString *)str {
    NSData *data = [[self class] dataFromBase64EncodedString:str];
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *newValue = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    return [[self class] isEmptyString:(newValue)]?@"":(newValue);
}

//加密
+ (NSString *)base64EncodeStr:(NSString *)str {
    NSString *base64Str = [[self class] base64EncodedStringFromString:str];
    return ([[self class] isEmptyString:(base64Str)]?@"":(base64Str));
}

//判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
// 16进制生成color
+ (UIColor *)BaoFoocolorWithHexString:(NSString *)str{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

+ (NSString *)base64EncodedStringFromString:(NSString *)string enCoding:(NSStringEncoding)encoding{
    NSData *data = [string dataUsingEncoding:encoding];
    return [[self class] base64EncodedStringFromData:data];
}
+ (NSString *)base64EncodedStringFromString:(NSString *)string{
    return [[self class] base64EncodedStringFromString:string enCoding:NSUTF8StringEncoding];
}

#pragma mark - Base64

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

#pragma mark - Base64加密

+ (NSString *)base64EncodedStringFromData:(NSData *)data{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else {
        if ([data length] == 0) {
            return @"";
        }
        char *characters = malloc((([data length] + 2) / 3) * 4);
        if (characters == NULL) {
            return nil;
        }
        
        NSUInteger length = 0;
        NSUInteger i = 0;
        
        while (i < [data length]) {
            char buffer[3] = {0,0,0};
            short bufferLength = 0;
            while (bufferLength < 3 && i < [data length]){
                buffer[bufferLength++] = ((char *)[data bytes])[i++];
            }
            
            //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
            characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
            characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
            
            if (bufferLength > 1){
                characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
            }
            else {
                characters[length++] = '=';
            }
            
            if (bufferLength > 2){
                characters[length++] = encodingTable[buffer[2] & 0x3F];
            }
            else {
                characters[length++] = '=';
            }
        }
        
        return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
    }
}
#pragma mark - Base64解密

+ (NSData *)dataFromBase64EncodedString:(NSString *)string{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    else {
        if (string == nil) {
            [NSException raise:NSInvalidArgumentException format:@""];
        }
        if ([string length] == 0) {
            return [NSData data];
        }
        
        static char *decodingTable = NULL;
        if (decodingTable == NULL) {
            decodingTable = malloc(256);
            if (decodingTable == NULL) {
                return nil;
            }
            
            memset(decodingTable, CHAR_MAX, 256);
            NSUInteger i;
            
            for (i = 0; i < 64; i++){
                decodingTable[(short)encodingTable[i]] = i;
            }
        }
        
        const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
        
        //Not an ASCII string!
        if (characters == NULL) {
            return nil;
        }
        char *bytes = malloc((([string length] + 3) / 4) * 3);
        if (bytes == NULL) {
            return nil;
        }
        
        NSUInteger length = 0;
        NSUInteger i = 0;
        while (YES){
            char buffer[4];
            short bufferLength;
            
            for (bufferLength = 0; bufferLength < 4; i++){
                if (characters[i] == '\0') {
                    break;
                }
                if (isspace(characters[i]) || characters[i] == '=') {
                    continue;
                }
                
                buffer[bufferLength] = decodingTable[(short)characters[i]];
                //  Illegal character!
                if (buffer[bufferLength++] == CHAR_MAX){
                    free(bytes);
                    return nil;
                }
            }
            if (bufferLength == 0) break;
            
            //  At least two characters are needed to produce one byte!
            if (bufferLength == 1){
                free(bytes);
                return nil;
            }
            
            //  Decode the characters in the buffer to bytes.
            bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
            if (bufferLength > 2) bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
            if (bufferLength > 3) bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
//        realloc(bytes, length);
        return [NSData dataWithBytesNoCopy:bytes length:length];
    }
}
//密匙 key
#define gkey            @"baofoo.com"
#pragma mark baofoo加密
+ (NSString *)baofooEncrypt:(NSString *)str {
    NSString * tempStr = [[self class] base64EncodeStr:str];
    tempStr = [tempStr stringByAppendingString:[[self class] base64EncodeStr:gkey]];
    return [[self class] base64EncodeStr:tempStr];
}

#pragma mark 3DES加密
+ (NSString *)desEncryptStr:(NSString *)originalStr {
    
    //把string 转NSData
    NSData* data = [originalStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //length
    size_t plainTextBufferSize = [data length];
    
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    //偏移量
    //    const void *vinitVec = (const void *) [gIv UTF8String];
    
    //配置CCCrypt
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES, //3DES
                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                       vkey,    //key
                       kCCKeySize3DES,
                       nil,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [[self class] base64EncodedStringFromData:myData];
    
    return result;
}

#pragma mark 3DES解密
+ (NSString*)desDecEncryptStr:(NSString *)str {
    
    NSData *data = [[self class] dataFromBase64EncodedString:str];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = [data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    
    //    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding|kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    return result;
}

+ (NSString *)phoneNumberFormat:(NSString *)phone {
    NSMutableString *tempPhone = [NSMutableString stringWithString:phone];
    NSRange prefixRange = [tempPhone rangeOfString:@"+86"];
    if (prefixRange.location != NSNotFound) {
        [tempPhone deleteCharactersInRange:prefixRange];
    }
    NSRange spaceRange = [tempPhone rangeOfString:@" "];
    while (spaceRange.location != NSNotFound) {
        [tempPhone deleteCharactersInRange:spaceRange];
        spaceRange = [tempPhone rangeOfString:@" "];
    }
    NSRange linkRange = [tempPhone rangeOfString:@"-"];
    while (linkRange.location != NSNotFound) {
        [tempPhone deleteCharactersInRange:linkRange];
        linkRange = [tempPhone rangeOfString:@" "];
    }
    return tempPhone;
}



+ (NSString *)BaoFooMd5:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

+ (id)getObjectFromJSONString:(NSString *)jsonStr{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    else {
        return object;
    }
}

+ (id)getObjectFromJSONString:(NSString *)jsonStr WithOption:(NSJSONReadingOptions)option{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:option error:&error];
    if (error) {
        return nil;
    }
    else {
        return object;
    }
}

+ (id)getObjectFromJSONData:(NSData *)jsonData {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    else {
        return object;
    }
}

+ (NSData *)getJSONDataFromObject:(id)obj {
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&error];
    if (error){
        return nil;
    }
    else {
        return data;
    }
}

+ (NSString *)getJSONStringFromObject:(id)obj {
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    else {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
}

+(NSString *)getNetWorkStates {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}
@end
