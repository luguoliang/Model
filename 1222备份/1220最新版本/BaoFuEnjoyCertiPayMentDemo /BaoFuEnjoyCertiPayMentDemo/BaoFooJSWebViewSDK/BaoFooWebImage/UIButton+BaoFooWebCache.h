/*
 * This file is part of the BaoFooWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "BaoFooWebImageCompat.h"
#import "BaoFooWebImageManager.h"

/**
 * Integrates BaoFooWebImage async downloading and caching of remote images with UIButtonView.
 */
@interface UIButton (BaoFooWebCache)

/**
 * Get the current image URL.
 */
- (NSURL *)bf_currentImageURL;

/**
 * Get the image URL for a control state.
 * 
 * @param state Which state you want to know the URL for. The values are described in UIControlState.
 */
- (NSURL *)bf_imageURLForState:(UIControlState)state;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url   The url for the image.
 * @param state The state that uses the specified title. The values are described in UIControlState.
 */
- (void)bf_setImageWithURL:(NSURL *)url forState:(UIControlState)state;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see bf_setImageWithURL:placeholderImage:options:
 */
- (void)bf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see BaoFooWebImageOptions for the possible values.
 */
- (void)bf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)bf_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(BaoFooWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)bf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(BaoFooWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see BaoFooWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)bf_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options completed:(BaoFooWebImageCompletionBlock)completedBlock;

/**
 * Set the backgroundImageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url   The url for the image.
 * @param state The state that uses the specified title. The values are described in UIControlState.
 */
- (void)bf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state;

/**
 * Set the backgroundImageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see bf_setImageWithURL:placeholderImage:options:
 */
- (void)bf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

/**
 * Set the backgroundImageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see BaoFooWebImageOptions for the possible values.
 */
- (void)bf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options;

/**
 * Set the backgroundImageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)bf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(BaoFooWebImageCompletionBlock)completedBlock;

/**
 * Set the backgroundImageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param state          The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)bf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(BaoFooWebImageCompletionBlock)completedBlock;

/**
 * Set the backgroundImageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see BaoFooWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache of from the network.
 *                       The forth parameter is the original image url.
 */
- (void)bf_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options completed:(BaoFooWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current image download
 */
- (void)bf_cancelImageLoadForState:(UIControlState)state;

/**
 * Cancel the current backgroundImage download
 */
- (void)bf_cancelBackgroundImageLoadForState:(UIControlState)state;

@end


@interface UIButton (WebCacheDeprecated)

- (NSURL *)currentImageURL __deprecated_msg("Use `bf_currentImageURL`");
- (NSURL *)imageURLForState:(UIControlState)state __deprecated_msg("Use `bf_imageURLForState:`");

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state __deprecated_msg("Method deprecated. Use `bf_setImageWithURL:forState:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder __deprecated_msg("Method deprecated. Use `bf_setImageWithURL:forState:placeholderImage:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options __deprecated_msg("Method deprecated. Use `bf_setImageWithURL:forState:placeholderImage:options:`");

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(BaoFooWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `bf_setImageWithURL:forState:completed:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(BaoFooWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `bf_setImageWithURL:forState:placeholderImage:completed:`");
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options completed:(BaoFooWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `bf_setImageWithURL:forState:placeholderImage:options:completed:`");

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state __deprecated_msg("Method deprecated. Use `bf_setBackgroundImageWithURL:forState:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder __deprecated_msg("Method deprecated. Use `bf_setBackgroundImageWithURL:forState:placeholderImage:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options __deprecated_msg("Method deprecated. Use `bf_setBackgroundImageWithURL:forState:placeholderImage:options:`");

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(BaoFooWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `bf_setBackgroundImageWithURL:forState:completed:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(BaoFooWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `bf_setBackgroundImageWithURL:forState:placeholderImage:completed:`");
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(BaoFooWebImageOptions)options completed:(BaoFooWebImageCompletedBlock)completedBlock __deprecated_msg("Method deprecated. Use `bf_setBackgroundImageWithURL:forState:placeholderImage:options:completed:`");

- (void)cancelCurrentImageLoad __deprecated_msg("Use `bf_cancelImageLoadForState:`");
- (void)cancelBackgroundImageLoadForState:(UIControlState)state __deprecated_msg("Use `bf_cancelBackgroundImageLoadForState:`");

@end
