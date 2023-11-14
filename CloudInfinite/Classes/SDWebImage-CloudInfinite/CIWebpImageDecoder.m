//
//  CIWebpImageDecoder.m
//  CloudInfinite
//
//  Created by garenwang on 2020/8/19.
//

#import "CIWebpImageDecoder.h"

@implementation CIWebpImageDecoder
+ (void)load{
    
    [[SDImageCodersManager sharedManager] addCoder:[CIWebpImageDecoder new]];
}

- (BOOL)canDecodeFromData:(nullable NSData *)data{
    if (data == nil || data.length == 0) {
        return NO;
    }
    return [self isWebpImage:data];
}

- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data
                                   options:(nullable SDImageCoderOptions *)options{{
    
    if (data == nil) {
        return nil;
    }
    
    Class clazz = NSClassFromString(@"SDImageWebPCoder");
    id <SDImageCoder> decoder;
    if ([clazz respondsToSelector:@selector(sharedCoder)]) {
        decoder = [clazz performSelector:@selector(sharedCoder)];
    }else{
        decoder = [clazz new];
    }
    
    if (decoder != nil) {
        if ([decoder respondsToSelector:@selector(decodedImageWithData:options:)]) {
            __block UIImage * image;
            dispatch_semaphore_t semap = dispatch_semaphore_create(0);
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                image = [decoder decodedImageWithData:data options:options];
                dispatch_semaphore_signal(semap);
            });
            
            dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
            return image;
        }
    }else{
        NSLog(@"ERROR CIWebpImageDecoder 如需WEBP解码功能，请在podfile文件中依赖:'SDWebImageWebPCoder'");
    }
    
    return nil;
}}

- (BOOL)isWebpImage:(NSData *)data{
    
    if (data.length >= 12) {
        NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
        if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canEncodeToFormat:(SDImageFormat)format {
    return NO;
}


- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format options:(nullable SDImageCoderOptions *)options {
    return nil;
}

@end
