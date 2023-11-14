//
//  CloudInfiniteTools.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/11.
//

#import <Foundation/Foundation.h>
#import "CloudInfiniteEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CloudInfiniteTools : NSObject


/// 图片格式转化字符串
/// @param format 图片格式枚举
+(NSString *)imageTypeToString:(CIImageFormat )format;


/// 水印位置转化字符串
/// @param gravity 水印位置
+ (NSString *)gravityToString:(CloudInfiniteGravity)gravity;


/// 颜色转化字符串
/// @param color 颜色对象
+ (NSString *)colorToString:(UIColor *)color;


/// 字符串安全base64编码
/// @param string 字符串
+ (NSString *)base64DecodeString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
