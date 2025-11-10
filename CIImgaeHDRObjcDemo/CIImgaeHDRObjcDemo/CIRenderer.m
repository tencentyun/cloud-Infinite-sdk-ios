//
//  CIRenderer.m
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import "CIRenderer.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface CIRenderer ()
@property (nonatomic, strong, readwrite) CIContext *context;
@property (nonatomic, strong) id<MTLDevice> metalDevice;
@end

@implementation CIRenderer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupContext];
    }
    return self;
}

- (void)setupContext {
    // Try to use Metal if available
    self.metalDevice = MTLCreateSystemDefaultDevice();
    
    if (self.metalDevice) {
        self.context = [CIContext contextWithMTLDevice:self.metalDevice];
        NSLog(@"Using Metal for Core Image rendering");
    } else {
        // Fallback to CPU rendering
        NSDictionary *options = @{
            kCIContextUseSoftwareRenderer: @NO
        };
        self.context = [CIContext contextWithOptions:options];
        NSLog(@"Using CPU for Core Image rendering");
    }
}

- (nullable CIImage *)renderImage:(CIImage *)inputImage withAdjustment:(CIAdjustment *)adjustment {
    if (!inputImage) {
        return nil;
    }
    
    CIImage *outputImage = inputImage;
    
    // Apply exposure adjustment
    if (fabs(adjustment.exposure) > 0.001) {
        CIFilter *exposureFilter = [CIFilter filterWithName:@"CIExposureAdjust"];
        [exposureFilter setValue:outputImage forKey:kCIInputImageKey];
        [exposureFilter setValue:@(adjustment.exposure) forKey:kCIInputEVKey];
        outputImage = exposureFilter.outputImage;
    }
    
    // Apply contrast adjustment
    if (fabs(adjustment.contrast - 1.0) > 0.001) {
        CIFilter *contrastFilter = [CIFilter filterWithName:@"CIColorControls"];
        [contrastFilter setValue:outputImage forKey:kCIInputImageKey];
        [contrastFilter setValue:@(adjustment.contrast) forKey:kCIInputContrastKey];
        outputImage = contrastFilter.outputImage;
    }
    
    // Apply saturation adjustment
    if (fabs(adjustment.saturation - 1.0) > 0.001) {
        CIFilter *saturationFilter = [CIFilter filterWithName:@"CIColorControls"];
        [saturationFilter setValue:outputImage forKey:kCIInputImageKey];
        [saturationFilter setValue:@(adjustment.saturation) forKey:kCIInputSaturationKey];
        outputImage = saturationFilter.outputImage;
    }
    
    // Apply sepia adjustment
    if (fabs(adjustment.sepia) > 0.001) {
        CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
        [sepiaFilter setValue:outputImage forKey:kCIInputImageKey];
        [sepiaFilter setValue:@(adjustment.sepia) forKey:kCIInputIntensityKey];
        outputImage = sepiaFilter.outputImage;
    }
    
    return outputImage;
}

- (nullable CGImageRef)createCGImage:(CIImage *)ciImage {
    if (!ciImage) {
        return nil;
    }
    
    // 使用HDR兼容的色彩空间和格式
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceITUR_2100_PQ);
    if (!colorSpace) {
        // 降级到标准色彩空间
        colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceDisplayP3);
    }
    
    CGImageRef result = [self.context createCGImage:ciImage 
                                           fromRect:ciImage.extent 
                                             format:kCIFormatRGB10 
                                         colorSpace:colorSpace];
    
    if (colorSpace) {
        CFRelease(colorSpace);
    }
    
    return result;
}

- (nullable NSData *)renderToJPEGData:(CIImage *)inputImage withAdjustment:(CIAdjustment *)adjustment {
    CIImage *renderedImage = [self renderImage:inputImage withAdjustment:adjustment];
    if (!renderedImage) {
        return nil;
    }
    
    NSMutableData *data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, (__bridge CFStringRef)UTTypeJPEG.identifier, 1, nil);
    
    if (!destination) {
        return nil;
    }
    
    // Create CGImage from CIImage
    CGImageRef cgImage = [self.context createCGImage:renderedImage fromRect:renderedImage.extent];
    if (!cgImage) {
        CFRelease(destination);
        return nil;
    }
    
    NSDictionary *options = @{
        (__bridge NSString *)kCGImageDestinationLossyCompressionQuality: @0.9
    };
    
    // Add the CGImage to the destination
    CGImageDestinationAddImage(destination, cgImage, (__bridge CFDictionaryRef)options);
    
    BOOL success = CGImageDestinationFinalize(destination);
    
    // Clean up
    CGImageRelease(cgImage);
    CFRelease(destination);
    
    return success ? data : nil;
}

- (BOOL)isMetalSupported {
    return self.metalDevice != nil;
}

@end
