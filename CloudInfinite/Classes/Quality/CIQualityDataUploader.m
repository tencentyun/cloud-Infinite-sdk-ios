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

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self startWithAppkey];
    });
}

+ (void)startWithAppkey{
    Class cls = NSClassFromString(@"QCloudTrackService");
    Class beaconCls = NSClassFromString(@"QCloudBeaconTrackService");
    if (cls && beaconCls) {
        CISuppressPerformSelectorLeakWarning(
            id report = [cls performSelector:NSSelectorFromString(@"singleService")];
            [self trackBaseInfoToTrachCommonParams];
        );
    }
    
}

+ (void)startReportSuccessEventKey:(NSString *)eventKey paramters:(NSDictionary *)paramter{
//    [self startWithAppkey];
//    NSInteger num = arc4random_uniform(10);
//    // 成功事件采样率百分之十
//    if(num == 5){
//        [self startReportWithEventKey:eventKey appkey:kCIAppKey paramters:paramter];
//    }
}
+ (void)startReportFailureEventKey:(NSString *)eventKey paramters:(NSDictionary *)paramter{
//    [self startWithAppkey];
//    [self startReportWithEventKey:eventKey appkey:kCIAppKey paramters:paramter];
}


+ (void)trackBaseInfoToTrachCommonParams{

    NSString * productName = @"CloudInfoinite";
    NSString * sdkVersion = @"1.5.2";
    NSString * sdkVersionName = @"1.5.2";
    
    Class cls = NSClassFromString(@"QCloudTrackService");
    if (cls) {
        
        Class clsClass = NSClassFromString(@"QCloudCLSTrackService");
        NSDictionary * paramter = @{
            @"sdk_name":[NSString stringWithFormat:@"QCloud%@SDK",productName.uppercaseString], //  sdk名称,
            @"sdk_version_code":sdkVersion?:@"", //  sdk版本号,
            @"sdk_version_name":sdkVersionName?:@"", //  sdk版本名称,
            @"cls_report":clsClass != nil?@"true":@"false"
        };
        id instance = [cls performSelector:NSSelectorFromString(@"singleService")];
        SEL selector = NSSelectorFromString(@"reportSimpleDataWithEventParams:");

    
        if ([instance respondsToSelector:selector]) {
            NSMethodSignature *methodSignature = [instance methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            [invocation setArgument:&paramter atIndex:2];
            [invocation invokeWithTarget:instance];
        }
    }
}
@end
