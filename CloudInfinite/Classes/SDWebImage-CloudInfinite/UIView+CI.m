//
//  UIView+CI.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/7.
//

#import "UIView+CI.h"
#import "CIDownloaderConfig.h"

#import "CIMemoryCache.h"
#import "CIWebImageDownloader.h"
#import "CIDownloaderManager.h"
#import <objc/runtime.h>
#import "TPGImageDecoder.h"
#import "AVIFImageDecoder.h"

@implementation UIView (CI)

static CILoadTPGAVIFImageErrorHandler _handler;

static CITPGAVIFImageErrorObserver _observser;

static BOOL _isOpen;

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method system = class_getInstanceMethod([UIView class], @selector(sd_inner_internalSetImageWithURL:placeholderImage:options:context:setImageBlock:progress:completed:));
        //获取自己方法结构体
        Method own = class_getInstanceMethod([UIView class], @selector(sd_internalSetImageWithURL:placeholderImage:options:context:setImageBlock:progress:completed:));
        method_exchangeImplementations(system, own);
    });
}

+(void)setLoadOriginalImageWhenError:(BOOL)open{
    _isOpen = open;
}

+(BOOL)isOpenLoadOriginalImageWhenError{
    return _isOpen;
}


+(void)setLoadTPGAVIFImageErrorHandler:(CILoadTPGAVIFImageErrorHandler)handler{
    _handler = handler;
}

+(void)setTPGAVIFImageErrorObserver:(CITPGAVIFImageErrorObserver)observser{
    _observser = observser;
}

- (void)sd_inner_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                           context:(nullable SDWebImageContext *)context
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable SDImageLoaderProgressBlock)progressBlock
                               completed:(nullable SDInternalCompletionBlock)completedBlock {
    
    if (context != nil) {
        NSMutableDictionary * mcontext = [context mutableCopy];
        
        id<SDImageLoader> tempLoader = context[SDWebImageContextImageLoader];
        if([NSStringFromClass(tempLoader.class) isEqualToString:@"CIImageDownloader"]){
            [mcontext removeObjectForKey:SDWebImageContextImageLoader];
        }
        
        Class cla = NSClassFromString(@"CIImageDownloader");
        id<SDImageLoader> loader = [cla performSelector:NSSelectorFromString(@"sharedDownloader")];
        if(cla && [cla conformsToProtocol:@protocol(SDImageLoader)] && [loader canRequestImageForURL:url]){
            [mcontext setObject:loader forKey:SDWebImageContextImageLoader];
        }
        context= [mcontext copy];
    }else{
        Class cla = NSClassFromString(@"CIImageDownloader");
        id<SDImageLoader> loader = [cla performSelector:NSSelectorFromString(@"sharedDownloader")];
        if(cla && [cla conformsToProtocol:@protocol(SDImageLoader)] && [loader canRequestImageForURL:url]){
            context = @{SDWebImageContextImageLoader:loader};
        }
        
    }
    
    [self sd_inner_internalSetImageWithURL:url placeholderImage:placeholder options:options context:context setImageBlock:setImageBlock progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        if(([imageURL.absoluteString rangeOfString:@"format/tpg"].length > 0|| [imageURL.absoluteString rangeOfString:@"format/avif"].length > 0) && (image == nil || CGSizeEqualToSize(image.size, CGSizeZero) || error != nil)){
            if(_observser){
                _observser(imageURL.absoluteString,error);
            }
        }
        
        if([UIView isOpenLoadOriginalImageWhenError] && ([imageURL.absoluteString rangeOfString:@"format/tpg"].length > 0|| [imageURL.absoluteString rangeOfString:@"format/avif"].length > 0) && (image == nil || CGSizeEqualToSize(image.size, CGSizeZero) || error != nil)){
            if(error){
                NSLog(@"TPG、AVIF解码错误error = %@ imageURL = %@",error,imageURL);
            }
            
            NSString * orgUrlString;
            if(_handler){
                orgUrlString = _handler(imageURL.absoluteString);
            }else{
                orgUrlString = [self transferOrgUrlString:imageURL.absoluteString];
            }
            
            if(orgUrlString){
                NSURL * orgUrl = [NSURL URLWithString:orgUrlString];
                [self sd_inner_internalSetImageWithURL:orgUrl placeholderImage:placeholder options:options context:context setImageBlock:setImageBlock progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error1, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    completedBlock(image,data,error1,cacheType,finished,imageURL);
                }];
            }
        }else {
            completedBlock(image,data,error,cacheType,finished,imageURL);
        }
    }];
}

-(NSString *)transferOrgUrlString:(NSString *)orgUrlString{
    if(orgUrlString.length == 0){
        return nil;
    }

    if([orgUrlString rangeOfString:@"/format/avif"].length > 0 ||[orgUrlString rangeOfString:@"/format/tpg"].length > 0){
        orgUrlString = [orgUrlString stringByReplacingOccurrencesOfString:@"/format/avif" withString:@""];
        orgUrlString = [orgUrlString stringByReplacingOccurrencesOfString:@"/format/tpg" withString:@""];
        if([orgUrlString rangeOfString:@"imageMogr2/"].length == 0 &&
           [orgUrlString rangeOfString:@"imageMogr2%7C"].length == 0 &&
           [orgUrlString rangeOfString:@"imageMogr2"].length > 0){
            orgUrlString = [orgUrlString stringByReplacingOccurrencesOfString:@"imageMogr2" withString:@""];
        } else if([orgUrlString rangeOfString:@"imageMogr2%7C"].length > 0){
            orgUrlString = [orgUrlString stringByReplacingOccurrencesOfString:@"imageMogr2%7C" withString:@""];
        }
        return orgUrlString;
    } else {
        return nil;
    }
}

-(void)sd_CI_preloadWithAveColor:(NSString *)urlStr{
    [self sd_CI_preloadWithAveColor:urlStr completed:nil];
}

-(void)sd_CI_preloadWithAveColor:(NSString *)urlStr
                 completed:(nullable void(^)(UIColor * color)) aveColorBlock{
    if ([urlStr containsString:@"?"]) {
        urlStr = [[urlStr componentsSeparatedByString:@"?"] firstObject];
    }
    
    urlStr = [urlStr stringByAppendingString:@"?imageAve"];
    NSURL * tempUrl = [NSURL URLWithString:urlStr];
    SDWebImageMutableContext *mutableContext = [NSMutableDictionary new];
    mutableContext[SDWebImageContextSetImageOperationKey] = urlStr;
    [self sd_internalSetImageWithURL:tempUrl placeholderImage:nil options:SDWebImageAvoidAutoSetImage context:mutableContext setImageBlock:nil progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (data == nil && image == nil) {
            if (aveColorBlock) {
                aveColorBlock(nil);
            }
            return;
        }
        
        if (data == nil) {
            UIColor *color = [self colorAtPixel:CGPointMake(1, 1) image:image];
            self.backgroundColor = color;
            if (aveColorBlock) {
                aveColorBlock(color);
            }
        }else{
            
            NSDictionary * colorDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
            if (colorDic == nil) {
                if (aveColorBlock) {
                    aveColorBlock(nil);
                }
                return;
            }
            
            UIColor * aveColor;
            
            NSString * colorStr = colorDic[@"RGB"];
            if (colorStr.length == 8) {
                int red = (int)strtoul([[colorStr substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
                int green = (int)strtoul([[colorStr substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
                int blue = (int)strtoul([[colorStr substringWithRange:NSMakeRange(6, 2)] UTF8String], 0, 16);
                aveColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
                self.backgroundColor = aveColor;
            }
            if (aveColorBlock) {
                aveColorBlock(aveColor);
            }
            
        }
        
    }];
}

- (UIColor *)colorAtPixel:(CGPoint)point image:(UIImage *)image{
    
    // Cancel if point is outside image coordinates
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }

    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = image.CGImage;
    
    NSUInteger width = image.size.width;
    
    NSUInteger height = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 
                                                 1,
                                                 
                                                 1,
                                                 
                                                 bitsPerComponent,
                                                 
                                                 bytesPerRow,
                                                 
                                                 colorSpace,
                                                 
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    
    
    // Draw the pixel we are interested in onto the bitmap context
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    
    CGContextRelease(context);
    
    
    
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}


- (void)sd_CI_internalSetImageWithURL:(nullable NSURL *)url
                      placeholderImage:(nullable UIImage *)placeholder
                               options:(SDWebImageOptions)options
                        transformation:(nullable CITransformation *)transform
                               context:(nullable SDWebImageContext *)context
                         setImageBlock:(nullable SDSetImageBlock)setImageBlock
                              progress:(nullable SDImageLoaderProgressBlock)progressBlock
                             completed:(nullable SDInternalCompletionBlock)completedBlock{
    
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    if (transform == nil) {
//        如果没有任何操作，则直接走sd加载图片方法；如果url本身就是tpg，则回来会自动解码；
        [self sd_internalSetImageWithURL:url placeholderImage:placeholder options:options context:context setImageBlock:setImageBlock progress:progressBlock completed:completedBlock];
        return;
    }
    
    if (transform.autoSetAveColor == YES) {
        [self sd_CI_preloadWithAveColor:url.absoluteString];
    }
    
    [cloudInfinite requestWithBaseUrl:url.absoluteString transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
        if (request.header != nil) {
            
            [self sd_internalSetImageWithURL:request.url placeholderImage:placeholder options:options context:@{SDWebImageContextImageLoader:[[CIDownloaderManager sharedManager] getDownloaderWithHeader:@{@"accept":[NSString stringWithFormat:@"image/%@",request.header]}]} setImageBlock:setImageBlock progress:progressBlock completed:completedBlock];
        }else{
            [self sd_internalSetImageWithURL:request.url placeholderImage:placeholder options:options context:context setImageBlock:setImageBlock progress:progressBlock completed:completedBlock];
        }
    }];
}


- (void)sd_CI_internalSetImageWithURL:(nullable NSURL *)url
                      placeholderImage:(nullable UIImage *)placeholder
                               options:(SDWebImageOptions)options
                               context:(nullable SDWebImageContext *)context
                         setImageBlock:(nullable SDSetImageBlock)setImageBlock
                              progress:(nullable SDImageLoaderProgressBlock)progressBlock
                             completed:(nullable SDInternalCompletionBlock)completedBlock{
    CIDownloaderConfig * config = [CIDownloaderConfig sharedConfig];
    CloudInfinite * cloudInfinite = [CloudInfinite new];
    CITransformation * transform = [[CITransformation alloc]init];
    
    if (config.tpgRegularExpressions.allKeys > 0){
        
        BOOL isExit = NO;
        NSString * selectRegular;
        for (NSString * regular in config.tpgRegularExpressions.allKeys) {
            NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
            if ([numberPre evaluateWithObject:url.absoluteString]) {
                isExit = YES;
                selectRegular = regular;
                break;
            }
        }
        
        if (isExit) {
            for (NSString * regular in config.excloudeRegularExpressions) {
                NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
                if ([numberPre evaluateWithObject:url.absoluteString]) {
                    isExit = NO;
                    break;
                }
            }
        }
        
        if (isExit) {
            CILoadTypeEnum option = (CILoadTypeEnum)[[config.tpgRegularExpressions objectForKey:selectRegular] integerValue];
            [transform setFormatWith:CIImageTypeTPG options:option];
            [cloudInfinite requestWithBaseUrl:url.absoluteString transform:transform request:^(CIImageLoadRequest * _Nonnull request) {
                if (request.header != nil) {
                    NSMutableDictionary * mContext = [context mutableCopy];
                    [mContext setObject:[[CIDownloaderManager sharedManager] getDownloaderWithHeader:@{@"accept":[NSString stringWithFormat:@"image/%@",request.header]}] forKey:SDWebImageContextImageLoader];
                    
                    [self sd_CI_internalSetImageWithURL:request.url placeholderImage:placeholder options:options context:mContext setImageBlock:setImageBlock progress:progressBlock completed:completedBlock];
                }else{
                    [self sd_CI_internalSetImageWithURL:request.url placeholderImage:placeholder options:options context:context setImageBlock:setImageBlock progress:progressBlock completed:completedBlock];
                }
            }];
        }else{
            [self sd_CI_internalSetImageWithURL:url placeholderImage:placeholder options:options context:context setImageBlock:setImageBlock progress:progressBlock completed:completedBlock];
        }
    }

}
@end
