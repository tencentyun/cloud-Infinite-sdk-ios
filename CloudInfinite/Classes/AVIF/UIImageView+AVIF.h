//
//  UIImageView+AVIF.h
//  CloudInfinite
//
//  Created by garenwang on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AVIFImageViewLoadComplete)(NSData * _Nullable data,
                                        UIImage * _Nullable image,
                                        NSError * _Nullable error);

@interface UIImageView (AVIF)


/// 加载本地文件
/// @param fileUrl 本地文件链接
/// @param complete 加载完成回调
-(void)setAvifImageWithPath:(NSURL *)fileUrl
              loadComplete:(nullable AVIFImageViewLoadComplete)complete;

/// 加载图片data数据
/// @param imageData 图片data格式数据
/// @param complete 加载完成回调
-(void)setAvifImageWithData:(NSData *)imageData
              loadComplete:(nullable AVIFImageViewLoadComplete)complete;

@end

NS_ASSUME_NONNULL_END
