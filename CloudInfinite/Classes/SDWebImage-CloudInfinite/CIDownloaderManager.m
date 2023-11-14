//
//  CIDownloaderManager.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/4.
//

#import "CIDownloaderManager.h"
#import "CIWebImageDownloader.h"

@interface CIDownloaderManager ()

@property(strong,atomic)NSRecursiveLock * lock;

@property (nonatomic,strong)NSMutableDictionary <NSString *,CIWebImageDownloader * >* mDownloaderPool;
@end

@implementation CIDownloaderManager

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[CIDownloaderManager alloc]init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc]init];
    }
    return self;
}

- (NSMutableDictionary *)mDownloaderPool{
    if (_mDownloaderPool == nil) {
        _mDownloaderPool = [NSMutableDictionary new];
    }
    return _mDownloaderPool;
}

-(CIWebImageDownloader *)getDownloaderWithHeader:(NSDictionary *)header{
    if (header == nil) {
        return nil;
    }
    NSString * key = [self dictionaryToJson:header];
    
    CIWebImageDownloader * downloader = [self.mDownloaderPool objectForKey:key];
    
    if (downloader != nil) {
        return downloader;
    }
    
    [self.lock lock];
    downloader = [[CIWebImageDownloader alloc]initWithHeader:header];
    [self.mDownloaderPool setObject:downloader forKey:key];
    [self.lock unlock];
    return downloader;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
