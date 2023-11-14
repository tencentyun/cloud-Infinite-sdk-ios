//
//  CITransformation.h
//  CloudInfinite
//
//  Created by garenwang on 2020/7/23.
//

#import <Foundation/Foundation.h>
#import "CIWaterTextMark.h"
#import "CITransformActionProtocol.h"
@class CIImageLoadRequest;
NS_ASSUME_NONNULL_BEGIN



@interface CITransformation : NSObject

/// 当处理参数中携带此参数时，针对文件过大、参数超限等导致处理失败的场景，会直接返回原图而不报错
@property(nonatomic,assign)BOOL ignoreError;

@property(nonatomic,assign,readonly)BOOL autoSetAveColor;

@property(nonatomic,strong,readonly)NSMutableArray <id<CITransformActionProtocol>> * transformArrays;

#pragma mark 格式转换

/// 格式转换：
/// @param format 目标缩略图的图片格式可为：jpg，bmp，gif，png，webp，yjpeg 等，其中 yjpeg 为数据万象针对 jpeg 格式进行的优化，本质为 jpg 格式；缺省为原图格式。
-(void)setFormatWith:(CIImageFormat)format;

/// 格式转换：
/// @param format 目标缩略图的图片格式可为：jpg，bmp，gif，png，webp，yjpeg 等，其中 yjpeg 为数据万象针对 jpeg 格式进行的优化，本质为 jpg 格式；缺省为原图格式。
/// @param options 默认以header的方式拼接参数，如果出了格式转换还有其他操作，则header会失效，则自动转为urlfooter的方式拼接参数
-(void)setFormatWith:(CIImageFormat)format options:(CILoadTypeEnum)options;

/// gif 格式优化：只针对原图为 gif 格式，对 gif 图片格式进行的优化，降帧降颜色。分为以下两种情况：
/// FrameNumber=1，则按照默认帧数30处理，如果图片帧数大于该帧数则截取。
/// FrameNumber 取值( 1,100 ]，则将图片压缩到指定帧数 （FrameNumber）。
-(void)setCgif:(NSInteger)cgif;

/// 输出为渐进式 jpg 格式。Mode 可为0或1。
/// @param interlace 0：表示不开启渐进式；1：表示开启渐进式。该参数仅在输出图片格式为 jpg 格式时有效。如果输出非 jpg 图片格式，会忽略该参数，默认值0。
-(void)setInterlace:(BOOL)interlace;

#pragma --mark 图片缩放

/// 百分比缩放
/// @param percent 缩放比例1-100
/// @param type 见ScalePercentType 枚举
-(void)setZoomWithPercent:(CGFloat)percent scaleType:(ScalePercentType)type;

/// 指定宽高缩放
/// @param width 宽度
/// @param height 高度
/// @param type 缩放类型 详细见：ScaleType
-(void)setZoomWithWidth:(CGFloat)width height:(CGFloat)height scaleType:(ScaleType)type;

/// 等比缩放图片，缩放后的图像，总像素数量不超过 Area
/// @param area 总像素数量
-(void)setZoomWithArea:(CGFloat)area;


#pragma --mark 图片剪裁

/// 普通裁剪
/// @param width 指定目标图片的宽为 width
/// @param height 指定目标图片的高为 height
/// @param x 相对于图片左上顶点水平向右偏移 dx
/// @param y 相对于图片左上顶点水平向下偏移 dy
-(void)setCutWithWidth:(CGFloat)width height:(CGFloat)height dx:(CGFloat)x dy:(CGFloat)y;

/// 内切圆裁剪
/// @param radius 内切圆裁剪功能，radius 是内切圆的半径，取值范围为大于0且小于原图最小边一半的整数。内切圆的圆心为图片的中心。图片格式为 gif 时，不支持该参数。
-(void)setCutWithIRadius:(CGFloat)radius;

/// 圆角裁剪
/// @param radius 圆角裁剪功能，radius 为图片圆角边缘的半径，取值范围为大于0且小于原图最小边一半的整数。圆角与原图边缘相切。图片格式为 gif 时，不支持该参数。
-(void)setCutWithRRadius:(CGFloat)radius;

/// 人脸智能裁剪
/// @param width 宽度。
/// @param height 高度。
-(void)setCutWithScrop:(CGFloat)width height:(CGFloat)height;

/// 缩放裁剪 如果指定某个维度不变时，传0即可；
/// @param width 指定目标图片宽度为 Width
/// @param height 指定目标图片高度为 Height
-(void)setCutWithCrop:(CGFloat)width height:(CGFloat)height;


/// 缩放裁剪 如果指定某个维度不变时，传0即可；
/// @param width 指定目标图片宽度为 Width
/// @param height 指定目标图片高度为 Height
/// @param gravity 在进行缩放裁剪操作时，您也可以使用 gravity 参数指定操作的起点位置
-(void)setCutWithCrop:(CGFloat)width height:(CGFloat)height gravity:(CloudInfiniteGravity)gravity;

#pragma --mark 图片旋转

/// 普通旋转：图片顺时针旋转角度，取值范围0 - 360 ，默认不旋转。
/// @param degree 旋转角度，取值范围0 - 360。
-(void)setRotateWith:(CGFloat)degree;

/// 自适应旋转：根据原图 EXIF 信息将图片自适应旋转回正。
-(void)setRotateAutoOrient;

#pragma --mark 高斯模糊


/// 高斯模糊
/// @param bRadius 模糊半径，取值范围为1 - 50
/// @param sigma 正态分布的标准差，必须大于0
-(void)setBlurRadius:(CGFloat)bRadius sigma:(CGFloat)sigma;

#pragma --mark 锐化

/// 图片锐化功能
/// @param sharpen 为锐化参数值，取值范围为10 - 300间的整数。参数值越大，锐化效果越明显。（推荐使用70）
- (void)setSharpenWith:(CGFloat)sharpen;

#pragma --mark 水印

/// 文字水印
/// @param text 水印内容
/// @param font 水印字体
/// @param color 字体颜色，默认值为 #3D3D3D
/// @param dissolve 文字透明度，取值1 - 100 ，默认90
/// @param gravity 文字水印位置，默认值 SouthEast
/// @param dx 水平（横轴）边距，单位为像素，缺省值为0
/// @param dy 垂直（纵轴）边距，单位为像素，默认值为0
/// @param batch 平铺水印功能，可将文字水印平铺至整张图片。当 batch 设置为1时，开启平铺水印功能
/// @param degree 文字水印的旋转角度设置，取值范围为0 - 360，默认0
- (void)setWaterMarkText:(NSString *)text
                    font:(UIFont * _Nullable )font
               textColor:(UIColor * _Nullable)color
                dissolve:(NSInteger)dissolve
                 gravity:(CloudInfiniteGravity)gravity
                      dx:(CGFloat)dx
                      dy:(CGFloat)dy
                   batch:(BOOL)batch
                  degree:(CGFloat)degree;

/// 图片水印
/// @param imageUrl 水印图片地址
/// @param gravity 文字水印位置，九宫格位置（参考九宫格方位图 ），默认值 SouthEast
/// @param dx 水平（横轴）边距，单位为像素，缺省值为0
/// @param dy 垂直（纵轴）边距，单位为像素，默认值为0
/// @param blogo 水印图适配功能，适用于水印图尺寸过大的场景（如水印墙）。共有两种类型：
///              当 blogo 设置为1时，水印图会被缩放至与原图相似大小后添加
///              当 blogo 设置为2时，水印图会被直接裁剪至与原图相似大小后添加
- (void)setWaterMarkWithImageUrl:(NSString *)imageUrl
                         gravity:(CloudInfiniteGravity)gravity
                              dx:(CGFloat)dx
                              dy:(CGFloat)dy
                           blogo:(CIWaterImageMarkBlogoEnum)blogo;

#pragma --mark 质量变换

/// 构造一个质量变换模型
/// @param quality 图片的质量，取值范围0 - 100
/// @param type 件枚举详细说明
- (void)setQualityWithQuality:(NSInteger)quality type:(CIQualityChangeEnum)type;

#pragma --mark 获取图片主色调

/// 获取当前图片主题色并且设置给当前控件背景
/// @param autoSet yes 自动设置 no不设置
-(void)setViewBackgroudColorWithImageAveColor:(BOOL)autoSet;

#pragma --mark 去除图片元信息
/// 去除图片元信息，包括 exif 信息。
-(void)setImageStrip;

@end



NS_ASSUME_NONNULL_END
