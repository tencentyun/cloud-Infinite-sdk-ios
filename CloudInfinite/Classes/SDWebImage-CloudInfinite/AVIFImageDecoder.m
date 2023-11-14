//
//  AVIFImageDecoder.m
//  CloudInfinite
//
//  Created by garenwang on 2021/11/17.
//

#import "AVIFImageDecoder.h"

@implementation AVIFImageDecoder
+ (void)load{
    
   [[SDImageCodersManager sharedManager] addCoder:[AVIFImageDecoder new]];
}

- (BOOL)canDecodeFromData:(nullable NSData *)data{
    if (data == nil || data.length == 0) {
        return NO;
    }
    return [self isAVIFImage:data];
}

- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data
                                   options:(nullable SDImageCoderOptions *)options{
    if (data == nil) {
        return nil;
    }
    
    Class clazz = NSClassFromString(@"AVIFDecoderHelper");
    

    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL sel = @selector(imageDataDecode:error:);
    #pragma clang diagnostic pop
    
    if (clazz != nil) {
        if ([clazz respondsToSelector:sel]) {
            UIImage * image = [clazz performSelector:sel withObject:data withObject:nil];
            return image;
        }
    }else{
        NSLog(@"ERROR AVIFImageDecoder 如需AVIF解码功能，请在podfile文件中依赖：CloudInfinite/AVIF 模块");
    }
    
    return nil;
}

- (BOOL)canEncodeToFormat:(SDImageFormat)format {
    return NO;
}


- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format options:(nullable SDImageCoderOptions *)options {
    return nil;
}


- (BOOL)isAVIFImage:(NSData *)data{
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
