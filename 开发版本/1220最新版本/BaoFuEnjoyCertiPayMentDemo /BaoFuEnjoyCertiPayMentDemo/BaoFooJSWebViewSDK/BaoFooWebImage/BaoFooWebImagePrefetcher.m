/*
 * This file is part of the BaoFooWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "BaoFooWebImagePrefetcher.h"

#if !defined(DEBUG) && !defined (SD_VERBOSE)
#define DebugLog(...)
#endif

@interface BaoFooWebImagePrefetcher ()

@property (strong, nonatomic) BaoFooWebImageManager *manager;
@property (strong, nonatomic) NSArray *prefetchURLs;
@property (assign, nonatomic) NSUInteger requestedCount;
@property (assign, nonatomic) NSUInteger skippedCount;
@property (assign, nonatomic) NSUInteger finishedCount;
@property (assign, nonatomic) NSTimeInterval startedTime;
@property (copy, nonatomic) BaoFooWebImagePrefetcherCompletionBlock completionBlock;
@property (copy, nonatomic) BaoFooWebImagePrefetcherProgressBlock progressBlock;

@end

@implementation BaoFooWebImagePrefetcher

+ (BaoFooWebImagePrefetcher *)sharedImagePrefetcher {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _manager = [BaoFooWebImageManager new];
        _options = BaoFooWebImageLowPriority;
        self.maxConcurrentDownloads = 3;
    }
    return self;
}

- (void)setMaxConcurrentDownloads:(NSUInteger)maxConcurrentDownloads {
    self.manager.imageDownloader.maxConcurrentDownloads = maxConcurrentDownloads;
}

- (NSUInteger)maxConcurrentDownloads {
    return self.manager.imageDownloader.maxConcurrentDownloads;
}

- (void)startPrefetchingAtIndex:(NSUInteger)index {
    if (index >= self.prefetchURLs.count) return;
    self.requestedCount++;
    [self.manager downloadImageWithURL:self.prefetchURLs[index] options:self.options progress:nil completed:^(UIImage *image, NSError *error, BaoFooImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!finished) return;
        self.finishedCount++;

        if (image) {
            if (self.progressBlock) {
                self.progressBlock(self.finishedCount,[self.prefetchURLs count]);
            }
            NSLog(@"Prefetched %@ out of %@", @(self.finishedCount), @(self.prefetchURLs.count));
        }
        else {
            if (self.progressBlock) {
                self.progressBlock(self.finishedCount,[self.prefetchURLs count]);
            }
            NSLog(@"Prefetched %@ out of %@ (Failed)", @(self.finishedCount), @(self.prefetchURLs.count));

            // Add last failed
            self.skippedCount++;
        }
        if ([self.delegate respondsToSelector:@selector(imagePrefetcher:didPrefetchURL:finishedCount:totalCount:)]) {
            [self.delegate imagePrefetcher:self
                            didPrefetchURL:self.prefetchURLs[index]
                             finishedCount:self.finishedCount
                                totalCount:self.prefetchURLs.count
            ];
        }

        if (self.prefetchURLs.count > self.requestedCount) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startPrefetchingAtIndex:self.requestedCount];
            });
        }
        else if (self.finishedCount == self.requestedCount) {
            [self reportStatus];
            if (self.completionBlock) {
                self.completionBlock(self.finishedCount, self.skippedCount);
                self.completionBlock = nil;
            }
        }
    }];
}

- (void)reportStatus {
    NSUInteger total = [self.prefetchURLs count];
    NSLog(@"Finished prefetching (%@ successful, %@ skipped, timeElasped %.2f)", @(total - self.skippedCount), @(self.skippedCount), CFAbsoluteTimeGetCurrent() - self.startedTime);
    if ([self.delegate respondsToSelector:@selector(imagePrefetcher:didFinishWithTotalCount:skippedCount:)]) {
        [self.delegate imagePrefetcher:self
               didFinishWithTotalCount:(total - self.skippedCount)
                          skippedCount:self.skippedCount
        ];
    }
}

- (void)prefetchURLs:(NSArray *)urls {
    [self prefetchURLs:urls progress:nil completed:nil];
}

- (void)prefetchURLs:(NSArray *)urls progress:(BaoFooWebImagePrefetcherProgressBlock)progressBlock completed:(BaoFooWebImagePrefetcherCompletionBlock)completionBlock {
    [self cancelPrefetching]; // Prevent duplicate prefetch request
    self.startedTime = CFAbsoluteTimeGetCurrent();
    self.prefetchURLs = urls;
    self.completionBlock = completionBlock;
    self.progressBlock = progressBlock;

    // Starts prefetching from the very first image on the list with the max allowed concurrency
    NSUInteger listCount = self.prefetchURLs.count;
    for (NSUInteger i = 0; i < self.maxConcurrentDownloads && self.requestedCount < listCount; i++) {
        [self startPrefetchingAtIndex:i];
    }
}

- (void)cancelPrefetching {
    self.prefetchURLs = nil;
    self.skippedCount = 0;
    self.requestedCount = 0;
    self.finishedCount = 0;
    [self.manager cancelAll];
}

@end
