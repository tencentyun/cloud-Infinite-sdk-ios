//
//  CIGetObjectRequest.h
//  CloudInfinite
//
//  Created by garenwang on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <QCloudCore/QCloudCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface CIGetObjectRequest : QCloudBizHTTPRequest

@property (strong, nonatomic,readonly) NSURL *url;
- (instancetype)initWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
