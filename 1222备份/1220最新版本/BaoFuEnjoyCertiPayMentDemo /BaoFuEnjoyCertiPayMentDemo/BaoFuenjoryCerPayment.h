//
//  BaoFuenjoryCertiParment.h
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/7.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BaoFuenjoryCerPaymentDelegate <NSObject>

/*
 *支付结果回调
 *预加载接口回调
 *
 */
-(void)callBack:(NSString*)statusCode andMessage:(NSString *)message;
-(void)bfPreloadingcallBack;

@end

@interface BaoFuenjoryCerPayment : UIViewController
/*
 *运行环境
 *
 0:测试环境
 1:准生产环境
 2:正式环境
 */
typedef NS_ENUM(NSInteger,operationalState){
    operational_test = 0,
    operational_associateProduction,
    operational_true
};
@property(nonatomic,assign)operationalState operState;

/*
 *主题样式
 *
 0:白色主题
 1:橘橙色主题
*/
typedef NS_ENUM(NSInteger,naviagtionStyle){
    naviagtionStyle_white = 0,
    naviagtionStyle_orange,
    naviagtionStyle_fang
};

@property(nonatomic,assign)naviagtionStyle nastyle;
@property(nonatomic,retain)id<BaoFuenjoryCerPaymentDelegate>delegate;
@property(nonatomic,copy)NSString*tradeNo;
@end
