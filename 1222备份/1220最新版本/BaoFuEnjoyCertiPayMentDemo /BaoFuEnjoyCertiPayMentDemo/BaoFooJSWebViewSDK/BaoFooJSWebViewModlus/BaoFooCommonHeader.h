//
//  BaoFooCommonHeader.h
//  BaoFooJSWebViewSDK
//
//  Created by zhoujun on 2016/11/30.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*****************************     常量定义     ***********************************/

#define WebView_Version @"1.0"   //webview组件版本号
#define Platform @"iOS"       //平台

#define BaoFooScreenWidth ([UIScreen mainScreen].bounds.size.width) //屏幕宽度
#define BaoFooScreenHeight ([UIScreen mainScreen].bounds.size.height) //屏幕高度

#define BaoFooCache_Multi @"BaoFooCache_Multi"
#define BaoFooCache_Single @"BaoFooCache_Single"

// 收集设备信息链接
#define BaoFoo_UploadDeviceInfoBaseURL @"http://10.1.60.44:8080/device/collect.do?"

UIKIT_EXTERN NSString *const BaoFooAlert_Title;
UIKIT_EXTERN NSString *const BaoFooAlert_Title_BaoFooNet_Error;
UIKIT_EXTERN NSString *const BaoFooAlert_Title_CameraAuth;

UIKIT_EXTERN NSString *const BaoFooAlert_Message_BaoFooNet_Error;
UIKIT_EXTERN NSString *const BaoFooAlert_Message_CameraAuth;
UIKIT_EXTERN NSString *const BaoFooAlert_Message_CameraWrong;
UIKIT_EXTERN NSString *const BaoFooAlert_Button_Cancel;
UIKIT_EXTERN NSString *const BaoFooAlert_Button_Confirm;

UIKIT_EXTERN NSString *const BaoFooNet_Error;
UIKIT_EXTERN NSString *const BaoFooNet_Error_Code;
UIKIT_EXTERN NSString *const BaoFooNet_Busy;

// 默认背景
#define NavbarBackgroudWhiteColor @"#ffffff"
#define NavbarBackgroudOrangeColor @"#fc9120"
#define NavbarMainTitleBlackColor @"#000000"
#define NavbarMainTitleWhiteColor @"#ffffff"
#define NavbarSubTitleWhiteColor @"#ffffff"
#define NavbarSubTitleGrayColor @"#7d7d7d"
#define NavbarBtnTitleBlackColor @"#535353"
#define NavbarBtnTitleWhiteColor @"ffffff"
#define NavbarBottomLineColor @"#e6e6e6"
#define NavbarSingleMainTitleFont [UIFont systemFontOfSize:27]
#define NavbarDoubleMainTitleFont [UIFont systemFontOfSize:23]
#define NavbarSubTitleFont [UIFont systemFontOfSize:15]
#define NavbarBtnTitleFont [UIFont systemFontOfSize:20]

#define __weakself__ __weak __typeof(&*self)weakself = self;
#define __strongself__ __strong __typeof__(&*self) strongSelf = weakself;

@interface BaoFooCommonHeader : NSObject

@end
