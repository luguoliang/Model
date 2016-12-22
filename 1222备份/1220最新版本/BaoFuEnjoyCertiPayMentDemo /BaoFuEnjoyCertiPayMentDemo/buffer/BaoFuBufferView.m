//
//  BaoFuBufferView.m
//  BaoFuEnjoyCertiPayMentDemo
//
//  Created by 路国良 on 16/12/7.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFuBufferView.h"
#import "BaoFuBufferImage.h"
@interface BaoFuBufferView()
{
    UIView*_maskView;
    UIView*_bufferView;
    UIImageView*_logImage;
    UIImageView*_animationImage;
}

@end

@implementation BaoFuBufferView

+(BaoFuBufferView*)sharedManager
{
    static BaoFuBufferView*sharedSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return sharedSingleton;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)showBufferAddedTo:(UIView *)view animated:(BOOL)animated{
    [self loadBufferView:view];
}

-(void)hideBufferForView:(UIView *)view animated:(BOOL)animated{
    _maskView.hidden = YES;
    _maskView = nil;
    [_maskView removeFromSuperview];
    [_bufferView removeFromSuperview];
    _bufferView = nil;
}

-(void)loadBufferView:(UIView*)view{
       if (!_maskView) {
           {
               _maskView = [[UIView alloc] init];
               _maskView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
               [view addSubview:_maskView];
           }
           
           {
               _maskView.translatesAutoresizingMaskIntoConstraints = NO;
               NSArray*stsConstraintsW  = [NSLayoutConstraint
                                           constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
                                           options:0
                                           metrics:nil views:@{@"view":_maskView}
                                           ];
               [view addConstraints:stsConstraintsW];
               NSArray*stsConstraintsH = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                          options:0
                                          metrics:nil views:@{@"view":_maskView}
                                          ];
               [view addConstraints:stsConstraintsH];
 
           }
           
           {
               _bufferView = [[UIView alloc] init];
               _bufferView.backgroundColor = [UIColor blackColor];
               _bufferView.alpha = 0.7;
               _bufferView.layer.cornerRadius = 5.0f;
               _logImage = [[UIImageView alloc] init];
               _animationImage = [[UIImageView alloc] init];
               [_maskView addSubview:_bufferView];
               [_bufferView addSubview:_logImage];
               [_bufferView addSubview:_animationImage];
               _bufferView.translatesAutoresizingMaskIntoConstraints = NO;
               _bufferView.backgroundColor  = [UIColor grayColor];
               _logImage.translatesAutoresizingMaskIntoConstraints = NO;
               _animationImage.translatesAutoresizingMaskIntoConstraints = NO;

           }
           
           {
               [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:
                                         _bufferView attribute:NSLayoutAttributeWidth relatedBy:
                                         NSLayoutRelationEqual toItem:nil attribute:
                                         NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:120]];
               [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:
                                         _bufferView attribute:NSLayoutAttributeHeight relatedBy:
                                         NSLayoutRelationEqual toItem:_bufferView attribute:
                                         NSLayoutAttributeWidth multiplier:1.0 constant:0]];
               [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:
                                         _maskView attribute:NSLayoutAttributeCenterX relatedBy:
                                         NSLayoutRelationEqual toItem:_bufferView attribute:
                                         NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
               [_maskView addConstraint:[NSLayoutConstraint constraintWithItem:
                                         _maskView attribute:NSLayoutAttributeCenterY relatedBy:
                                         NSLayoutRelationEqual toItem:_bufferView attribute:
                                         NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:
                                           _logImage attribute:NSLayoutAttributeWidth relatedBy:
                                           NSLayoutRelationEqual toItem:nil attribute:
                                           NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:65]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:
                                           _logImage attribute:NSLayoutAttributeHeight relatedBy:
                                           NSLayoutRelationEqual toItem:_logImage attribute:
                                           NSLayoutAttributeWidth multiplier:1.0 constant:0]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:_bufferView attribute:
                                           NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:
                                           _logImage attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:_bufferView attribute:
                                           NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:
                                           _logImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:_animationImage attribute:
                                           NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:
                                           NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:65]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:_animationImage attribute:
                                           NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_animationImage attribute:
                                           NSLayoutAttributeWidth multiplier:1.0 constant:0]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:_bufferView attribute:
                                           NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:
                                           _animationImage attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
               [_bufferView addConstraint:[NSLayoutConstraint constraintWithItem:_bufferView attribute:
                                           NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:
                                           _animationImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
           }
           
           {
               _logImage.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:[BaoFuBufferImage getLogImageView] options:NSDataBase64DecodingIgnoreUnknownCharacters]];
               _animationImage.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:[BaoFuBufferImage getAnimationImage] options:NSDataBase64DecodingIgnoreUnknownCharacters]];
               [_animationImage.layer addAnimation:[self animation] forKey:@"rotationAnimation"];
           }
           
    }
}
-(CABasicAnimation*)animation{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 999999999;
    return rotationAnimation;
}
@end
