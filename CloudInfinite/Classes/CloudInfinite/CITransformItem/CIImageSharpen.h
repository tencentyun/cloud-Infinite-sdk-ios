//
//  CIImageSharpen.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CITransformActionProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CIImageSharpen : NSObject<CITransformActionProtocol>

/// 图片锐化功能
/// @param sharpen 为锐化参数值，取值范围为10 - 300间的整数。参数值越大，锐化效果越明显。（推荐使用70）
- (instancetype)initWithSharpe:(CGFloat)sharpen;
@end

NS_ASSUME_NONNULL_END
