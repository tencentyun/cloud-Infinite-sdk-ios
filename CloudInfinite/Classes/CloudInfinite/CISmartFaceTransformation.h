//
//  SmartFaceTransformation.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import "CIResponsiveTransformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CISmartFaceTransformation : CIResponsiveTransformation

/// 基于图片中的人脸 自适应图片控件尺寸
/// @param view 图片控件
- (instancetype)initWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
