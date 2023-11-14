//
//  CIMemoryCache.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/5.
//

#import "CIMemoryCache.h"

static inline NSString * TPGImageAveColorCahcheKeyWithURL(NSString * url) {
    return [NSString stringWithFormat:@"TPGImage_AVE_%@",url];
}

@interface CIMemoryCache ()
@property (nonatomic,strong)NSCache * memoryCache;
@end

@implementation CIMemoryCache

+ (instancetype) sharedMemoryCache {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[CIMemoryCache alloc]init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _memoryCache = [NSCache new];
        _memoryCache.countLimit = 0;
        _memoryCache.totalCostLimit = 10 * 1024* 1024;
        _memoryCache.name = @"TPG_ImageAve_cache";
    }
    return self;
}

- (nullable NSObject *)objectForKey:(NSString *)key{
    if (key == nil) {
        return nil;
    }
    
    NSString * keyStr = TPGImageAveColorCahcheKeyWithURL(key);
    
    return [_memoryCache objectForKey:keyStr];
}
- (void)setObject:(NSObject *)obj forKey:(NSString *)key{
    if (obj == nil || key == nil) {
        return;
    }
    [_memoryCache setObject:obj forKey:TPGImageAveColorCahcheKeyWithURL(key)];
}

- (void)removeAllObjects{
    [_memoryCache removeAllObjects];
}

@end
