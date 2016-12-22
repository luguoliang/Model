//
//  BlockAlert.h
//  baofooUIKit
//
//  Created by yfzx_sh_louwk on 15/8/25.
//  Copyright (c) 2015年 gBF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BaoFooOperationBlock) (NSInteger index);

@interface BaoFooBlockAlert : UIAlertView

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles operation:(BaoFooOperationBlock)operationBlock;

@end
