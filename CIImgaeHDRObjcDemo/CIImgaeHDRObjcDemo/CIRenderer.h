//
//  CIRenderer.h
//  CIImageHDRObjCDemo
//
//  Created by 摩卡 on 2025.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import <Metal/Metal.h>
#import "CIAdjustment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CIRenderer : NSObject

@property (nonatomic, strong, readonly) CIContext *context;

// Initializers
- (instancetype)init;

// Rendering methods
- (nullable CIImage *)renderImage:(CIImage *)inputImage withAdjustment:(CIAdjustment *)adjustment;
- (nullable CGImageRef)createCGImage:(CIImage *)ciImage;
- (nullable NSData *)renderToJPEGData:(CIImage *)inputImage withAdjustment:(CIAdjustment *)adjustment;

// Utility methods
- (BOOL)isMetalSupported;

@end

NS_ASSUME_NONNULL_END
