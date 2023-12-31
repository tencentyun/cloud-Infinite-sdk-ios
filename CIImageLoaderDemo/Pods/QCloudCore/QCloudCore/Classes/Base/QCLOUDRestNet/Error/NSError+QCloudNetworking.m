//
//  NSError+QCloudNetworking.m
//  QCloudNetworking
//
//  Created by tencent on 16/2/19.
//  Copyright © 2016年 QCloudTernimalLab. All rights reserved.
//

#import "NSError+QCloudNetworking.h"
#import "NSObject+QCloudModel.h"
NSString *const kQCloudNetworkDomain = @"com.tencent.qcloud.networking";
NSString *const kQCloudNetworkErrorObject = @"kQCloudNetworkErrorObject";
@implementation NSError (QCloudNetworking)

+ (NSError *)qcloud_errorWithCode:(int)code message:(NSString *)message infos:(NSDictionary *)infos{
    message = message ? message : @"未知错误!";
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    paramaters[NSLocalizedDescriptionKey] = message;
    for (NSString *key in infos.allKeys) {
        paramaters[key] = infos[key];
    }
    NSError *error = [NSError errorWithDomain:kQCloudNetworkDomain code:code userInfo:[paramaters copy]];
    return error;
}

+ (NSError *)qcloud_errorWithCode:(int)code message:(NSString *)message {
    message = message ? message : @"未知错误!";
    NSError *error = [NSError errorWithDomain:kQCloudNetworkDomain code:code userInfo:@{ NSLocalizedDescriptionKey : message }];
    return error;
}

+ (BOOL)isNetworkErrorAndRecoverable:(NSError *)error {
    static NSSet *kQCloudNetworkNotRecoverableCode;
    static dispatch_once_t onceToken;
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        switch (error.code) {
            case NSURLErrorCancelled:
            case NSURLErrorBadURL:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
            case NSURLErrorCannotLoadFromNetwork:
                return NO;

            default:
                return YES;
        }
    }
    if ([error.domain isEqualToString:kQCloudNetworkDomain]) {
        if (error.userInfo && error.userInfo[@"Code"]) {
            NSString *serverCode = error.userInfo[@"Code"];
            if ([serverCode isEqualToString:@"InvalidDigest"] || [serverCode isEqualToString:@"BadDigest"] ||
                [serverCode isEqualToString:@"InvalidSHA1Digest"] || [serverCode isEqualToString:@"RequestTimeOut"]) {
                return YES;
            }
        }
    }

    return NO;
}

@end

@implementation QCloudCommonNetworkError

+ (NSError *)toError:(NSDictionary *)userInfo {
    NSNumber *code = [userInfo objectForKey:@"code"];
    if (!code) {
        return [NSError qcloud_errorWithCode:QCloudNetworkErrorUnsupportOperationError message:@"内容错误，无法从返回的错误信息中解析内容"];
    }
    int errorCode = (int)[code intValue];
    NSMutableDictionary *info = [NSMutableDictionary new];
    QCloudCommonNetworkError *object = [self qcloud_modelWithDictionary:userInfo];

    NSString *message = object.message ?: @"未知错误!";
    info[NSLocalizedDescriptionKey] = message;
    NSError *error = [NSError errorWithDomain:kQCloudNetworkDomain
                                         code:errorCode
                                     userInfo:@{ NSLocalizedDescriptionKey : message, kQCloudNetworkErrorObject : object }];
    return error;
}

@end
