//
//  CIDownloaderConfig.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/4.
//

#import <Foundation/Foundation.h>
#import "CloudInfinite.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIDownloaderConfig : NSObject

@property (nonatomic,strong,readonly)NSMutableDictionary * tpgRegularExpressions;

@property(nonatomic,strong,readonly)NSMutableArray * excloudeRegularExpressions;

+ (instancetype) sharedConfig;


/// 添加一个正则表达式，该正则表达式可以匹配的图片链接，请求TPG格式图片
/// @param regularStr 正则表达式
/// @param type 请求tpg格式图片类型
-(void)addTPGRegularExpress:(NSString *)regularStr paramsType:(CILoadTypeEnum)type;

/// 排除一个正则表达式，该正则表达式可以匹配的图片链接，不请求TPG
/// @param regularStr 正则表达式
-(void)addExcloudeTPGRegularExpress:(NSString *)regularStr;
@end

NS_ASSUME_NONNULL_END
