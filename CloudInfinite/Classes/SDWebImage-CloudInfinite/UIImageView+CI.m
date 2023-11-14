//
//  UIImageView+CI.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/3.
//

#import "UIImageView+CI.h"
#import "CIWebImageDownloader.h"

@implementation UIImageView (CI)

- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                transformation:(nullable CITransformation *)transform{
    [self sd_CI_setImageWithURL:url placeholderImage:nil transformation:transform];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                transformation:(nullable CITransformation *)transform{
    [self sd_CI_setImageWithURL:url placeholderImage:placeholder options:0 transformation:transform];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform{
    [self sd_CI_setImageWithURL:url placeholderImage:placeholder options:options transformation:transform context:nil];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                       context:(nullable SDWebImageContext *)context{
    [self sd_CI_setImageWithURL:url placeholderImage:placeholder options:options transformation:transform context:context progress:nil completed:nil];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                transformation:(nullable CITransformation *)transform
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setImageWithURL:url placeholderImage:nil transformation:transform completed:completedBlock];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                transformation:(nullable CITransformation *)transform
                     completed:(nullable SDExternalCompletionBlock)completedBlock {
    
    [self sd_CI_setImageWithURL:url placeholderImage:placeholder options:0 transformation:transform completed:completedBlock];
    
}

- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setImageWithURL:url placeholderImage:placeholder options:options transformation:transform progress:nil completed:completedBlock];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                      progress:(nullable SDImageLoaderProgressBlock)progressBlock
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setImageWithURL:url placeholderImage:placeholder options:options transformation:transform context:nil progress:progressBlock completed:completedBlock];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                       context:(nullable SDWebImageContext *)context
                      progress:(nullable SDImageLoaderProgressBlock)progressBlock
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_internalSetImageWithURL:url placeholderImage:placeholder options:options transformation:transform  context:context setImageBlock:nil progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
    
}

@end
