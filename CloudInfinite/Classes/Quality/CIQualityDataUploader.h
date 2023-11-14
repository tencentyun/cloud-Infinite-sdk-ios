//
//  CIQualityDataUploader.h
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//

#import <Foundation/Foundation.h>

@interface CIQualityDataUploader : NSObject

// 事件key
FOUNDATION_EXTERN NSString *const KEvent_key_decode;
// 错误码
FOUNDATION_EXTERN NSString *const Kerror_code;
// 解码是否成功
FOUNDATION_EXTERN NSString *const Kdecode_success;
// 解码宽度
FOUNDATION_EXTERN NSString *const Kdecode_width;
// 解码高度
FOUNDATION_EXTERN NSString *const Kdecode_height;
// 解码x坐标
FOUNDATION_EXTERN NSString *const Kdecode_x;
// 解码y坐标
FOUNDATION_EXTERN NSString *const Kdecode_y;
// 解码缩放比
FOUNDATION_EXTERN NSString *const Kdecode_sample;
// 解码耗时
FOUNDATION_EXTERN NSString *const Kdecode_duration;
// 数据大小
FOUNDATION_EXTERN NSString *const Kdata_size;
// 图片类型 tpg、avif等
FOUNDATION_EXTERN NSString *const Kimage_format;
// 错误信息
FOUNDATION_EXTERN NSString *const Kerror_message;
// 是否是动图
FOUNDATION_EXTERN NSString *const Kanimation;
// 解码动图帧索引
FOUNDATION_EXTERN NSString *const Kdecode_index;
// 动图总帧数
FOUNDATION_EXTERN NSString *const Kanimation_count;
// 图片解码目标格式
FOUNDATION_EXTERN NSString *const Kdecode_target_format;

FOUNDATION_EXTERN NSString *const Kdecode_sdk_version_name;

FOUNDATION_EXTERN NSString *const Kdecode_sdk_version_code;
// 图片原始宽度
FOUNDATION_EXTERN NSString *const Koriginal_width;
// 图片原始高度
FOUNDATION_EXTERN NSString *const Koriginal_height;

+ (void)startReportSuccessEventKey:(NSString *)eventKey paramters:(NSDictionary *)paramter;
+ (void)startReportFailureEventKey:(NSString *)eventKey paramters:(NSDictionary *)paramter;
@end














