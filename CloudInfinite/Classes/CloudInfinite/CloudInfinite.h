//
//  CloudInfinite.h
//  CloudInfinite
//
//  Created by garenwang on 2020/7/23.
//

#import <Foundation/Foundation.h>
#import "CITransformation.h"
#import "CIImageLoadRequest.h"
#import "CISmartFaceTransformation.h"
#import "CIResponsiveTransformation.h"
NS_ASSUME_NONNULL_BEGIN

@interface CloudInfinite : NSObject


/// 异步对图片的操作转换为url参数，以及header，并且url以及header封装为CIImageLoadRequest
/// @param url 图片链接
/// @param transformation 图片的转换操作
/// @param request CIImageLoadRequest实例
-(void)requestWithBaseUrl:(NSString *)url transform:(CITransformation *)transformation request:(void (^) (CIImageLoadRequest * request)) request;


/// 同步对图片的操作转换为url参数，以及header，并且url以及header封装为CIImageLoadRequest
/// @param url 图片链接
/// @param transformation 图片的转换操作
-(CIImageLoadRequest *)requestWithBaseUrl:(NSString *)url transform:(CITransformation *)transformation;
@end

NS_ASSUME_NONNULL_END
