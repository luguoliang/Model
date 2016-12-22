//
//  BaoFooToastView.h
//  公用类
//
//  Created by 哈 哈 on 14-9-19.
//  Copyright (c) 2014年 BaoFoopabc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoFooToastView : UIView

+(void)show:(NSString *)message delay:(CFTimeInterval)delay;

+(void)show:(NSString *)message;
@end
