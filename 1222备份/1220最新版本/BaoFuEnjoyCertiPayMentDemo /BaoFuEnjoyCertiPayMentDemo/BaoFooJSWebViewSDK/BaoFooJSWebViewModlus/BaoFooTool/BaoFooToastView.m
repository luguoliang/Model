//
//  BaoFooToastView.m
//  公用类
//
//  Created by 哈 哈 on 14-9-19.
//  Copyright (c) 2014年 mapabc. All rights reserved.
//

#import "BaoFooToastView.h"
#import <QuartzCore/QuartzCore.h>

@interface BaoFooToastView()
{
    CGFloat screenWidth,screenHeight,viewAlpha;
}
@end

static const CFTimeInterval defaultTime = 1;

@implementation BaoFooToastView



#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        viewAlpha = 0.7;
    }
    return self;
}

+(BaoFooToastView *)sharedView{
    static BaoFooToastView *sharedView;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedView = [[BaoFooToastView alloc]initWithFrame:CGRectZero];
    });
    return sharedView;
    
}


#pragma mark 默认显示
+(void)show:(NSString *)message{
    [self show:message delay:defaultTime];
}

#pragma mark 根据时间显示
+(void)show:(NSString *)message delay:(CFTimeInterval)delay{
    [[BaoFooToastView sharedView]showDelay:delay andMessage:message];
}


#pragma mark 显示
-(void)showDelay:(CFTimeInterval)delay andMessage:(NSString *)message{
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(30, screenHeight*0.5-20*0.5, screenWidth-30*2, 40)];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = viewAlpha;
    contentView.layer.cornerRadius = 5.0;
    [self addSubview:contentView];
    
    UILabel *stringLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    stringLabel.text = message;
    stringLabel.backgroundColor = [UIColor clearColor];
    stringLabel.textAlignment = NSTextAlignmentCenter;
    stringLabel.numberOfLines = 1;
    stringLabel.lineBreakMode = NSLineBreakByCharWrapping;
    stringLabel.textColor = [UIColor whiteColor];
    stringLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [contentView addSubview:stringLabel];
    [self showUsingAnimation:contentView];
    
    CGSize size = [stringLabel.text sizeWithFont:stringLabel.font
                                              constrainedToSize:CGSizeMake(CGFLOAT_MAX, stringLabel.frame.size.height)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
    contentView.frame = CGRectMake(screenWidth*0.5-(size.width+60)*0.5, screenHeight*0.5-30*0.5, size.width+60, 30);
    stringLabel.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    
    [[UIApplication sharedApplication].keyWindow addSubview:contentView];
    [self performSelector:@selector(dismiss:) withObject:contentView afterDelay:delay];
}

#pragma mark 关闭
-(void)dismiss:(UIView *)view{
    [self dismissUsingAnimation:view];
}

#pragma mark 动画显示
-(void)showUsingAnimation:(UIView *)view{
    
    view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        view.alpha = viewAlpha;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark 消失动画
-(void)dismissUsingAnimation:(UIView *)view{
    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end
