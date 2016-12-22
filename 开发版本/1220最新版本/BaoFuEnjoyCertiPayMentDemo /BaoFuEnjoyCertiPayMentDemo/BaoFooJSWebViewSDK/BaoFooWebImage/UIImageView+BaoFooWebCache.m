/*
 * This file is part of the BaoFooWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+BaoFooWebCache.h"
#import "objc/runtime.h"
#import "UIView+BaoFooWebCacheOperation.h"

static char imageURLKey;

@implementation UIImageView (BaoFooWebCache)

- (void)bf_setImageWithURL:(NSURL *)url {
    [self bf_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)bf_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)bf_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)bf_setImageWithURL:(NSURL *)url completed:(BaoFooWebImageCompletionBlock)completedBlock {
    [self bf_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)bf_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(BaoFooWebImageCompletionBlock)completedBlock {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)bf_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options completed:(BaoFooWebImageCompletionBlock)completedBlock {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)bf_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options progress:(BaoFooWebImageDownloaderProgressBlock)progressBlock completed:(BaoFooWebImageCompletionBlock)completedBlock {
    [self bf_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & BaoFooWebImageDelayPlaceholder)) {
        self.image = placeholder;
    }
    
    if (url) {
        __weak UIImageView *wself = self;
        id <BaoFooWebImageOperation> operation = [BaoFooWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & BaoFooWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self bf_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"BaoFooWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, BaoFooImageCacheTypeNone, url);
            }
        });
    }
}

- (void)bf_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options progress:(BaoFooWebImageDownloaderProgressBlock)progressBlock completed:(BaoFooWebImageCompletionBlock)completedBlock {
    NSString *key = [[BaoFooWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[BaoFooImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self bf_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];    
}

- (NSURL *)bf_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)bf_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self bf_cancelCurrentAnimationImagesLoad];
    __weak UIImageView *wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs) {
        id <BaoFooWebImageOperation> operation = [BaoFooWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    [self bf_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)bf_cancelCurrentImageLoad {
    [self bf_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)bf_cancelCurrentAnimationImagesLoad {
    [self bf_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}

@end


@implementation UIImageView (WebCacheDeprecated)

- (NSURL *)imageURL {
    return [self bf_imageURL];
}

- (void)setImageWithURL:(NSURL *)url {
    [self bf_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(BaoFooWebImageCompletedBlock)completedBlock {
    [self bf_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(BaoFooWebImageCompletedBlock)completedBlock {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options completed:(BaoFooWebImageCompletedBlock)completedBlock {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options progress:(BaoFooWebImageDownloaderProgressBlock)progressBlock completed:(BaoFooWebImageCompletedBlock)completedBlock {
    [self bf_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentArrayLoad {
    [self bf_cancelCurrentAnimationImagesLoad];
}

- (void)cancelCurrentImageLoad {
    [self bf_cancelCurrentImageLoad];
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self bf_setAnimationImagesWithURLs:arrayOfURLs];
}

@end
