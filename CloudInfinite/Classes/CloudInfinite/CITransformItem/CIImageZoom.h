//
//  CIImageZoom.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CITransformActionProtocol.h"
#import "CloudInfiniteEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIImageZoom : NSObject <CITransformActionProtocol>


/// 指定宽高缩放
/// @param width 宽度
/// @param height 高度
/// @param type 缩放类型 详细见：ScaleType
-(instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height scaleType:(ScaleType)type;

/// 百分比缩放
/// @param percent 缩放比例1-100
/// @param type 见ScalePercentType 枚举
-(instancetype)initWithPercent:(CGFloat)percent scaleType:(ScalePercentType)type;

/// 等比缩放图片，缩放后的图像，总像素数量不超过 Area
/// @param area 总像素数量
-(instancetype)initWithArea:(CGFloat)area;
@end

NS_ASSUME_NONNULL_END
