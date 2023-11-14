//
//  CIImageTailor.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CITransformActionProtocol.h"
#import "CloudInfiniteEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIImageTailor : NSObject<CITransformActionProtocol>


/// 普通裁剪
/// @param width 指定目标图片的宽为 width
/// @param height 指定目标图片的高为 height
/// @param x 相对于图片左上顶点水平向右偏移 dx
/// @param y 相对于图片左上顶点水平向下偏移 dy
-(instancetype)initWithCut:(CGFloat)width height:(CGFloat)height dx:(CGFloat)x dy:(CGFloat)y;

/// 内切圆裁剪
/// @param radius 内切圆裁剪功能，radius 是内切圆的半径，取值范围为大于0且小于原图最小边一半的整数。内切圆的圆心为图片的中心。图片格式为 gif 时，不支持该参数。
-(instancetype)initWithIRadius:(CGFloat)radius;


/// 圆角裁剪
/// @param radius 圆角裁剪功能，radius 为图片圆角边缘的半径，取值范围为大于0且小于原图最小边一半的整数。圆角与原图边缘相切。图片格式为 gif 时，不支持该参数。
-(instancetype)initWithRRadius:(CGFloat)radius;


/// 人脸智能裁剪
/// @param width 宽度。
/// @param height 高度。
-(instancetype)initWithScrop:(CGFloat)width height:(CGFloat)height;

/// 缩放裁剪 如果指定某个维度不变时，传0即可；
/// @param width 指定目标图片宽度为 Width
/// @param height 指定目标图片高度为 Height
/// @param gravity 详情见 CloudInfiniteGravity 枚举
-(instancetype)initWithCrop:(CGFloat)width height:(CGFloat)height gravity:(CloudInfiniteGravity) gravity;

@end

NS_ASSUME_NONNULL_END
