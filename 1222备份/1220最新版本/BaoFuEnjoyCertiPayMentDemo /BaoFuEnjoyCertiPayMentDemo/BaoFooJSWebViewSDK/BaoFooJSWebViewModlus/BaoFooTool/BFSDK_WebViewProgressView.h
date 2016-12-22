//
//  BFSDK_WebViewProgressView.h
// iOS 7 Style WebView Progress Bar
//
//  Created by zhoujun on 16/9/20.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFSDK_WebViewProgressView : UIView
@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1
@property (nonatomic) UIColor * progressColor;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
