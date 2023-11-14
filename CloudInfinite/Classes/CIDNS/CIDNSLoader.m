//
//  CIDNSLoader.m
//  CloudInfinite
//
//  Created by garenwang on 2023/3/14.
//

#import "CIDNSLoader.h"

@interface CIDNSLoader ()
@property(nonatomic,assign)DnsConfig config;
@end

@implementation CIDNSLoader

- (instancetype)initWithConfig:(DnsConfig)config{
    if (self = [self init]) {
        self.config = config;
        [[MSDKDns sharedInstance] initConfig:&config];
    }
    return self;
}

- (NSString *)resolveDomain:(NSString *)domain{
    __block NSString * ipAddress;
    dispatch_semaphore_t semp = dispatch_semaphore_create(0);
    [[MSDKDns sharedInstance] WGGetHostByNameAsync:domain returnIps:^(NSArray *ipsArray) {
        ipAddress = ipsArray.firstObject;
        dispatch_semaphore_signal(semp);
    }];
    dispatch_semaphore_wait(semp, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
    return ipAddress;
}
@end
