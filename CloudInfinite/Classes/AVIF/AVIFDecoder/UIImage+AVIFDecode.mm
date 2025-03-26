//
//  UIImage+AVIFDecode.m
//  CloudInfinite
//
//  Created by garenwang on 2020/7/15.
//  Copyright © 2020 garenwang. All rights reserved.
//

#include <mach/mach_time.h>
#import "UIImage+AVIFDecode.h"
#import "avif.h"
#include <sys/stat.h>
#import <UIKit/UIKit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#import "CIQualityDataUploader.h"
#include "internal.h"
@implementation UIImage (AVIFDecode)

#define NAL_TYPE_EXIF_INFO    0x1000

UIImage* decodeAVIF(NSData * data,int scale ,CGRect rect,NSError ** error)
{
    int beaconWidth;
    int beaconHeight;
    if(scale < 1){
        scale = 1;
    }
    
    if (scale > 0 && !CGRectEqualToRect(rect, CGRectZero)) {
        rect.size.width = rect.size.width / scale;
        rect.size.height =rect.size.height / scale;
        int tempW = rect.origin.x / scale;
        rect.origin.x = tempW - (tempW % 2);
        
        int tempH = rect.origin.y / scale;
        rect.origin.y = tempH - (tempH % 2);
    }
    
    NSMutableArray * images = [NSMutableArray new];
    avifImage* image = avifImageCreateEmpty();  // 创建AVIF的image实例,用以存储进入解码器前的YUV图像数据
    if (!image) {
    }
    avifRGBImage rgb;

    unsigned char *src_data = (unsigned char *)[data bytes];
    int src_size = (int)data.length;
    avifDecoder * avif_decoder = avifDecoderCreate();

    avifResult result = avifDecoderSetIOMemory(avif_decoder, (const uint8_t*)src_data, src_size);   // 根据图像数据初始化解码器(识别是否是动图\是否使用alpha通道)
    if (result != AVIF_RESULT_OK) {
        [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 94:avifDecoderSetIOMemory",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
        if(error != NULL){ // NSCocoaErrorDomain
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 94:avifDecoderSetIOMemory",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
        }
        return nil;
    }
    result = avifDecoderParse(avif_decoder);
    if (result != AVIF_RESULT_OK) {
        [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 98:avifDecoderParse",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
        
        if(error != NULL){ // NSLocalizedDescriptionKey
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 98:avifDecoderParse",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
        }
        return nil;
    }

    int width = avif_decoder->image->width;     // AVIF解码器探测到的待解码数据信息
    int height = avif_decoder->image->height;
    beaconWidth = width;
    beaconHeight = height;
    bool has_alpha = avif_decoder->alphaPresent;
    int total_frames = avif_decoder->imageCount;

    if(rect.origin.x < 0){
        rect.origin.x = 0;
    }
    
    if(rect.origin.y < 0){
        rect.origin.y = 0;
    }
    
    if (rect.size.width + rect.origin.x > (width / scale) ) {
        rect.size.width = (width / scale) - rect.origin.x;
    }
    
    if (rect.size.height + rect.origin.y > (height / scale)) {
        rect.size.height = (height / scale) - rect.origin.y;
    }
    

    
    uint64_t duration = 0;
    for (int idx=0;idx<total_frames;idx++) {
        avifImageTiming outtiming = {0};    // 动图delay延时数据结构体
        result = avifDecoderNthImageTiming(avif_decoder, idx, &outtiming);
        uint64_t timescale = outtiming.timescale;    // 动图delay的拍率(一秒x拍)
        duration += outtiming.durationInTimescales;  //  delay拍数
        if (result != AVIF_RESULT_OK || timescale <= 0 || duration <= 0) {
            
            [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 141:avifDecoderNthImageTiming",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
            if(error != NULL){ // NSLocalizedDescriptionKey
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 141:avifDecoderNthImageTiming",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
            }
            break;
        }
        result = avifDecoderNextImage(avif_decoder);    //  调用AVIF解码
        if (result != AVIF_RESULT_OK) {
            [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 146:avifDecoderNextImage",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
            
            if(error != NULL){ // NSLocalizedDescriptionKey
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 146:avifDecoderNextImage",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
            }
            break;
        }
        

        avifImageCopy(image, avif_decoder->image, AVIF_PLANES_ALL); //  取出解码器中的图像数据到image对象中,当前仍为YUV数据
        if (scale > 1) {
            avifBool result = avifImageScale(image, width / scale, height / scale, NULL);
            if (result != 1) {
                [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 146:avifImageScale",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
                if(error != NULL){ // NSLocalizedDescriptionKey
                    *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 146:avifImageScale",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
                }
                break;
            }
        }
        
        avifImage *rectImage = NULL;
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            avifCropRect dstRect;
            dstRect.x = rect.origin.x;
            dstRect.y = rect.origin.y;
            dstRect.width = rect.size.width;
            dstRect.height = rect.size.height;
            
            rectImage = avifImageCreateEmpty();
            avifResult result = avifImageSetViewRect(rectImage, image, &dstRect);
            
            if(result != AVIF_RESULT_OK) {
                [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 165:avifImageSetViewRect",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
                if(error != NULL){ // NSLocalizedDescriptionKey
                    *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 165:avifImageSetViewRect",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
                }
                break;
              }
        }
        
        avifRGBImageSetDefaults(&rgb, rectImage?:image); // 根据解码器设置RGB输入原图像格式
        if (has_alpha!=true) {
            rgb.format = AVIF_RGB_FORMAT_RGB;   // 不带alpha通道的, 即RGB三通道图像数据
            rgb.rowBytes = avif_decoder->image->width*3;
        }else {
            rgb.format = AVIF_RGB_FORMAT_RGBA;  // 带alpha通道的,
        }
        rgb.chromaUpsampling = AVIF_CHROMA_UPSAMPLING_FASTEST;
        rgb.depth = 8;  // 目前都采用8位输出
        avifRGBImageAllocatePixels(&rgb);   //初始化RGB对象内存
        
        result = avifImageYUVToRGB(rectImage?:image, &rgb);
        if (result != AVIF_RESULT_OK) { // YUV转RGB
            [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 177:avifImageYUVToRGB",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
            if(error != NULL){ // NSLocalizedDescriptionKey
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"UIImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data) + 177:avifImageYUVToRGB",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg"}];
            }
            break;
        }
        
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            rgb.width = rect.size.width;
            rgb.height = rect.size.height;
        }else{
            rgb.width = width / scale;
            rgb.height = height / scale;
        }
        NSData *iccData = nil;
         if (image->icc.size > 0) {
             iccData = [NSData dataWithBytes:image->icc.data length:image->icc.size];
         }
        UIImage *img = convertAvifRGBImageToUIImage(rgb,iccData);
        if (image) {
            [images addObject:img];
        }
        if (rectImage != NULL) {
            avifImageDestroy(rectImage);
            rectImage = NULL;
        }
        avifRGBImageFreePixels(&rgb);
    }
    // 释放AVIF资源
    
    avifImageDestroy(image);
    // 释放IM相关资源
    avifDecoderDestroy(avif_decoder);
    
    UIImage * resultImage;
    if (images.count > 1) {
        resultImage = [UIImage animatedImageWithImages: [images copy] duration:(duration/1000.f)];
    }else{
        resultImage = images.firstObject;
    }
    if(resultImage != nil && !CGSizeEqualToSize(resultImage.size, CGSizeZero)){
        [CIQualityDataUploader startReportSuccessEventKey:KEvent_key_decode paramters:@{Kdecode_success:@(1),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg",Kanimation_count:@(images.count)}];
        
    }else{
        [CIQualityDataUploader startReportFailureEventKey:KEvent_key_decode paramters:@{Kerror_code:@(result).stringValue,Kerror_message:@"IImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data):resultImage==nil||resultImage.size==CGSizeZero",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg",Kanimation_count:@(images.count)}];
        if(error != NULL){ // NSLocalizedDescriptionKey
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:result userInfo:@{NSLocalizedDescriptionKey:@"IImage+AVIFDecode.m:UIImage* decodeAVIF(NSData * data):resultImage==nil||resultImage.size==CGSizeZero",Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Koriginal_width:@(beaconWidth),Koriginal_height:@(beaconHeight),Kdecode_sample:@(scale),Kdecode_sample:@(scale),Kdecode_width:@(rect.size.width),Kdecode_height:@(rect.size.height),Kdecode_x:@(rect.origin.x),Kdecode_y:@(rect.origin.y),Kimage_format:@"avif",Kdata_size:@(src_size),Kanimation:@(0),Kdecode_target_format:@"jpg",Kanimation_count:@(images.count)}];
        }
    }
    return resultImage;
}

UIImage * convertAvifRGBImageToUIImage(avifRGBImage avifRGBImage, NSData * iccData) {
    int width = avifRGBImage.width;
    int height = avifRGBImage.height;
    if (width <= 0 || height <= 0 || avifRGBImage.pixels == NULL) {
        return nil;
    }
    
    // 1. 判断 Alpha 通道
    BOOL hasAlpha = (avifRGBImage.format == AVIF_RGB_FORMAT_RGBA || avifRGBImage.format == AVIF_RGB_FORMAT_ARGB);
    size_t components = 3 + (hasAlpha ? 1 : 0);
    
    // 2. 计算位深
    BOOL usesU16 = avifRGBImage.depth > 8;
    size_t bitsPerComponent = usesU16 ? 16 : 8;
    size_t bytesPerPixel = (components * bitsPerComponent) / 8;
    size_t rowBytes = avifRGBImage.rowBytes;
    
    // 3. 校验行字节数
    size_t expectedBytesPerRow = bytesPerPixel * width;
    if (rowBytes < expectedBytesPerRow) {
        return nil;
    }
    
    // 4. 设置 BitmapInfo
    CGBitmapInfo bitmapInfo = usesU16 ? kCGBitmapByteOrder16Little : kCGBitmapByteOrderDefault;
    if (hasAlpha) {
        if (avifRGBImage.format == AVIF_RGB_FORMAT_RGBA) {
            bitmapInfo |= kCGImageAlphaLast;
        } else if (avifRGBImage.format == AVIF_RGB_FORMAT_ARGB) {
            bitmapInfo |= kCGImageAlphaFirst;
        }
    } else {
        bitmapInfo |= kCGImageAlphaNone;
    }
    
    // 5. 创建 Data Provider
    CFDataRef data = CFDataCreate(kCFAllocatorDefault, avifRGBImage.pixels, rowBytes * height);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CFRelease(data);
    
    // 6. 创建 Color Space
    CGColorSpaceRef colorSpace = NULL;
    if (iccData) {
        colorSpace = CGColorSpaceCreateWithICCProfile((__bridge CFDataRef)iccData);
    }
    if (!colorSpace) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    if (!colorSpace) {
        CGDataProviderRelease(provider);
        return nil;
    }
    
    // 7. 创建 CGImage
    CGImageRef cgImage = CGImageCreate(
        width,
        height,
        bitsPerComponent,
        bitsPerComponent * components,
        rowBytes,
        colorSpace,
        bitmapInfo,
        provider,
        NULL,
        NO,
        kCGRenderingIntentDefault
    );
    
    // 8. 清理资源
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    
    if (!cgImage) {
        return nil;
    }
    
    // 9. 生成 UIImage
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

+(UIImage*)AVIFImageWithContentsOfData:(NSData*)data error:(NSError * __autoreleasing*)error{
    return decodeAVIF([[data mutableCopy] copy],1,CGRectZero,error);
}

+(UIImage*)AVIFImageWithContentsOfData:(NSData *)data scale:(int)scale rect:(CGRect)rect error:(NSError * __autoreleasing*)error{
    return decodeAVIF([[data mutableCopy] copy],scale,rect,error);
}

+(UIImage*)AVIFImageWithContentsOfData:(NSData *)data scale:(int)scale rect:(CGRect)rect{
    return decodeAVIF([[data mutableCopy] copy],scale,rect,NULL);
}

+(UIImage*)AVIFImageWithContentsOfData:(NSData*)data{
    return decodeAVIF([[data mutableCopy] copy],1,CGRectZero,NULL);
}


@end
