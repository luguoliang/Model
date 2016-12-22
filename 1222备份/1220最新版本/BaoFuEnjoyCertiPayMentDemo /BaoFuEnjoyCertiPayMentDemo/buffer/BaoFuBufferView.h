//
//  BaoFuBufferView.h
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/7.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoFuBufferView : UIView

/**
 *  单例模式
 *
 */
+(BaoFuBufferView*)sharedManager;

/**
 *  弹出缓冲匡
 *
 *  @param view 参数
 *
 */
- (void)showBufferAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 *  隐藏缓冲匡
 *
 *  @param view 参数
 *
 */
- (void)hideBufferForView:(UIView *)view animated:(BOOL)animated;

@end
