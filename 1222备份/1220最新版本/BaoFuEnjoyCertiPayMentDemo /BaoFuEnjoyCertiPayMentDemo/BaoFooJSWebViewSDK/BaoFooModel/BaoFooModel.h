//
//  BaoFooModel.h
//  BaoFooModel <https://github.com/ibireme/BaoFooModel>
//
//  Created by ibireme on 15/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<BaoFooModel/BaoFooModel.h>)
FOUNDATION_EXPORT double BaoFooModelVersionNumber;
FOUNDATION_EXPORT const unsigned char BaoFooModelVersionString[];
#import <BaoFooModel/NSObject+BaoFooModel.h>
#import <BaoFooModel/BaoFooClassInfo.h>
#else
#import "NSObject+BaoFooModel.h"
#import "BaoFooClassInfo.h"
#endif
