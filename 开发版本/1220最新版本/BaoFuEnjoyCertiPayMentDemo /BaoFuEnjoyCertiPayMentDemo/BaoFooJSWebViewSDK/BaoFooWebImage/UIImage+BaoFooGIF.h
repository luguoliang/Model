//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BaoFooGIF)

+ (UIImage *)bf_animatedGIFNamed:(NSString *)name;

+ (UIImage *)bf_animatedGIFWithData:(NSData *)data;

- (UIImage *)bf_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
