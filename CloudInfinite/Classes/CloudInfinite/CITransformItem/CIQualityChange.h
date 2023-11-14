//
//  CIQualityChange.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CITransformActionProtocol.h"
#import "CloudInfiniteEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIQualityChange : NSObject<CITransformActionProtocol>

/// 构造一个质量变换模型
/// @param quality 图片的质量，取值范围0 - 100
/// @param type 件枚举详细说明
- (instancetype)initWithQuality:(NSInteger)quality type:(CIQualityChangeEnum)type;

@end

NS_ASSUME_NONNULL_END
