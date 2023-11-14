//
//  CIImageRotate.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CITransformActionProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CIImageRotate : NSObject<CITransformActionProtocol>


/// 普通旋转：图片顺时针旋转角度，取值范围0 - 360 ，默认不旋转。
/// @param degree 旋转角度，取值范围0 - 360。
-(instancetype)initWithRotate:(NSInteger)degree;

/// 自适应旋转：根据原图 EXIF 信息将图片自适应旋转回正。
- (instancetype)initWithAutoOrientWith:(BOOL)autoOrient;
@end

NS_ASSUME_NONNULL_END
