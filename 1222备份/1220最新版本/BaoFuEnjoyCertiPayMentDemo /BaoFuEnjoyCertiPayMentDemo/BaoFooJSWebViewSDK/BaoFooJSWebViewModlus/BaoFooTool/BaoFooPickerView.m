//
//  BaoFooPickerView.m
//  BestpayUIKit
//
//  Created by yfzx_sh_louwk on 15/9/18.
//  Copyright (c) 2015年 Bestpay. All rights reserved.
//

#import "BaoFooPickerView.h"

@interface BaoFooPickerView ()<UIActionSheetDelegate>

@end

@implementation BaoFooPickerView

+ (instancetype)createPickerView{
    return [[BaoFooPickerView alloc] init];
}

- (void)show:(UIViewController *)controller{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            [self confirmAction];
        }];
        [actionSheet addAction:confirmAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [self cancelAction];
        }];
        [actionSheet addAction:cancelAction];
        [actionSheet.view addSubview:self];
                
        self.center = CGPointMake(actionSheet.view.bounds.size.width/2-10.0, self.center.y);
        
        [controller presentViewController:actionSheet animated:YES completion:nil];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet addSubview:self];
        
        [actionSheet showInView:[controller.view window]];
    }
}

#pragma mark - IOS8中ActionSheet的按钮响应方法

- (void)confirmAction{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(pickerViewDidConfirm:)]) {
        [_actionDelegate pickerViewDidConfirm:self];
    }
}

- (void)cancelAction{
    if (_actionDelegate && [_actionDelegate respondsToSelector:@selector(pickerViewDidCancel:)]) {
        [_actionDelegate pickerViewDidCancel:self];
    }
}

#pragma mark - IOS7.0 以下系统

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self confirmAction];
    }
    else {
        [self cancelAction];
    }
}

@end
