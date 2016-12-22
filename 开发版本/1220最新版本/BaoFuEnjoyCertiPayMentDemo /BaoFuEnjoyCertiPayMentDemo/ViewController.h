//
//  ViewController.h
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/7.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoFuBufferView.h"
#define BANK_LIST [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/bankList.plist"]//获取银行列表
#define BASE_URL @"http://twallet.baofoo.com"
#define identifyCard @"/card/identifySpecifyCard.do"//查询银行
#define getBankList @"/account/getSpecifyBankList.do"//获取支持银行列表
#define WEAKSELF __weak __typeof(&*self)weakSelf_SC = self;
#define FONT(a) [UIFont systemFontOfSize:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define   SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define   SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define LINE_COLOR 0xd9d9d9 //线条颜色
#define BACKGROUND_COLOR 0xf0eff5//背景颜色
#define BLACK_COLOR 0x505050//黑色
#define BLUE_COLOR 0x2e8fd3//蓝色
@interface ViewController : UIViewController
@property(nonatomic,strong)NSDictionary *bankDict;//选择的银行
- (IBAction)sumitButton:(id)sender;

@end

