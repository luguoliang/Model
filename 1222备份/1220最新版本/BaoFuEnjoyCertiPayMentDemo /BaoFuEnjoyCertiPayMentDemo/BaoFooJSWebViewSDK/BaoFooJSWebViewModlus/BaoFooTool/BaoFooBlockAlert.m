//
//  BlockAlert.m
//  baofooUIKit
//
//  Created by yfzx_sh_louwk on 15/8/25.
//  Copyright (c) 2015年 gBF. All rights reserved.
//

#import "BaoFooBlockAlert.h"

@interface BaoFooBlockAlert ()
{
    BaoFooOperationBlock block;
}
@end

@implementation BaoFooBlockAlert
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles operation:(BaoFooOperationBlock)operationBlock{

    BaoFooBlockAlert *alert = [[BaoFooBlockAlert alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles: otherButtonTitles, nil];
    [alert showAlert:operationBlock];
}

- (void)showAlert:(BaoFooOperationBlock)operationBlock{
    block = operationBlock;
    self.delegate = self;
    [self show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (block) {
        block(buttonIndex);
    }
}

@end
