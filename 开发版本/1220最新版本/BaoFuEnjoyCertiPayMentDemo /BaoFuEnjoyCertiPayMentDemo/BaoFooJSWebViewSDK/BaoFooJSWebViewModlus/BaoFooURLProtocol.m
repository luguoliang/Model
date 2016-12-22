//
//  BaoFooURLProtocol.m
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by zhoujun on 2016/12/16.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooURLProtocol.h"
#import "BaoFooCacheTool.h"
#import "BaoFooCommonHeader.h"
#import "BaoFooJSTool.h"
@interface NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround;

@end
@implementation NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL]
                                                                          cachePolicy:[self cachePolicy]
                                                                      timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    if ([self HTTPBodyStream]) {
        [mutableURLRequest setHTTPBodyStream:[self HTTPBodyStream]];
    } else {
        [mutableURLRequest setHTTPBody:[self HTTPBody]];
    }
    [mutableURLRequest setHTTPMethod:[self HTTPMethod]];
    
    return mutableURLRequest;
}

@end
@interface BaoFooCacheData : NSObject <NSCoding>
@property (nonatomic, readwrite, strong) NSData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, strong) NSURLRequest *redirectRequest;
@end

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kRedirectRequestKey = @"redirectRequest";

@implementation BaoFooCacheData

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self response] forKey:kResponseKey];
    [aCoder encodeObject:[self redirectRequest] forKey:kRedirectRequestKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
        [self setRedirectRequest:[aDecoder decodeObjectForKey:kRedirectRequestKey]];
    }
    
    return self;
}

@end

static NSString * const BaoFooURLProtocolHandledKey = @"BaoFooURLProtocolHandledKey";
static NSString * const BaoFooCacheStyleMulti = @"BaoFooCacheStyleMulti";
static NSString * const BaoFooCacheStyleSingle = @"BaoFooCacheStyleSingle";


@interface BaoFooURLProtocol ()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, copy) NSString * cacheStyle;

@end

static NSObject *RNCachingSupportedSchemesMonitor;
static NSSet *RNCachingSupportedSchemes;


@implementation BaoFooURLProtocol

+ (void)initialize
{
    if (self == [BaoFooURLProtocol class])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            RNCachingSupportedSchemesMonitor = [NSObject new];
        });
        
        [self setSupportedSchemes:[NSSet setWithObjects:@"https",@"http",nil]];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"%@",[[request URL] absoluteString]);
    //只处理http和https请求
    if ([[self supportedSchemes] containsObject:[[request URL] scheme]])
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:BaoFooURLProtocolHandledKey inRequest:request]) {
            NSLog(@"--request已经处理过了--");
            return NO;
        }
        NSString * urlString = [[request URL] absoluteString];
        if (([urlString rangeOfString:@"&_t_=multi"].location != NSNotFound) || ([urlString rangeOfString:@"&_t_=single"].location != NSNotFound) || ([urlString rangeOfString:@"&_t_=preload"].location != NSNotFound)) { // #multi#   #single#
            NSLog(@"--request进入处理流程--");
            return YES;
        }
        else {
            return NO;
        }
    }
    return NO;
}

- (void)multiCacheHandlerWith:(NSString *)fileName {
    NSLog(@"%s--/fileNmae/--%@" ,__func__,fileName);
    NSString *md5_fileName = [[self class] multiCachePathWith:fileName];
    NSLog(@"%s--/md5_fileNmae/--%@" ,__func__,md5_fileName);
    if ([[self class] isCacheExistWith:md5_fileName]) {
        [self readCacheWith:md5_fileName];
    }
    else {
        NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:fileName] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:req
                                                                    delegate:self];
        self.cacheStyle = BaoFooCacheStyleMulti;
        [self setConnection:connection];
    }
}

- (void)singleCacheHandlerWith:(NSString *)fileName {
    NSLog(@"%s--/fileNmae/--%@" ,__func__,fileName);
    NSString * tempName = [fileName substringToIndex:[fileName rangeOfString:@"?_v_="].location];
    NSString *md5_fileName = [[self class] singleCachePathWith:tempName];
    NSLog(@"%s--/md5_fileNmae/--%@" ,__func__,md5_fileName);
    if ([[self class] isCacheExistWith:md5_fileName]) {
        [self readCacheWith:md5_fileName];
    }
    else {
        NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:tempName] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:req
                                                                    delegate:self];
        self.cacheStyle = BaoFooCacheStyleSingle;
        [self setConnection:connection];
    }
}

- (void)preloadCacheHandlerWith:(NSString *)fileName { // @"application/javascript"
    
    if ([fileName rangeOfString:@"template.min.js"].location != NSNotFound) {
        fileName = [fileName substringToIndex:[fileName rangeOfString:@"?_v_="].location];
        NSData * data = [[BaoFooJSTool base64DecodeStr:BaoFooTemplate_min_js] dataUsingEncoding:NSUTF8StringEncoding];
//        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//        dict[@"Accept-Ranges"] = @"bytes";
//        dict[@"Connection"] = @"keep-alive";
//        dict[@"Content-Length"] = [NSString stringWithFormat:@"%lu",(unsigned long)data.length];
//        dict[@"Content-Type"] = @"application/javascript; charset=utf-8";
//        dict[@"Date"] = @"Tue, 20 Dec 2016 09:30:54 GMT";
//        dict[@"Etag"] = @"5858ebd1-6c5";
//        dict[@"Last-Modified"] = @"Tue, 20 Dec 2016 08:29:05 GMT";
//        dict[@"Server"] = @"nginx/1.11.6";
//        NSURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:fileName] statusCode:200 HTTPVersion:@"2.0" headerFields:dict];
//        [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[self client] URLProtocol:self didLoadData:data];
        [[self client] URLProtocolDidFinishLoading:self];
    }
    else if([fileName rangeOfString:@"zepto.min.js"].location != NSNotFound) {
        fileName = [fileName substringToIndex:[fileName rangeOfString:@"?_v_="].location];
        NSData * data = [[BaoFooJSTool base64DecodeStr:BaoFooZepto_min_js] dataUsingEncoding:NSUTF8StringEncoding];
        [[self client] URLProtocol:self didLoadData:data];
        [[self client] URLProtocolDidFinishLoading:self];
    }
}

- (void)readCacheWith:(NSString *)fileName {
    BaoFooCacheData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (cache) {
        NSData *data = [cache data];
        NSURLResponse *response = [cache response];
        NSURLRequest *redirectRequest = [cache redirectRequest];
        if (redirectRequest) {
            [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
        } else {
            [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed]; // we handle caching ourselves.
            [[self client] URLProtocol:self didLoadData:data];
            [[self client] URLProtocolDidFinishLoading:self];
        }
    }
    else {
        [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil]];
    }
}

+ (BOOL)isCacheExistWith:(NSString *)fileName {
    return [BaoFooCacheTool fileExistsAtPath:fileName];
}

+ (NSString *)multiCachePathWith:(NSString *)fileName {
    NSString * documentPath = [BaoFooCacheTool getDocumentFilePathWithName:BaoFooCache_Multi];
    return [documentPath stringByAppendingPathComponent:[BaoFooJSTool BaoFooMd5:fileName]];
}

+ (NSString *)singleCachePathWith:(NSString *)fileName {
    NSString * documentPath = [BaoFooCacheTool getDocumentFilePathWithName:BaoFooCache_Single];
    return [documentPath stringByAppendingPathComponent:[BaoFooJSTool BaoFooMd5:fileName]];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
//    if ([[[request URL] absoluteString] isEqualToString:@"http://10.0.203.131:8080/xy.html?_v_=20161215&_t_=single"]) {
//        return [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
//    }
    return request;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopyWorkaround];
    [NSURLProtocol setProperty:@YES forKey:BaoFooURLProtocolHandledKey inRequest:mutableReqeust];
    
    NSString * urlString = [[mutableReqeust URL] absoluteString];
    if ([urlString rangeOfString:@"&_t_=multi"].location != NSNotFound) { // #multi#   #single#
        NSString * fileName = [urlString substringToIndex:[urlString rangeOfString:@"&_t_=multi"].location];
        [self multiCacheHandlerWith:fileName];
    }
    else if ([urlString rangeOfString:@"&_t_=single"].location != NSNotFound) {
        NSString * fileName = [urlString substringToIndex:[urlString rangeOfString:@"&_t_=single"].location];
        [self singleCacheHandlerWith:fileName];
    }
    else if ([urlString rangeOfString:@"&_t_=preload"].location != NSNotFound) {
        NSString * fileName = [urlString substringToIndex:[urlString rangeOfString:@"&_t_=preload"].location];
        [self preloadCacheHandlerWith:fileName];
    }
}

- (void)stopLoading
{
    [[self connection] cancel];
}

// NSURLConnection delegates (generally we pass these on to our client)

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    /*
    if (response != nil) {
        NSMutableURLRequest *redirectableRequest = [request mutableCopyWorkaround];
        [NSURLProtocol setProperty:@NO forKey:BaoFooURLProtocolHandledKey inRequest:redirectableRequest];
        // We need to remove our header so we know to handle this request and cache it.
        // There are 3 requests in flight: the outside request, which we handled, the internal request,
        // which we marked with our header, and the redirectableRequest, which we're modifying here.
        // The redirectable request will cause a new outside request from the NSURLProtocolClient, which
        // must not be marked with our header.
        NSString * cachePath;
        if ([self.cacheStyle isEqualToString:BaoFooCacheStyleSingle]) {
            NSString * singleFileName = [[[request URL] absoluteString] substringToIndex:[[[request URL] absoluteString] rangeOfString:@"?"].location];
            cachePath = [BaoFooJSTool BaoFooMd5:[[self class] singleCachePathWith:singleFileName]];
            [self saveResponse:response to:cachePath redirectableRequest:redirectableRequest];
            return redirectableRequest;
        }
        else if ([self.cacheStyle isEqualToString:BaoFooCacheStyleMulti]) {
            cachePath = [BaoFooJSTool BaoFooMd5:[[self class] singleCachePathWith:[[request URL] absoluteString]]];
            [self saveResponse:response to:cachePath redirectableRequest:redirectableRequest];
            return redirectableRequest;
        }
        else {
            return request;
        }
    } else {
        return request;
    }
     */
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self setResponse:response];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];  // We cache ourselves.
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
    NSString * cachePath;
    if ([self.cacheStyle isEqualToString:BaoFooCacheStyleSingle]) {
        NSString * singleFileName = [[[self.request URL] absoluteString] substringToIndex:[[[self.request URL] absoluteString] rangeOfString:@"?"].location];
        cachePath = [[self class] singleCachePathWith:singleFileName];
        BaoFooCacheData *cache = [BaoFooCacheData new];
        [cache setResponse:self.response];
        [cache setData:[self data]];
        
        BOOL abc = [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
        NSLog(@"%d--%@",abc,cachePath);
    }
    else if ([self.cacheStyle isEqualToString:BaoFooCacheStyleMulti]) {
        cachePath = [[self class] multiCachePathWith:[[self.request URL] absoluteString]];
        BaoFooCacheData *cache = [BaoFooCacheData new];
        [cache setResponse:self.response];
        [cache setData:[self data]];
        BOOL abc = [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
        NSLog(@"%d--%@",abc,cachePath);
    }
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (void)appendData:(NSData *)newData
{
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    }
    else {
        [[self data] appendData:newData];
    }
}



+ (NSSet *)supportedSchemes {
    NSSet *supportedSchemes;
    @synchronized(RNCachingSupportedSchemesMonitor)
    {
        supportedSchemes = RNCachingSupportedSchemes;
    }
    return supportedSchemes;
}

+ (void)setSupportedSchemes:(NSSet *)supportedSchemes
{
    @synchronized(RNCachingSupportedSchemesMonitor)
    {
        RNCachingSupportedSchemes = supportedSchemes;
    }
}


@end

