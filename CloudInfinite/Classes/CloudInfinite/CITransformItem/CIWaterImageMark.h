//
//  CIWaterImageMark.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CloudInfiniteEnum.h"
#import "CITransformActionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

//当 gravity 参数设置为 center 时，dx、dy 参数无效。
//当 gravity 参数设置为 north 或 south 时，dx 参数无效（水印会水平居中）。
//当 gravity 参数设置为 west 或 east 时，dy 参数无效（水印会垂直居中）。

@interface CIWaterImageMark : NSObject<CITransformActionProtocol>

/// 图片水印
/// @param imageUrl 水印图片地址
/// @param gravity 文字水印位置，九宫格位置（参考九宫格方位图 ），默认值 SouthEast
/// @param dx 水平（横轴）边距，单位为像素，缺省值为0
/// @param dy 垂直（纵轴）边距，单位为像素，默认值为0
/// @param blogo 水印图适配功能，适用于水印图尺寸过大的场景（如水印墙）。共有两种类型：
///              当 blogo 设置为1时，水印图会被缩放至与原图相似大小后添加
///              当 blogo 设置为2时，水印图会被直接裁剪至与原图相似大小后添加
- (instancetype)initWithImageUrl:(NSString *)imageUrl
                         gravity:(CloudInfiniteGravity)gravity
                              dx:(CGFloat)dx
                              dy:(CGFloat)dy
                           blogo:(CIWaterImageMarkBlogoEnum)blogo;
@end

NS_ASSUME_NONNULL_END
