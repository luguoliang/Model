//
//  Agreement.h
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/22.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol abc <NSObject>

/*
 *支付结果回调
 *预加载接口回调
 *
 */
-(void)callBack:(NSString*)statusCode andMessage:(NSString *)message;
-(void)bfPreloadingcallBackaaa;

@end

@interface Agreement : UIViewController
@property(nonatomic,retain)id<abc>delegate;
@property(nonatomic,copy)NSString*urlStr;
@end
