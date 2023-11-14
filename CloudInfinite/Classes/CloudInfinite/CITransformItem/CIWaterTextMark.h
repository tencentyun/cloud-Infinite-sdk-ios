//
//  CIWaterTextMark.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CITransformActionProtocol.h"
#import "CloudInfiniteEnum.h"

//当 gravity 参数设置为 center 时，dx、dy 参数无效。
//当 gravity 参数设置为 north 或 south 时，dx 参数无效（水印会水平居中）。
//当 gravity 参数设置为 west 或 east 时，dy 参数无效（水印会垂直居中）。

NS_ASSUME_NONNULL_BEGIN
@interface CIWaterTextMark : NSObject<CITransformActionProtocol>

/// waterMark
/// @param text 水印内容
/// @param font 水印字体
/// @param color 字体颜色，默认值为 #3D3D3D
/// @param dissolve 文字透明度，取值1 - 100 ，默认90
/// @param gravity 文字水印位置，默认值 SouthEast
/// @param dx 水平（横轴）边距，单位为像素，缺省值为0
/// @param dy 垂直（纵轴）边距，单位为像素，默认值为0
/// @param batch 平铺水印功能，可将文字水印平铺至整张图片。当 batch 设置为1时，开启平铺水印功能
/// @param degree 文字水印的旋转角度设置，取值范围为0 - 360，默认0
- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
                   textColor:(UIColor *)color
                    dissolve:(NSInteger)dissolve
                     gravity:(CloudInfiniteGravity)gravity
                          dx:(CGFloat)dx
                          dy:(CGFloat)dy
                       batch:(BOOL)batch
                      degree:(NSInteger)degree;

@end

NS_ASSUME_NONNULL_END
