//
//  BaofooCertifePay.h
//  fang
//
//  Created by 路国良 on 16/9/20.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BF_FangSdkDelegate <NSObject>
/*
 *关闭收银台
 *确认支付
 *获取短信验证码
 */
-(void)ClosedCashier;
-(void)okenButtonWithMessageCode:(NSString*)messageCode andButton:(UIButton*)button;
-(void)getMessageCode;

@end

@interface BaofooCertifePay : UIView

@property(nonatomic,retain)id<BF_FangSdkDelegate>delegate;
@property(nonatomic,copy)NSString*mobile;

-(void)codeStart;
-(void)codeStop;
@end
