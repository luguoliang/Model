//
//  BankListViewController.h
//  BaofooWallet
//
//  Created by mac on 15/5/27.
//  Copyright (c) 2015年 宝付网络（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface BankListViewController : UIViewController
@property(nonatomic,assign)int selectStyle;//选中的样式 0只看不选 1又看又选
@property(nonatomic,strong)ViewController *addBankVC;
@property(nonatomic,copy)NSString *bankId;
@end
