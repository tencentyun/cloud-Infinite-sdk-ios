//
//  CIImageDownloader.m
//  CloudInfinite
//
//  Created by garenwang on 2023/5/10.
//

#import "CIImageDownloader.h"
#import "SDWebImageOperation.h"
#import "SDWebImageDownloaderConfig.h"
#import "SDWebImageDownloaderOperation.h"
#import "SDWebImageError.h"
#import "SDInternalMacros.h"
#import "QCloudHTTPRequestOperation+CI.h"
#import "CIGetObjectRequest.h"
#import "QCloudHTTPRetryHanlder.h"
#import "QCloudHTTPRetryHanlder.h"

@interface CIImageDownloader ()<QCloudHttpRetryHandlerProtocol>
@property (nonatomic,strong)NSOperationQueue * coderQueue;
@property (strong, nonatomic, nonnull) NSMapTable<NSString *, UIImage *> *imageMap;

@property (strong, nonatomic, nullable) NSMutableDictionary<NSString *, NSString *> *HTTPHeaders;
@end

@implementation CIImageDownloader

+ (nonnull instancetype)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        self.retryCount = -1;
        self.sleepTime = -1;
        [QCloudHTTPSessionManager shareClient].customConcurrentCount = 3;
        [QCloudHTTPSessionManager shareClient].maxConcurrencyTask = 5;
        _coderQueue = [[NSOperationQueue alloc]init];
        _coderQueue.maxConcurrentOperationCount = 1;
        _coderQueue.name = @"com.qcloudci.coderQueue";
        _imageMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:1];
        
        
        NSMutableDictionary<NSString *, NSString *> *headerDictionary = [NSMutableDictionary dictionary];
               NSString *userAgent = nil;
       #if SD_UIKIT
               // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
               userAgent = [NSString stringWithFormat:@"CIImageDownloader_%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
       #elif SD_WATCH
               // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
               userAgent = [NSString stringWithFormat:@"CIImageDownloader_%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
       #elif SD_MAC
               userAgent = [NSString stringWithFormat:@"CIImageDownloader_%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
       #endif
               if (userAgent) {
                   if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                       NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                       if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                           userAgent = mutableUserAgent;
                       }
                   }
                   headerDictionary[@"User-Agent"] = userAgent;
               }
               headerDictionary[@"Accept"] = @"image/*,*/*;q=0.8";
               _HTTPHeaders = headerDictionary;
    }
    return self;
}

- (id<SDWebImageOperation> )downloadImageWithURL:(nullable NSURL *)url
                                                   options:(SDWebImageDownloaderOptions)options
                                                   context:(nullable SDWebImageContext *)context
                                                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                                 completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock {
    if (url == nil) {
        if (completedBlock) {
            NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorInvalidURL userInfo:@{NSLocalizedDescriptionKey : @"Image url is nil"}];
            completedBlock(nil, nil, error, YES);
        }
        return nil;
    }

    CIGetObjectRequest * request = [[CIGetObjectRequest alloc]initWithURL:url];
    if(self.timeoutInterval >0) {
        request.timeoutInterval = self.timeoutInterval;
    }
    
    request.retryPolicy.delegate = self;
    
    if(self.sleepTime >= 0){
        request.retryPolicy.sleepStep = self.sleepTime;
    }
    
    if(self.retryCount >= 0){
        request.retryPolicy.maxCount = self.retryCount;
    }
    if(self.quicWhiteList.count > 0){
        request.enableQuic = self.enableQuic && [self.quicWhiteList containsObject:request.url.host];
    }else{
        request.enableQuic = self.enableQuic;
    }
    
    
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        if(progressBlock){
            progressBlock(totalBytesDownload,totalBytesExpectedToDownload,url);
        }
    }];
    
    if(self.HTTPHeaders!= nil){
        request.customHeaders = self.HTTPHeaders;
    }
    
    [request setFinishBlock:^(id  _Nullable outputObject, NSError * _Nullable error) {
        
        [self.coderQueue addOperationWithBlock:^{
            if(!outputObject){
                if (completedBlock) {
                    if(!error){
                        completedBlock(nil, nil, error, YES);
                        return;
                    }
                    NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorInvalidURL userInfo:@{NSLocalizedDescriptionKey : @"Image data is nil"}];
                    completedBlock(nil, nil, error, YES);
                }
                return;
            }
            
            UIImage * image = [self.imageMap objectForKey:url.absoluteString];
            if(image){
                completedBlock(image, outputObject, nil, YES);
                return;
            }
            image = SDImageLoaderDecodeImageData(outputObject, url, [[self class] imageOptionsFromDownloaderOptions:options], context);
            
            if (image) {
                [self.imageMap setObject:image forKey:url.absoluteString];
                completedBlock(image, outputObject, nil, YES);
            }else{
                NSError * error1;
                
                if([outputObject respondsToSelector:NSSelectorFromString(@"decodeError")]){
                    error1 = (NSError *)[outputObject valueForKey:@"decodeError"];
                }
                
                if(!error1){
                    error1 = [NSError errorWithDomain:SDWebImageErrorDomain code:SDWebImageErrorInvalidURL userInfo:@{NSLocalizedDescriptionKey : @"Image is nil"}];
                }
                completedBlock(nil, nil, error1, YES);
            }
        }];
    }];
    QCloudHTTPRequestOperation * operation;
    @synchronized (request) {
        operation = [[QCloudHTTPRequestOperation alloc]initWithRequest:request];
        operation.sessionManager = [QCloudHTTPSessionManager shareClient];
        QCloudOperationQueue *operationQueue = [[QCloudHTTPSessionManager shareClient] valueForKey:@"operationQueue"];
        [operationQueue addOpreation:operation];
    }
    return operation;
}

+ (SDWebImageOptions)imageOptionsFromDownloaderOptions:(SDWebImageDownloaderOptions)downloadOptions {
    SDWebImageOptions options = 0;
    if (downloadOptions & SDWebImageDownloaderScaleDownLargeImages) options |= SDWebImageScaleDownLargeImages;
    if (downloadOptions & SDWebImageDownloaderDecodeFirstFrameOnly) options |= SDWebImageDecodeFirstFrameOnly;
    if (downloadOptions & SDWebImageDownloaderPreloadAllFrames) options |= SDWebImagePreloadAllFrames;
    if (downloadOptions & SDWebImageDownloaderAvoidDecodeImage) options |= SDWebImageAvoidDecodeImage;
    if (downloadOptions & SDWebImageDownloaderMatchAnimatedImageClass) options |= SDWebImageMatchAnimatedImageClass;
    
    return options;
}

- (void)setRetryCount:(int)retryCount{
    _retryCount = retryCount;
    
}

- (void)setSleepTime:(int)sleepTime{
    _sleepTime = sleepTime;
    
}

- (void)setMaxConcurrentCount:(int)maxConcurrentCount{
    [QCloudHTTPSessionManager shareClient].maxConcurrencyTask = maxConcurrentCount;
}

-(void)setCustomConcurrentCount:(int)customConcurrentCount{
    [QCloudHTTPSessionManager shareClient].customConcurrentCount = customConcurrentCount;
}

- (BOOL)shouldRetry:(QCloudURLSessionTaskData *)task error:(NSError *)error{
    if(self.canUseRetryWhenError){
        return self.canUseRetryWhenError(task,error);
    }
    return YES;
}

- (void)cancelAllDownloads {
    [[QCloudHTTPSessionManager shareClient] cancelAllRequest];
}

- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field {
    if (!field) {
        return;
    }
    [self.HTTPHeaders setValue:value forKey:field];
}

- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field {
    if (!field) {
        return nil;
    }
    NSString *value = [self.HTTPHeaders objectForKey:field];
    return value;
}

@end

@implementation CIImageDownloader (SDImageLoader)

- (BOOL)canRequestImageForURL:(NSURL *)url {
    return [self canRequestImageForURL:url options:0 context:nil];
}

- (BOOL)canRequestImageForURL:(NSURL *)url options:(SDWebImageOptions)options context:(SDWebImageContext *)context {
    if (!url) {
        return NO;
    }
    
    if(self.canUseCIImageDownloader){
        return self.canUseCIImageDownloader(url,options,context);
    }else{
        return [url.absoluteString containsString:@"/format/tpg"] ||[url.absoluteString containsString:@"/format/avif"];
    }
}

- (id<SDWebImageOperation>)requestImageWithURL:(NSURL *)url options:(SDWebImageOptions)options context:(SDWebImageContext *)context progress:(SDImageLoaderProgressBlock)progressBlock completed:(SDImageLoaderCompletedBlock)completedBlock {
    UIImage *cachedImage = context[SDWebImageContextLoaderCachedImage];
    
    SDWebImageDownloaderOptions downloaderOptions = 0;
    if (options & SDWebImageLowPriority) downloaderOptions |= SDWebImageDownloaderLowPriority;
    if (options & SDWebImageProgressiveLoad) downloaderOptions |= SDWebImageDownloaderProgressiveLoad;
    if (options & SDWebImageRefreshCached) downloaderOptions |= SDWebImageDownloaderUseNSURLCache;
    if (options & SDWebImageContinueInBackground) downloaderOptions |= SDWebImageDownloaderContinueInBackground;
    if (options & SDWebImageHandleCookies) downloaderOptions |= SDWebImageDownloaderHandleCookies;
    if (options & SDWebImageAllowInvalidSSLCertificates) downloaderOptions |= SDWebImageDownloaderAllowInvalidSSLCertificates;
    if (options & SDWebImageHighPriority) downloaderOptions |= SDWebImageDownloaderHighPriority;
    if (options & SDWebImageScaleDownLargeImages) downloaderOptions |= SDWebImageDownloaderScaleDownLargeImages;
    if (options & SDWebImageAvoidDecodeImage) downloaderOptions |= SDWebImageDownloaderAvoidDecodeImage;
    if (options & SDWebImageDecodeFirstFrameOnly) downloaderOptions |= SDWebImageDownloaderDecodeFirstFrameOnly;
    if (options & SDWebImagePreloadAllFrames) downloaderOptions |= SDWebImageDownloaderPreloadAllFrames;
    if (options & SDWebImageMatchAnimatedImageClass) downloaderOptions |= SDWebImageDownloaderMatchAnimatedImageClass;
    
    if (cachedImage && options & SDWebImageRefreshCached) {
        // force progressive off if image already cached but forced refreshing
        downloaderOptions &= ~SDWebImageDownloaderProgressiveLoad;
        // ignore image read from NSURLCache if image if cached but force refreshing
        downloaderOptions |= SDWebImageDownloaderIgnoreCachedResponse;
    }
    
    return [self downloadImageWithURL:url options:downloaderOptions context:context progress:progressBlock completed:completedBlock];
}

- (BOOL)shouldBlockFailedURLWithURL:(NSURL *)url error:(NSError *)error {
    return [self shouldBlockFailedURLWithURL:url error:error options:0 context:nil];
}

- (BOOL)shouldBlockFailedURLWithURL:(NSURL *)url error:(NSError *)error options:(SDWebImageOptions)options context:(SDWebImageContext *)context {
    BOOL shouldBlockFailedURL;
    // Filter the error domain and check error codes
    if ([error.domain isEqualToString:SDWebImageErrorDomain]) {
        shouldBlockFailedURL = (   error.code == SDWebImageErrorInvalidURL
                                || error.code == SDWebImageErrorBadImageData);
    } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
        shouldBlockFailedURL = (   error.code != NSURLErrorNotConnectedToInternet
                                && error.code != NSURLErrorCancelled
                                && error.code != NSURLErrorTimedOut
                                && error.code != NSURLErrorInternationalRoamingOff
                                && error.code != NSURLErrorDataNotAllowed
                                && error.code != NSURLErrorCannotFindHost
                                && error.code != NSURLErrorCannotConnectToHost
                                && error.code != NSURLErrorNetworkConnectionLost);
    } else {
        shouldBlockFailedURL = NO;
    }
    return shouldBlockFailedURL;
}
@end
