//
//  UIButton+CI.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/4.
//

#import "UIButton+CI.h"

static inline NSString * CIimageOperationKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"UIButtonImageOperation%lu", (unsigned long)state];
}

static inline NSString * backgroundCIImageOperationKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"UIButtonBackgroundImageOperation%lu", (unsigned long)state];
}

@implementation UIButton (CI)

- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
                transformation:(nullable CITransformation *)transform{
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:nil options:0 transformation:transform context:nil progress:nil completed:nil];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                transformation:(nullable CITransformation *)transform{
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:placeholder options:0 transformation:transform context:nil progress:nil completed:nil];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform{
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:nil progress:nil completed:nil];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                       context:(nullable SDWebImageContext *)context{
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:context progress:nil completed:nil];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
                transformation:(nullable CITransformation *)transform
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:nil options:0 transformation:transform context:nil progress:nil completed:completedBlock];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                transformation:(nullable CITransformation *)transform
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:placeholder options:0 transformation:transform context:nil progress:nil completed:completedBlock];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:nil progress:nil completed:completedBlock];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                      progress:(nullable SDImageLoaderProgressBlock)progressBlock
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    [self sd_CI_setImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:nil progress:progressBlock completed:completedBlock];
}


- (void)sd_CI_setImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                transformation:(nullable CITransformation *)transform
                       context:(nullable SDWebImageContext *)context
                      progress:(nullable SDImageLoaderProgressBlock)progressBlock
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    
    SDWebImageMutableContext *mutableContext;
    if (context) {
        mutableContext = [context mutableCopy];
    } else {
        mutableContext = [NSMutableDictionary dictionary];
    }
    mutableContext[SDWebImageContextSetImageOperationKey] = CIimageOperationKeyForState(state);
    __weak typeof(self) weakSelf = self;
    [self sd_CI_internalSetImageWithURL:url
                        placeholderImage:placeholder
                                 options:options
                          transformation:transform
                                 context:mutableContext
                           setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setImage:image forState:state];
    }
                                progress:progressBlock
                               completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}

#pragma mark - Background Image


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                          transformation:(nullable CITransformation *)transform{
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 transformation:transform context:nil progress:nil completed:nil];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                          transformation:(nullable CITransformation *)transform{
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 transformation:transform context:nil progress:nil completed:nil];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                                 options:(SDWebImageOptions)options
                          transformation:(nullable CITransformation *)transform{
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:nil progress:nil completed:nil];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                                 options:(SDWebImageOptions)options
                          transformation:(nullable CITransformation *)transform
                                 context:(nullable SDWebImageContext *)context{
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:context progress:nil completed:nil];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                          transformation:(nullable CITransformation *)transform
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 transformation:transform context:nil progress:nil completed:completedBlock];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                          transformation:(nullable CITransformation *)transform
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 transformation:transform context:nil progress:nil completed:completedBlock];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                                 options:(SDWebImageOptions)options
                          transformation:(nullable CITransformation *)transform
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:nil progress:nil completed:completedBlock];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                                 options:(SDWebImageOptions)options
                          transformation:(nullable CITransformation *)transform
                                progress:(nullable SDImageLoaderProgressBlock)progressBlock
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    [self sd_CI_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options transformation:transform context:nil progress:progressBlock completed:completedBlock];
}


- (void)sd_CI_setBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                                 options:(SDWebImageOptions)options
                          transformation:(nullable CITransformation *)transform
                                 context:(nullable SDWebImageContext *)context
                                progress:(nullable SDImageLoaderProgressBlock)progressBlock
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    SDWebImageMutableContext *mutableContext;
    if (context) {
        mutableContext = [context mutableCopy];
    } else {
        mutableContext = [NSMutableDictionary dictionary];
    }
    mutableContext[SDWebImageContextSetImageOperationKey] = backgroundCIImageOperationKeyForState(state);
    __weak typeof(self) weakSelf = self;
    
    [self sd_CI_internalSetImageWithURL:url
                        placeholderImage:placeholder
                                 options:options
                          transformation:transform
                                 context:mutableContext
                           setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setBackgroundImage:image forState:state];
    }
                                progress:progressBlock
                               completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
    
}


@end
