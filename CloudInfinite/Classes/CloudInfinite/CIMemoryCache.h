//
//  CIMemoryCache.h
//  CloudInfinite
//
//  Created by garenwang on 2020/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CIMemoryCache : NSObject

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)new NS_UNAVAILABLE;

+ (instancetype) sharedMemoryCache;

- (nullable NSObject *)objectForKey:(NSString *)key;

- (void)setObject:(NSObject *)obj forKey:(NSString *)key;

- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
