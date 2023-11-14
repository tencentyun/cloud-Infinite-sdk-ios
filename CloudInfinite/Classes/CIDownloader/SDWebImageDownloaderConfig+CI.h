//
//  SDWebImageDownloaderConfig+CI.h
//  CloudInfinite
//
//  Created by garenwang on 2023/3/21.
//

#import <SDWebImage/SDWebImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface SDWebImageDownloaderConfig (CI)

/// 是否使用quic
@property (nonatomic, assign) BOOL enableQuic;

@end

NS_ASSUME_NONNULL_END
