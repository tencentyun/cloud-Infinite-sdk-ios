//
//  AVIFDecoderHelper.m
//  CloudInfinite
//
//  Created by garenwang on 2021/11/17.
//
#import "AVIFDecoderHelper.h"
#import "UIImage+AVIFDecode.h"
#import "CIQualityDataUploader.h"

@implementation AVIFDecoderHelper

+ (UIImage *)imageDataDecode:(NSData *)imageData error:(NSError * __autoreleasing*)error{
    __block UIImage *image;
    if (imageData == nil) {
        if(error != NULL){
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:40000 userInfo:@{NSLocalizedDescriptionKey:@"AVIFDecoderHelper:imageDataDecode 图片二进制数据异常"}];
            NSLog(@"AVIFDecoderHelper_error=:%@",*error);
        }
        
        return nil;
    }
    
    __block  NSError * localError = nil;
     if ([self isAVIFImage:imageData]) {
     
         dispatch_semaphore_t semap = dispatch_semaphore_create(0);
         
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             image = [UIImage AVIFImageWithContentsOfData:imageData error:&localError];
             dispatch_semaphore_signal(semap);
         });
         
         dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
         
         if (image == nil) {
             if(localError == nil){
                 localError = [NSError errorWithDomain:NSCocoaErrorDomain code:40001 userInfo:@{NSLocalizedDescriptionKey:@"AVIFDecoderHelper:imageDataDecode AVIF图片解码失败",Kimage_format:@"avif"}];
             }
             if([imageData respondsToSelector:NSSelectorFromString(@"decodeError")]){[imageData setValue:localError forKey:@"decodeError"];}
             if(error != NULL) {*error = localError;}
             return nil;
         }
     }else{
         image = [UIImage imageWithData:imageData];
         if (image == nil) {
             if(localError == nil){
                 localError = [NSError errorWithDomain:NSCocoaErrorDomain code:40002 userInfo:@{NSLocalizedDescriptionKey:@"AVIFDecoderHelper:imageDataDecode 非AVIF二进制数据转图片失败",Kimage_format:@"avif"}];
             }
             if([imageData respondsToSelector:NSSelectorFromString(@"decodeError")]){[imageData setValue:localError forKey:@"decodeError"];}
             if(error != NULL) {*error = localError;}
             return nil;
         }
         
     }
     
    return image;
}

+ (BOOL)isAVIFImage:(NSData *)data{
    
    if (data.length < 15) {
        return NO;
    }
    
    NSString *numStr = @"";
    for (int i = 4; i <= 13; i ++) {
        char char1 = 0;
        [data getBytes:&char1 range:NSMakeRange(i, 1)];
        numStr = [numStr stringByAppendingString:[NSString stringWithFormat:@"%c",char1]];
    }
    if ([numStr isEqualToString:@"ftypavif"] || [numStr isEqualToString:@"ftypavis"]) {
        return YES;
    }
    return NO;
}
@end
