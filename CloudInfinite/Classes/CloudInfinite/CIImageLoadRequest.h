//
//  CIImageLoadRequest.h
//  CloudInfinite
//
//  Created by garenwang on 2020/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIImageLoadRequest : NSObject

/// 构建完后的url
@property (nonatomic,strong)NSURL * url;

/// 构建完后的header
@property (nonatomic,strong)NSString * header;


-(instancetype)initWithBaseURL:(NSString *)baseUrl;


/// 在图片链接后添加万象图片操作参数
/// @param partUrl 参数
-(void)addURLPart:(NSString *)partUrl;

/// 直接在链接后面拼 partUrl ，不做任何处理
-(void)appendURLPart:(NSString *)partUrl;
@end

NS_ASSUME_NONNULL_END
