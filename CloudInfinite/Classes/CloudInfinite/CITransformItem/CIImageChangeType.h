//
//  CIImageChangeType.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CloudInfiniteEnum.h"
#import "CITransformActionProtocol.h"
NS_ASSUME_NONNULL_BEGIN


@interface CIImageChangeType : NSObject<CITransformActionProtocol>

/// 格式转换：
/// @param format 目标缩略图的图片格式可为：jpg，bmp，gif，png，webp，yjpeg 等，其中 yjpeg 为数据万象针对 jpeg 格式进行的优化，本质为 jpg 格式；缺省为原图格式。
/// @param options 默认以header的方式拼接参数，如果出了格式转换还有其他操作，则header会失效，则自动转为urlfooter的方式拼接参数
-(instancetype)initWithFormat:(CIImageFormat)format options:(CILoadTypeEnum)options;


/// gif 格式优化：只针对原图为 gif 格式，对 gif 图片格式进行的优化，降帧降颜色。分为以下两种情况：
/// FrameNumber=1，则按照默认帧数30处理，如果图片帧数大于该帧数则截取。
/// FrameNumber 取值( 1,100 ]，则将图片压缩到指定帧数 （FrameNumber）。
-(instancetype)initWithCgif:(NSInteger)cgif;

/// 输出为渐进式 jpg 格式。Mode 可为0或1。
/// @param interlace 0：表示不开启渐进式；1：表示开启渐进式。该参数仅在输出图片格式为 jpg 格式时有效。如果输出非 jpg 图片格式，会忽略该参数，默认值0。
-(instancetype)initWithInterlace:(BOOL)interlace;


/// 是否只有header有参数；
-(BOOL)isOnlyHeader;


/// 将header转化为parturl
-(NSString *)buildPartUrlWithHeader;
@end

NS_ASSUME_NONNULL_END
