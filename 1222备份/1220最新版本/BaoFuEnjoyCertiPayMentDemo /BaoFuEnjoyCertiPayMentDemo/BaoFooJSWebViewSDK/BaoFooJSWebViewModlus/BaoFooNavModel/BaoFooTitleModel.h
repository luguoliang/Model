//
//  BaoFooTitleModel.h
//  BaoFooJSDemo
//
//  Created by zhoujun on 2016/11/25.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaoFooBtnModel;

@interface BaoFooTitleModel : NSObject

@property (nonatomic, copy) NSString * background_color;
@property (nonatomic, copy) NSString * splitline_color;
@property (nonatomic, strong) BaoFooBtnModel * headMain;
@property (nonatomic, strong) BaoFooBtnModel * headSub;
@property (nonatomic, strong) BaoFooBtnModel * leftBtn;
@property (nonatomic, strong) BaoFooBtnModel * rightBtn;


@end
