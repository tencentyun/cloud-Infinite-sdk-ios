//
//  UIView+CI.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/7.
//

#import <UIKit/UIKit.h>
#import "CIDownloaderConfig.h"
#import <SDWebImage/SDWebImage.h>
NS_ASSUME_NONNULL_BEGIN

typedef NSString * _Nullable (^CILoadTPGAVIFImageErrorHandler)(NSString * url);

typedef void (^CITPGAVIFImageErrorObserver)(NSString * url,NSError * error);

@interface UIView (CI)

/// 开启或关闭 加载AVIF、TPG图片失败时加载原图兜底 默认关闭
+(void)setLoadOriginalImageWhenError:(BOOL)open;

/// 加载AVIF图片失败时加载原图兜底 是否开启
+(BOOL)isOpenLoadOriginalImageWhenError;

/// 加载TPG AVIF图失败，自定义返回原格式图片链接。
+(void)setLoadTPGAVIFImageErrorHandler:(CILoadTPGAVIFImageErrorHandler)handler;

/// 设置tpg、avif加载失败监听，获取url以及错误信息，可以用于日志上报。
+(void)setTPGAVIFImageErrorObserver:(CITPGAVIFImageErrorObserver)observser;

/// 使用UIImageView+CI / UIButton+CI 提供的方法请求tpg图片
/// @param url 图片url
/// @param placeholder 图片占位图
/// @param options SDWebImageOptions
/// @param transform 万象图片基础操作
/// @param context SDWebImageContext 请求图片上下文
/// @param setImageBlock  SDWebImageContext
/// @param progressBlock 进度
/// @param completedBlock 完成回调
- (void)sd_CI_internalSetImageWithURL:(nullable NSURL *)url
                      placeholderImage:(nullable UIImage *)placeholder
                               options:(SDWebImageOptions)options
                        transformation:(nullable CITransformation *)transform
                               context:(nullable SDWebImageContext *)context
                         setImageBlock:(nullable SDSetImageBlock)setImageBlock
                              progress:(nullable SDImageLoaderProgressBlock)progressBlock
                             completed:(nullable SDInternalCompletionBlock)completedBlock;


/// 使用正则表达式配置请求TPG ，内部主要是和sd的方法交换使用户代码无侵入的请求tpg
/// @param url 图片链接
/// @param placeholder 占位图
/// @param options SDWebImageOptions
/// @param context 请求上下文
/// @param setImageBlock setImageBlock
/// @param progressBlock 进度
/// @param completedBlock 成功回到
- (void)sd_CI_internalSetImageWithURL:(nullable NSURL *)url
                      placeholderImage:(nullable UIImage *)placeholder
                               options:(SDWebImageOptions)options
                               context:(nullable SDWebImageContext *)context
                         setImageBlock:(nullable SDSetImageBlock)setImageBlock
                              progress:(nullable SDImageLoaderProgressBlock)progressBlock
                             completed:(nullable SDInternalCompletionBlock)completedBlock;

/// 获取图片主题色并设置给当前view
/// @param urlStr 图片链接
-(void)sd_CI_preloadWithAveColor:(NSString *)urlStr;

/// 获取图片主题色并设置给当前view
/// @param urlStr 图片链接
/// @param aveColorBlock 返回颜色
-(void)sd_CI_preloadWithAveColor:(NSString *)urlStr
                 completed:(nullable void(^)(UIColor * color)) aveColorBlock;

@end

NS_ASSUME_NONNULL_END
