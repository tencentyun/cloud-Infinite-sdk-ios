//
//  CIDNSLoader.h
//  CloudInfinite
//
//  Created by garenwang on 2023/3/14.
//
#import <MSDKDns_C11/MSDKDns.h>
#import <QCloudCore/QCloudCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface CIDNSLoader : NSObject<QCloudHTTPDNSProtocol>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithConfig:(DnsConfig)config;

- (NSString *)resolveDomain:(NSString *)domain;
@end

NS_ASSUME_NONNULL_END
