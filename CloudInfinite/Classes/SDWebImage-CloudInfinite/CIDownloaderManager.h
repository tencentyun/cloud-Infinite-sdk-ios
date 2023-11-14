//
//  CIDownloaderManager.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/4.
//

#import <Foundation/Foundation.h>
@class CIWebImageDownloader;

NS_ASSUME_NONNULL_BEGIN

@interface CIDownloaderManager : NSObject

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)new NS_UNAVAILABLE;

+ (instancetype) sharedManager;
-(CIWebImageDownloader *)getDownloaderWithHeader:(NSDictionary *)header;
@end

NS_ASSUME_NONNULL_END
