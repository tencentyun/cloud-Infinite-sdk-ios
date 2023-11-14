//
//  CITPGImageRequest.h
//  CloudInfinite
//
//  Created by garenwang on 2020/7/14.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import <QCloudCore/QCloudCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIImageRequest : QCloudHTTPRequest


/// 请求图片request
/// @param url 图片链接
/// @param customHeader 请求头
-(instancetype)initWithImageUrl:(NSURL *)url andHeader:(nullable NSString *)customHeader;

@end

NS_ASSUME_NONNULL_END
