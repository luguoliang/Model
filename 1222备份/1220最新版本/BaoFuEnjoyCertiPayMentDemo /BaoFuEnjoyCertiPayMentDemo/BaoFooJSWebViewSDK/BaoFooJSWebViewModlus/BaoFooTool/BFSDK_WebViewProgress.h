//
//  BFSDK_WebViewProgress.h
//
//  Created by zhoujun on 16/9/20.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#undef BFSDK_weak
#if __has_feature(objc_arc_weak)
#define BFSDK_weak weak
#else
#define BFSDK_weak unsafe_unretained
#endif

extern const float BFSDK_InitialProgressValue;
extern const float BFSDK_InteractiveProgressValue;
extern const float BFSDK_FinalProgressValue;

typedef void (^BFSDK_WebViewProgressBlock)(float progress);
@protocol BFSDK_WebViewProgressDelegate;
@interface BFSDK_WebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, BFSDK_weak) id<BFSDK_WebViewProgressDelegate>progressDelegate;
@property (nonatomic, BFSDK_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) BFSDK_WebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol BFSDK_WebViewProgressDelegate <NSObject>
- (void)webViewProgress:(BFSDK_WebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

