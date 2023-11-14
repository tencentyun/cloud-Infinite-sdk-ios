//
//  CIQualityDataUploader.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import "CIQualityDataUploader.h"
#define CISuppressPerformSelectorLeakWarning(Stuff)                                                                   \
    do {                                                                                                            \
        _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff; \
        _Pragma("clang diagnostic pop")                                                                             \
    } while (0)

NSString *const kCIAppKey = @"0IOS055MMNMS4F5C";

NSString * const KEvent_key_decode = @"decode";
NSString * const Kerror_code = @"error_code";
NSString * const Kdecode_success = @"decode_success";
NSString * const Kdecode_width = @"decode_width";
NSString * const Kdecode_height = @"decode_height";
NSString * const Kdecode_x = @"decode_x";
NSString * const Kdecode_y = @"decode_y";
NSString * const Kdecode_sample = @"decode_sample";
NSString * const Kdecode_duration = @"decode_duration";
NSString * const Kdata_size = @"data_size";
NSString * const Kimage_format = @"image_format";
NSString * const Kerror_message = @"error_message";
NSString * const Kanimation = @"animation";
NSString * const Kdecode_index = @"decode_index";
NSString * const Kanimation_count = @"animation_count";
NSString * const Kdecode_target_format = @"decode_target_format";
NSString * const Kdecode_sdk_version_name = @"decode_sdk_version_name";
NSString * const Kdecode_sdk_version_code = @"decode_sdk_version_code";
NSString * const Koriginal_width = @"original_width";
NSString * const Koriginal_height = @"original_height";

@implementation CIQualityDataUploader

+ (void)startWithAppkey{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"BeaconReport");
        if (cls) {
        
            CISuppressPerformSelectorLeakWarning(id report = [cls performSelector:NSSelectorFromString(@"sharedInstance")];
                                               [report performSelector:NSSelectorFromString(@"startWithAppkey:config:") withObject:kCIAppKey withObject:nil];

            );
        } else {
            
        }
    });
}

+ (void)startReportSuccessEventKey:(NSString *)eventKey paramters:(NSDictionary *)paramter{
    [self startWithAppkey];
    NSInteger num = arc4random_uniform(10);
    // 成功事件采样率百分之十
    if(num == 5){
        [self startReportWithEventKey:eventKey appkey:kCIAppKey paramters:paramter];
    }
}
+ (void)startReportFailureEventKey:(NSString *)eventKey paramters:(NSDictionary *)paramter{
    [self startWithAppkey];
    [self startReportWithEventKey:eventKey appkey:kCIAppKey paramters:paramter];
}


+ (void)startReportWithEventKey:(NSString *)eventKey appkey:(NSString *)appkey paramters:(NSDictionary *)paramter {

    NSMutableDictionary * mparams = [paramter mutableCopy];
    [mparams setObject:@"1.5.1" forKey:@"decode_sdk_version_code"];
    [mparams setObject:@"1.5.1" forKey:@"decode_sdk_version_name"];
    paramter = [mparams copy];
    Class cls = NSClassFromString(@"BeaconReport");
    if (cls) {
      Class eventCls = NSClassFromString(@"BeaconEvent" );
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id eventObj = [eventCls performSelector:NSSelectorFromString(@"new")];
        if(appkey){
             [eventObj performSelector:NSSelectorFromString(@"setAppKey:") withObject:appkey];

         }
        [eventObj performSelector:NSSelectorFromString(@"setCode:") withObject:eventKey];
        [eventObj performSelector:NSSelectorFromString(@"setParams:") withObject:paramter ? paramter : @{}];
        id beaconInstance = [cls performSelector:NSSelectorFromString(@"sharedInstance")];
        
        [beaconInstance performSelector:NSSelectorFromString(@"reportEvent:") withObject:eventObj];
#pragma clang diagnostic pop
    }
}
@end
