//
//  TPGImageDecoder.m
//  CloudInfinite
//
//  Created by garenwang on 2020/7/24.
//

#import "TPGImageDecoder.h"

/// 当请求方式为urlfooter时 直接将该解码器添加到sd，实现自动解码；
@implementation TPGImageDecoder

+ (void)load{
    
   [[SDImageCodersManager sharedManager] addCoder:[TPGImageDecoder new]];
}

- (BOOL)canDecodeFromData:(nullable NSData *)data{
    if (data == nil || data.length == 0) {
        return NO;
    }
    return [self isTPGImage:data];
}

- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data
                                   options:(nullable SDImageCoderOptions *)options{
    if (data == nil) {
        return nil;
    }
    
    Class clazz = NSClassFromString(@"TPGDecoderHelper");
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
        NSLog(@"ERROR TPGImageDecoder 如需TPG解码功能，请在podfile文件中依赖：CloudInfinite/TPG 模块");
    }
    
    return nil;
}

- (BOOL)canEncodeToFormat:(SDImageFormat)format {
    return NO;
}


- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format options:(nullable SDImageCoderOptions *)options {
    return nil;
}


- (BOOL)isTPGImage:(NSData *)data{
    
    char char1 = 0 ;char char2 =0 ;char char3 = 0;
    
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    
    [data getBytes:&char3 range:NSMakeRange(2, 1)];
    
    NSString *numStr = [NSString stringWithFormat:@"%c%c%c",char1,char2,char3];
    if ([numStr isEqualToString:@"TPG"]) {
        return YES;
    }
    return NO;
}

@end
