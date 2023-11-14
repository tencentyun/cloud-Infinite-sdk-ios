//
//  CIImageStrip.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CITransformActionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIImageStrip : NSObject<CITransformActionProtocol>


/// 腾讯云数据万象通过 imageMogr2 接口可去除图片元信息，包括 exif 信息
-(instancetype)initStrip;
@end

NS_ASSUME_NONNULL_END
