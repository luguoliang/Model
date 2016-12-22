//
//  BaoFooPickerView.h
//  BestpayUIKit
//
//  Created by yfzx_sh_louwk on 15/9/18.
//  Copyright (c) 2015年 Bestpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaoFooPickerView;
@protocol BaoFooPickerViewDelegate <NSObject>

- (void)pickerViewDidCancel:(BaoFooPickerView *)pickerView;
- (void)pickerViewDidConfirm:(BaoFooPickerView *)picerView;

@end

@interface BaoFooPickerView : UIPickerView

@property (assign, nonatomic) id<BaoFooPickerViewDelegate> actionDelegate;

+ (instancetype)createPickerView;
- (void)show:(UIViewController *)controller;

@end
