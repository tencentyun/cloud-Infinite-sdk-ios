//
//  AVIFDecoderHelper.h
//  CloudInfinite
//
//  Created by garenwang on 2021/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVIFDecoderHelper : NSObject

/// 将图片Data数据转换为可显示的image，支持AVIF图和普通图
/// @param imageData 图片data数据
/// @param error 转码错误信息
+ (UIImage *)imageDataDecode:(NSData *)imageData error:(NSError * __autoreleasing*)error;


/// 判断是否为AVIF图
/// @param data 图片Data数据
+ (BOOL)isAVIFImage:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
