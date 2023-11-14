//
//  UIButton+CI.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/4.
//

#import <UIKit/UIKit.h>
#import "UIView+CI.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CI)

- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
               transformation:(nullable CITransformation *)transform;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
             placeholderImage:(nullable UIImage *)placeholder
               transformation:(nullable CITransformation *)transform;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
             placeholderImage:(nullable UIImage *)placeholder
                      options:(SDWebImageOptions)options
               transformation:(nullable CITransformation *)transform;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
             placeholderImage:(nullable UIImage *)placeholder
                      options:(SDWebImageOptions)options
               transformation:(nullable CITransformation *)transform
                      context:(nullable SDWebImageContext *)context;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
               transformation:(nullable CITransformation *)transform
                    completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
             placeholderImage:(nullable UIImage *)placeholder
               transformation:(nullable CITransformation *)transform
                    completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
             placeholderImage:(nullable UIImage *)placeholder
                      options:(SDWebImageOptions)options
               transformation:(nullable CITransformation *)transform
                    completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
             placeholderImage:(nullable UIImage *)placeholder
                      options:(SDWebImageOptions)options
               transformation:(nullable CITransformation *)transform
                     progress:(nullable SDImageLoaderProgressBlock)progressBlock
                    completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                     forState:(UIControlState)state
             placeholderImage:(nullable UIImage *)placeholder
                      options:(SDWebImageOptions)options
               transformation:(nullable CITransformation *)transform
                      context:(nullable SDWebImageContext *)context
                     progress:(nullable SDImageLoaderProgressBlock)progressBlock
                    completed:(nullable SDExternalCompletionBlock)completedBlock;

#pragma mark - Background Image


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                         transformation:(nullable CITransformation *)transform;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(nullable UIImage *)placeholder
                         transformation:(nullable CITransformation *)transform;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(nullable UIImage *)placeholder
                                options:(SDWebImageOptions)options
                         transformation:(nullable CITransformation *)transform;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(nullable UIImage *)placeholder
                                options:(SDWebImageOptions)options
                         transformation:(nullable CITransformation *)transform
                                context:(nullable SDWebImageContext *)context;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                         transformation:(nullable CITransformation *)transform
                              completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(nullable UIImage *)placeholder
                         transformation:(nullable CITransformation *)transform
                              completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(nullable UIImage *)placeholder
                                options:(SDWebImageOptions)options
                         transformation:(nullable CITransformation *)transform
                              completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(nullable UIImage *)placeholder
                                options:(SDWebImageOptions)options
                         transformation:(nullable CITransformation *)transform
                               progress:(nullable SDImageLoaderProgressBlock)progressBlock
                              completed:(nullable SDExternalCompletionBlock)completedBlock;


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(nullable UIImage *)placeholder
                                options:(SDWebImageOptions)options
                         transformation:(nullable CITransformation *)transform
                                context:(nullable SDWebImageContext *)context
                               progress:(nullable SDImageLoaderProgressBlock)progressBlock
                              completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
