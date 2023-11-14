//
//  CIResponsiveTransformation.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CITransformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIResponsiveTransformation : CITransformation


/// 图片自适应控件大小
/// @param view 图片控件
/// @param scaleType 缩放类型
- (instancetype)initWithView:(UIView *)view scaleType:(ScaleType)scaleType;

@end

NS_ASSUME_NONNULL_END
