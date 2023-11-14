//
//  CIImageLoader.h
//  CloudInfinite
//
//  Created by garenwang on 2020/7/20.
//

#import <Foundation/Foundation.h>
#import "CIImageLoadRequest.h"

typedef void (^GetImageAveColorBlock)(UIColor * _Nullable color);

/**
 图片请求类，主要用于加载网络图并返回图片data数据；
 若请求普通图片，则直接使用data 转 image；
 若请求TPG图，则需要搭配使用TPGImage库，将TPG解码为JPG或者png进行显示；
 */
@class QCloudHTTPRequest;

NS_ASSUME_NONNULL_BEGIN

/**
 加载图片结果回调TGPImageView
 data:图片二进制数据
 error:请求或解码错误
 */
typedef void(^LoadImageComplete)(NSData * _Nullable data,
                                 NSError * _Nullable error);

@interface CIImageLoader : NSObject

+ (CIImageLoader*) shareLoader;

/// 加载网络TPG图
/// @param loadRequest 封装了option和图片格式的实体
/// @param complete 结果回调 返回图片data数据 如果请求失败返回错误信息
-(void)loadData:(CIImageLoadRequest*)loadRequest
   loadComplete:(nullable LoadImageComplete)complete;


/// 加载普通图
/// @param imageView 图片控件
/// @param loadRequest 封装TPG高级设置
/// @param placeHolder 占位图
/// @param complete 结果回调 返回图片data数据 如果请求失败返回错误信息
-(void)display:(UIImageView *)imageView
   loadRequest:(CIImageLoadRequest*)loadRequest
   placeHolder:(UIImage *)placeHolder
  loadComplete:(nullable LoadImageComplete)complete;


/// 获取图片主题色
/// @param view 控件
/// @param objectUrl 图片链接
/// @param aveColorBlock 成功回调
-(void)preloadWithAveColor:(UIView *)view objectUrl:(NSString *)objectUrl complete:(nullable void(^)(UIColor * color)) aveColorBlock;

@end

NS_ASSUME_NONNULL_END
