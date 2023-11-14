//
//  CIImageDownloader.h
//  CloudInfinite
//
//  Created by garenwang on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import "SDImageLoader.h"
#import "SDWebImageDownloaderConfig+CI.h"
#import "QCloudURLSessionTaskData.h"
NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^CanUseCIImageDownloader)(NSURL * url,SDWebImageOptions options,SDWebImageContext * context);

typedef BOOL(^CanUseRetryWhenError)(QCloudURLSessionTaskData * task,NSError * error);

@interface CIImageDownloader : NSObject

/// 加载图片最大并发数
@property (nonatomic, assign) int maxConcurrentCount;

/// 加载图片并发数
@property (nonatomic, assign) int customConcurrentCount;

/// 是否开启quic
@property (nonatomic, assign) BOOL enableQuic;

/// 设置请求超时时间 默认30s
@property (nonatomic, assign) NSInteger timeoutInterval;

/// 最大重试次数
@property (nonatomic, assign) int retryCount;

/// 重试间隔时间
@property (nonatomic, assign) int sleepTime;

/// 配置是否可用CIImageDownloader来加载图片，可以通过后台接口来动态控制。
@property (nonatomic,strong)CanUseCIImageDownloader canUseCIImageDownloader;


/// 是否需要重试
@property (nonatomic,strong)CanUseRetryWhenError canUseRetryWhenError;

/// 指定哪些host使用quic，若不指定并开启quic，则认为CIImageDownloader全部走quic
@property (nonatomic, strong)NSArray * quicWhiteList;

+ (nonnull instancetype)sharedDownloader;

/// 取消所有下载
- (void)cancelAllDownloads;


- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field;

- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field;

@end

@interface CIImageDownloader (SDImageLoader) <SDImageLoader>

@end

NS_ASSUME_NONNULL_END
