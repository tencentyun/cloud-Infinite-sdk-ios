//
//  CIGaussianBlur.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CITransformActionProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CIGaussianBlur : NSObject<CITransformActionProtocol>


/// 高斯模糊
/// @param bRadius 模糊半径，取值范围为1 - 50
/// @param sigma 正态分布的标准差，必须大于0
-(instancetype)initWithBlurRadius:(CGFloat)bRadius sigma:(CGFloat)sigma;

@end

NS_ASSUME_NONNULL_END
