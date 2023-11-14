//
//  UIImageView+TPG.h
//  CloudInfinite
//
//  Created by garenwang on 2020/7/10.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TPGImageViewLoadComplete)(NSData * _Nullable data,
                                        UIImage * _Nullable image,
                                        NSError * _Nullable error);

@interface UIImageView (TPG)

/// 加载本地文件
/// @param fileUrl 本地文件链接
/// @param complete 加载完成回调
-(void)setTpgImageWithPath:(NSURL *)fileUrl
              loadComplete:(nullable TPGImageViewLoadComplete)complete;

/// 加载图片data数据
/// @param imageData 图片data格式数据
/// @param complete 加载完成回调
-(void)setTpgImageWithData:(NSData *)imageData
              loadComplete:(nullable TPGImageViewLoadComplete)complete;

@end

NS_ASSUME_NONNULL_END

